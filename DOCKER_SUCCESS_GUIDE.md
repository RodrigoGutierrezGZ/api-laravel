# 🐳 GUÍA DE DEMOSTRACIÓN DOCKER - PROYECTO LARAVEL

## 🎯 ESTADO ACTUAL
- ✅ Docker Desktop instalado y funcionando  
- ✅ Dockerfile multi-stage implementado
- ✅ Docker Compose configurado
- ⏳ Build en progreso...

## 📋 COMANDOS DE VERIFICACIÓN

### 1. Verificar que Docker funciona
```powershell
docker --version
docker-compose --version
```

### 2. Construir y ejecutar (ya ejecutándose)
```powershell
cd "C:\Users\rodri\OneDrive\Desktop\ProyectoFinal\api-laravel"
docker-compose up --build -d
```

### 3. Verificar estado de contenedores
```powershell
docker-compose ps
docker ps -a
```

### 4. Ver logs de la aplicación
```powershell
docker-compose logs app
docker-compose logs mysql
```

### 5. Probar la API containerizada
```powershell
# Una vez que los contenedores estén arriba:
Invoke-RestMethod -Uri "http://localhost:8000/api/products" -Headers @{"Accept"="application/json"}
```

## 🏗️ ARQUITECTURA IMPLEMENTADA

### Multi-stage Dockerfile:
```dockerfile
# Etapa 1: Build dependencies con Composer
FROM composer:2.6 AS vendor
COPY composer.json composer.lock ./
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Etapa 2: Runtime con Alpine Linux + PHP + Nginx + Supervisor
FROM php:8.2-fpm-alpine
# Instala extensiones: pdo_mysql, bcmath, gd, zip, intl, opcache
# Configura Nginx para puerto 8000
# Configura Supervisor para gestionar procesos
```

### Docker Compose Services:
```yaml
services:
  app:                    # Laravel application
    build: .              # Usa nuestro Dockerfile
    ports: ["8000:8000"]  # Expone puerto 8000
    depends_on: [mysql]   # Espera MySQL
    
  mysql:                  # Base de datos
    image: mysql/mysql-server:8.0
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_USER: sail
      MYSQL_PASSWORD: password
```

## 🚀 COMANDOS POST-BUILD

### Una vez que el build termine:

1. **Verificar contenedores corriendo:**
```powershell
docker-compose ps
```
*Debería mostrar `app` y `mysql` en estado `Up`*

2. **Ejecutar migraciones:**
```powershell
docker-compose exec app php artisan migrate --seed
```
*Esto crea las tablas y los 32 productos de prueba*

3. **Probar API containerizada:**
```powershell
# Listar productos
curl http://localhost:8000/api/products

# O con PowerShell:
Invoke-RestMethod -Uri "http://localhost:8000/api/products" -Headers @{"Accept"="application/json"}
```

4. **Acceder al contenedor (debugging):**
```powershell
docker-compose exec app sh
```

## 🎬 SCRIPT DE DEMOSTRACIÓN

### Para la presentación:
```
"Docker está completamente implementado y funcionando:

1. 🏗️  Build multi-stage completado - Imagen optimizada con Alpine Linux
2. 🐳  Contenedores ejecutándose - App en puerto 8000, MySQL listo  
3. 🚀  API containerizada funcionando - Mismos 32 productos disponibles
4. 📦  Production-ready - Nginx + PHP-FPM + Supervisor configurados
5. 🔧  Development-friendly - Docker Compose para desarrollo local

La aplicación ahora está completamente containerizada y lista 
para deployment en cualquier entorno compatible con Docker."
```

## 🔧 TROUBLESHOOTING

### Si hay problemas:

1. **Build fallido:**
```powershell
docker-compose build --no-cache
```

2. **Contenedores no arrancan:**
```powershell
docker-compose logs app
docker-compose logs mysql
```

3. **Puerto ocupado:**
```powershell
# Cambiar puerto en docker-compose.yml: "8001:8000"
```

4. **Reset completo:**
```powershell
docker-compose down --volumes
docker-compose up --build -d
```

## 📊 MÉTRICAS ESPERADAS

- **Tiempo de build:** ~5-10 minutos (primera vez)
- **Tamaño de imagen:** ~150-200MB (vs ~500MB sin multi-stage)
- **Tiempo de startup:** <30 segundos
- **Memory usage:** ~128MB por contenedor
- **Response time:** <100ms (igual que local)

## ✅ CHECKLIST DE VERIFICACIÓN

- [ ] Docker build completo sin errores
- [ ] Contenedores `app` y `mysql` en estado `Up`  
- [ ] API responde en `http://localhost:8000/api/products`
- [ ] Base de datos conectada y con datos
- [ ] Logs sin errores críticos
- [ ] Interfaz web accesible en `http://localhost:8000/test.html`

**🎉 RESULTADO ESPERADO: Aplicación completamente containerizada y funcional**