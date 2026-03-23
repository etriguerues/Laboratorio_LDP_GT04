#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab 4: Streaming (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: FUNCIONES ---
echo -e "${YELLOW}PASO 1: Verificando Lógica y Casting...${NC}"
if grep -qE "def\s+validar_acceso" "$FILE_PY" && grep -qE "int\s*\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Función validar_acceso y casting correctos.${NC}"; else echo -e "${RED}[ERROR] Falló validación de función o casting int().${NC}"; FAILED=1; fi

# --- PASO 2: ERROR DE MUTABILIDAD INTENCIONAL ---
echo -e "\n${YELLOW}PASO 2: Verificando Error Intencional (Referencias)...${NC}"
if grep -qE "sincronizacion_nube\s*=\s*lista_reproduccion" "$FILE_PY" && ! grep -qE "sincronizacion_nube\s*=\s*lista_reproduccion\.copy\(\)" "$FILE_PY"; then
    echo -e "${GREEN}[OK] Asignación directa de memoria encontrada (Error intencional logrado).${NC}"
else
    echo -e "${RED}[ERROR] El alumno usó .copy() o no igualó las variables. Debe igualarlas directamente para ver el error de RAM.${NC}"
    FAILED=1
fi

# --- PASO 3: GARBAGE COLLECTOR ---
echo -e "\n${YELLOW}PASO 3: Verificando Garbage Collector...${NC}"
if grep -qE "lista_reproduccion\s*=\s*None" "$FILE_PY" && grep -qE "sincronizacion_nube\s*=\s*None" "$FILE_PY"; then echo -e "${GREEN}[OK] Referencias destruidas.${NC}"; else echo -e "${RED}[ERROR] Falta liberar ambas variables con None.${NC}"; FAILED=1; fi

# --- PASO 4: COMPILACIÓN Y SINTAXIS ---
echo -e "\n${YELLOW}PASO 4: Verificando sintaxis de Python...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then 
    echo -e "${GREEN}[OK] Sintaxis correcta.${NC}"
else 
    echo -e "${RED}[ERROR] Error de sintaxis en Python.${NC}"
    python3 -m py_compile "$FILE_PY"
    FAILED=1
fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 4 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }