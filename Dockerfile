# Etapa 1: Construcción (Build)
FROM composer:2.6 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
# Instalar dependencias sin scripts para aligerar la carga
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Etapa 2: Imagen Final de Producción (Run)
FROM php:8.2-fpm-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache \
    nginx \
    supervisor \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    icu-dev \
    freetype-dev \
    jpeg-dev

# Instalar extensiones PHP una por una para mejor debugging
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath  
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install opcache

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto desde tu máquina
COPY . .

# Copiar dependencias instaladas en la Etapa 1  
COPY --from=vendor /app/vendor/ ./vendor/

# Crear archivo .env desde .env.example si no existe
RUN cp .env.example .env || true

# Crear directorios necesarios primero
RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor \
    && mkdir -p /var/www/html/storage/logs \
    && mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Generar APP_KEY para Laravel
RUN php artisan key:generate

# Configuraciones de Nginx y Supervisor
# OPCIÓN 1: Usar archivos separados (recomendado para configuraciones complejas)
# COPY docker/nginx.conf /etc/nginx/http.d/default.conf
# COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# OPCIÓN 2: Configuraciones inline (actual - autocontenido y funcional)
RUN echo 'server { listen 8000; server_name localhost; root /var/www/html/public; index index.php; location / { try_files $uri $uri/ /index.php?$query_string; } location ~ \.php$ { fastcgi_pass 127.0.0.1:9000; fastcgi_index index.php; fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name; include fastcgi_params; } }' > /etc/nginx/http.d/default.conf

RUN echo -e '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord.log\n\n[program:php-fpm]\ncommand=php-fpm\nautostart=true\nautorestart=true\nstderr_logfile=/var/log/php-fpm.err.log\nstdout_logfile=/var/log/php-fpm.out.log\n\n[program:nginx]\ncommand=nginx -g "daemon off;"\nautostart=true\nautorestart=true\nstderr_logfile=/var/log/nginx.err.log\nstdout_logfile=/var/log/nginx.out.log' > /etc/supervisor/conf.d/supervisord.conf

# Los directorios ya fueron creados arriba

# Optimizar Laravel para producción
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache || true

# Exponer el puerto 8000 (según README infra)
EXPOSE 8000

# Comando de inicio (Inicia Supervisor, que a su vez inicia Nginx y PHP-FPM)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]