# ========================================
# SCRIPT DE VERIFICACIÓN PRE-VUELO (PowerShell)
# ========================================

Write-Host "🚀 INICIANDO CHECKLIST PRE-VUELO..." -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Contadores
$ChecksPassed = 0
$ChecksTotal = 6

Write-Host ""
Write-Host "📂 1. VERIFICANDO TEMPLATE DOCKER-COMPOSE..." -ForegroundColor Yellow

if (Test-Path "infraestructura\ansible\roles\laravel-api\templates\docker-compose.yml.j2") {
    Write-Host "✅ Template docker-compose.yml.j2 encontrado" -ForegroundColor Green
    $ChecksPassed++
} else {
    Write-Host "❌ Template docker-compose.yml.j2 NO encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 2. VERIFICANDO REFERENCIA EN TASKS..." -ForegroundColor Yellow

if (Select-String -Path "infraestructura\ansible\roles\laravel-api\tasks\main.yml" -Pattern "docker-compose.yml.j2" -Quiet) {
    Write-Host "✅ Referencia correcta en tasks/main.yml" -ForegroundColor Green
    $ChecksPassed++
} else {
    Write-Host "❌ Referencia NO encontrada en tasks" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 3. VERIFICANDO CONFIGURACIÓN ANSIBLE..." -ForegroundColor Yellow

if (Test-Path "infraestructura\ansible\playbook.yml") {
    Write-Host "✅ Playbook principal encontrado" -ForegroundColor Green
    $ChecksPassed++
} else {
    Write-Host "❌ Playbook principal NO encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "🐳 4. VERIFICANDO DOCKERFILE OPTIMIZADO..." -ForegroundColor Yellow

if (Test-Path "Dockerfile") {
    $OptimizationCheck = (Select-String -Path "Dockerfile" -Pattern "Alpine|multi-stage" | Measure-Object).Count
    if ($OptimizationCheck -gt 0) {
        Write-Host "✅ Dockerfile optimizado con Alpine/Multi-stage" -ForegroundColor Green
        $ChecksPassed++
    } else {
        Write-Host "⚠️ Dockerfile existe pero puede no estar optimizado" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Dockerfile NO encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 5. VERIFICANDO PIPELINE CI/CD..." -ForegroundColor Yellow

if (Test-Path ".github\workflows\ci-cd-demo.yml") {
    Write-Host "✅ Pipeline demo encontrado (sin dependencias externas)" -ForegroundColor Green
    $ChecksPassed++
} elseif (Test-Path ".github\workflows\ci-cd.yml") {
    Write-Host "⚠️ Pipeline principal encontrado (requiere secretos)" -ForegroundColor Yellow
} else {
    Write-Host "❌ Ningún pipeline encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "🧪 6. VERIFICANDO ARCHIVOS DE TESTING..." -ForegroundColor Yellow

$TestFiles = (Get-ChildItem -Recurse -Name "*Test.php" -ErrorAction SilentlyContinue | Measure-Object).Count
if ($TestFiles -gt 0) {
    Write-Host "✅ Archivos de testing encontrados ($TestFiles tests)" -ForegroundColor Green
    $ChecksPassed++
} else {
    Write-Host "❌ No se encontraron archivos de testing" -ForegroundColor Red
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "📊 RESUMEN DE VERIFICACIÓN:" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

if ($ChecksPassed -eq $ChecksTotal) {
    Write-Host "🎉 PERFECTO: $ChecksPassed/$ChecksTotal verificaciones pasaron" -ForegroundColor Green
    Write-Host "✅ Sistema 100% listo para presentación" -ForegroundColor Green
} elseif ($ChecksPassed -ge 4) {
    Write-Host "⚠️ BUENO: $ChecksPassed/$ChecksTotal verificaciones pasaron" -ForegroundColor Yellow
    Write-Host "⚠️ Sistema mayormente listo, revisar puntos faltantes" -ForegroundColor Yellow
} else {
    Write-Host "❌ CRÍTICO: Solo $ChecksPassed/$ChecksTotal verificaciones pasaron" -ForegroundColor Red
    Write-Host "❌ Sistema NO listo, requiere correcciones" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 COMANDOS ADICIONALES DE VERIFICACIÓN:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "# Verificar conexión Docker local:"
Write-Host "docker --version; docker-compose --version"
Write-Host ""
Write-Host "# Test de contenedores (si están ejecutándose):"
Write-Host "docker-compose ps"
Write-Host ""
Write-Host "# Test de API endpoints (si la app está corriendo):"
Write-Host "curl -I http://localhost:8000/api/health"
Write-Host "curl -X GET http://localhost:8000/api/products"
Write-Host ""
Write-Host "🚀 LISTO PARA DEMO DE 15-20 MINUTOS" -ForegroundColor Green

# Salir con código adecuado
if ($ChecksPassed -ge 4) {
    exit 0
} else {
    exit 1
}