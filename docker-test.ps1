# Script para probar Docker en el proyecto Laravel
# PowerShell script

Write-Host "🐳 Configuración Docker para API Laravel" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Navegar al directorio correcto
$projectPath = "C:\Users\rodri\OneDrive\Desktop\ProyectoFinal\api-laravel"
Set-Location $projectPath

Write-Host "📁 Directorio actual: $(Get-Location)" -ForegroundColor Green

# Verificar archivos necesarios
$requiredFiles = @("Dockerfile", "docker-compose.yml", "composer.json")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file - Encontrado" -ForegroundColor Green
    } else {
        Write-Host "❌ $file - NO encontrado" -ForegroundColor Red
    }
}

Write-Host "`n🔨 Comandos Docker disponibles:" -ForegroundColor Yellow
Write-Host "1. docker build -t api-laravel ." -ForegroundColor Gray
Write-Host "2. docker-compose up --build -d" -ForegroundColor Gray  
Write-Host "3. docker-compose ps" -ForegroundColor Gray
Write-Host "4. docker-compose logs app" -ForegroundColor Gray

Write-Host "`n🚀 Para ejecutar, usar desde este directorio:" -ForegroundColor Cyan
Write-Host $projectPath -ForegroundColor White