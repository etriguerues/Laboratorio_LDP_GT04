#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab 4: Simulador de Descargas (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: VARIABLES GLOBALES Y SRP ---
echo -e "${YELLOW}PASO 1: Verificando variables globales y función SRP...${NC}"
if grep -qE "archivos_descargados\s*=\s*\[\]" "$FILE_PY" && grep -qE "def\s+etiquetar_archivo" "$FILE_PY"; then echo -e "${GREEN}[OK] Variables globales y abstracción SRP preparadas.${NC}"; else echo -e "${RED}[ERROR] Falta 'archivos_descargados' o la definición de 'etiquetar_archivo'.${NC}"; FAILED=1; fi

# --- PASO 2: FUNCIONES ANIDADAS Y RECURSIVIDAD ---
echo -e "\n${YELLOW}PASO 2: Verificando Función Anidada, Caso Base y Recursividad...${NC}"
if grep -qE "def\s+iniciar_descarga" "$FILE_PY" && grep -qE "def\s+descarga_recursiva" "$FILE_PY"; then echo -e "${GREEN}[OK] Arquitectura de funciones (Scope interno) válida.${NC}"; else echo -e "${RED}[ERROR] Error en contenedor 'iniciar_descarga' o su interna 'descarga_recursiva'.${NC}"; FAILED=1; fi

if grep -qE "if\s+.*==\s*0:" "$FILE_PY" && grep -qE "return" "$FILE_PY" && grep -qE "descarga_recursiva\(.*\)" "$FILE_PY"; then echo -e "${GREEN}[OK] Caso base estricto y loop recursivo evaluados.${NC}"; else echo -e "${RED}[ERROR] No se implementó caso base '0', 'return' vacío o llamada a sí misma.${NC}"; FAILED=1; fi

# --- PASO 3: TRAMPA DE REASIGNACIÓN (VALOR VS REFERENCIA) ---
echo -e "\n${YELLOW}PASO 3: Verificando Paso por Referencia y Trampa de Reasignación...${NC}"
if grep -qE "\.append\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Métodos por referencia aplicados con éxito (.append).${NC}"; else echo -e "${RED}[ERROR] No se está poblando la lista con .append().${NC}"; FAILED=1; fi
if grep -qE "def\s+consumir_datos" "$FILE_PY" && grep -qE "=\s*0" "$FILE_PY"; then echo -e "${GREEN}[OK] Comprobación de trampa de ámbito validada.${NC}"; else echo -e "${RED}[ERROR] Falta la función 'consumir_datos' con su reasignación de variable a '0'.${NC}"; FAILED=1; fi

# --- PASO 4: COMPILACIÓN ---
echo -e "\n${YELLOW}PASO 4: Verificando sintaxis...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "${GREEN}[OK] Sintaxis Python correcta.${NC}"; else echo -e "${RED}[ERROR] Hay errores sintácticos en el archivo.${NC}"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 4 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }