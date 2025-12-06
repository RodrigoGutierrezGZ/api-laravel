#!/bin/bash
# ========================================
# SCRIPT DE VERIFICACIÓN PRE-VUELO
# ========================================

echo "🚀 INICIANDO CHECKLIST PRE-VUELO..."
echo "===================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
CHECKS_PASSED=0
CHECKS_TOTAL=6

echo ""
echo "📂 1. VERIFICANDO TEMPLATE DOCKER-COMPOSE..."
if [ -f "infraestructura/ansible/roles/laravel-api/templates/docker-compose.yml.j2" ]; then
    echo -e "${GREEN}✅ Template docker-compose.yml.j2 encontrado${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}❌ Template docker-compose.yml.j2 NO encontrado${NC}"
fi

echo ""
echo "📋 2. VERIFICANDO REFERENCIA EN TASKS..."
if grep -q "docker-compose.yml.j2" infraestructura/ansible/roles/laravel-api/tasks/main.yml; then
    echo -e "${GREEN}✅ Referencia correcta en tasks/main.yml${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}❌ Referencia NO encontrada en tasks${NC}"
fi

echo ""
echo "🔧 3. VERIFICANDO CONFIGURACIÓN ANSIBLE..."
if [ -f "infraestructura/ansible/playbook.yml" ]; then
    echo -e "${GREEN}✅ Playbook principal encontrado${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}❌ Playbook principal NO encontrado${NC}"
fi

echo ""
echo "🐳 4. VERIFICANDO DOCKERFILE OPTIMIZADO..."
if [ -f "Dockerfile" ]; then
    SIZE_INFO=$(grep -c "Alpine\|multi-stage" Dockerfile)
    if [ "$SIZE_INFO" -gt 0 ]; then
        echo -e "${GREEN}✅ Dockerfile optimizado con Alpine/Multi-stage${NC}"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        echo -e "${YELLOW}⚠️ Dockerfile existe pero puede no estar optimizado${NC}"
    fi
else
    echo -e "${RED}❌ Dockerfile NO encontrado${NC}"
fi

echo ""
echo "📋 5. VERIFICANDO PIPELINE CI/CD..."
if [ -f ".github/workflows/ci-cd-demo.yml" ]; then
    echo -e "${GREEN}✅ Pipeline demo encontrado (sin dependencias externas)${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${YELLOW}⚠️ Pipeline demo no encontrado, verificando pipeline principal...${NC}"
    if [ -f ".github/workflows/ci-cd.yml" ]; then
        echo -e "${YELLOW}⚠️ Pipeline principal encontrado (requiere secretos)${NC}"
    else
        echo -e "${RED}❌ Ningún pipeline encontrado${NC}"
    fi
fi

echo ""
echo "🧪 6. VERIFICANDO ARCHIVOS DE TESTING..."
TEST_FILES=$(find . -name "*Test.php" 2>/dev/null | wc -l)
if [ "$TEST_FILES" -gt 0 ]; then
    echo -e "${GREEN}✅ Archivos de testing encontrados ($TEST_FILES tests)${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}❌ No se encontraron archivos de testing${NC}"
fi

echo ""
echo "===================================="
echo "📊 RESUMEN DE VERIFICACIÓN:"
echo "===================================="

if [ $CHECKS_PASSED -eq $CHECKS_TOTAL ]; then
    echo -e "${GREEN}🎉 PERFECTO: $CHECKS_PASSED/$CHECKS_TOTAL verificaciones pasaron${NC}"
    echo -e "${GREEN}✅ Sistema 100% listo para presentación${NC}"
elif [ $CHECKS_PASSED -ge 4 ]; then
    echo -e "${YELLOW}⚠️ BUENO: $CHECKS_PASSED/$CHECKS_TOTAL verificaciones pasaron${NC}"
    echo -e "${YELLOW}⚠️ Sistema mayormente listo, revisar puntos faltantes${NC}"
else
    echo -e "${RED}❌ CRÍTICO: Solo $CHECKS_PASSED/$CHECKS_TOTAL verificaciones pasaron${NC}"
    echo -e "${RED}❌ Sistema NO listo, requiere correcciones${NC}"
fi

echo ""
echo "🎯 COMANDOS ADICIONALES DE VERIFICACIÓN:"
echo "========================================"
echo "# Verificar conexión Docker local:"
echo "docker --version && docker-compose --version"
echo ""
echo "# Test de contenedores (si están ejecutándose):"
echo "docker-compose ps"
echo ""
echo "# Test de API endpoints (si la app está corriendo):"
echo "curl -I http://localhost:8000/api/health"
echo "curl -X GET http://localhost:8000/api/products"
echo ""
echo "🚀 LISTO PARA DEMO DE 15-20 MINUTOS"

# Salir con código de éxito si la mayoría de checks pasaron
if [ $CHECKS_PASSED -ge 4 ]; then
    exit 0
else
    exit 1
fi