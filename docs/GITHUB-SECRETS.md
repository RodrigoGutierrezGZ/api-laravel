# 🔐 GitHub Secrets Configuration Guide

## **Secretos Requeridos para CI/CD Pipeline Completo**

### **Para el Pipeline de Producción (ci-cd.yml):**

```bash
# 1. CODECOV_TOKEN (Opcional - Coverage Reports)
# Obtener en: https://codecov.io/gh/RodrigoGutierrezGZ/api-laravel
CODECOV_TOKEN=xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx

# 2. SLACK_WEBHOOK (Opcional - Notificaciones)
# Obtener en: Slack → Apps → Incoming Webhooks
SLACK_WEBHOOK=https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

# 3. SSH Keys para Servidores
STAGING_SSH_KEY=-----BEGIN OPENSSH PRIVATE KEY-----
(contenido de la llave privada para staging)
-----END OPENSSH PRIVATE KEY-----

PRODUCTION_SSH_KEY=-----BEGIN OPENSSH PRIVATE KEY-----
(contenido de la llave privada para producción)
-----END OPENSSH PRIVATE KEY-----

# 4. Deploy Token (Personal Access Token)
# Crear en: GitHub → Settings → Developer settings → Personal access tokens
# Permisos: repo (full), read:packages
DEPLOY_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# 5. URLs de Entornos
STAGING_URL=https://staging.tu-dominio.com
PRODUCTION_URL=https://api.tu-dominio.com

# 6. Ansible Vault Password
ANSIBLE_VAULT_PASSWORD=tu-password-super-secreto
```

## **Cómo Configurar los Secretos:**

### **Paso 1: Ir a GitHub Repository**
```
https://github.com/RodrigoGutierrezGZ/api-laravel
→ Settings 
→ Secrets and variables 
→ Actions
```

### **Paso 2: Crear Cada Secret**
```
Click "New repository secret"
Name: [NOMBRE_DEL_SECRET]
Secret: [VALOR_DEL_SECRET]
```

## **Para Pipeline Simplificado (ci-cd-demo.yml):**

**¡Solo necesita GITHUB_TOKEN (automático)!**

Los siguientes secretos **NO** son necesarios para la demo:
- ❌ CODECOV_TOKEN
- ❌ SLACK_WEBHOOK  
- ❌ SSH Keys
- ❌ DEPLOY_TOKEN
- ❌ URLs externas
- ❌ ANSIBLE_VAULT_PASSWORD

## **Verificar Configuración:**

```bash
# En el repositorio, revisar si los secretos están configurados:
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/RodrigoGutierrezGZ/api-laravel/actions/secrets
```

## **Estados de Pipeline:**

### **✅ Listo para Demo (ci-cd-demo.yml)**
- Solo usa GITHUB_TOKEN (automático)
- Tests, build Docker, deploy demo local
- No requiere infraestructura externa

### **⚠️ Requiere Configuración (ci-cd.yml)**  
- Necesita todos los secretos listados arriba
- Requiere servidores staging/production
- Necesita configuración DNS y SSL

## **Recomendación para Evaluación:**

**Usar `ci-cd-demo.yml` para la demostración** ya que:
1. ✅ No requiere secretos externos
2. ✅ Funciona completamente en GitHub Actions
3. ✅ Demuestra todas las capacidades técnicas
4. ✅ Ejecuta tests, builds y deployment
5. ✅ Es más confiable para presentación en vivo