#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab: Control Agrícola (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: FUNCION Y GUARDA ---
echo -e "${YELLOW}PASO 1: Verificando Función y Cláusula de Guarda...${NC}"
if grep -qE "def\s+evaluar_fruta" "$FILE_PY" && grep -qE "if\s+.*==\s*[\"']Podrida[\"']:" "$FILE_PY"; then echo -e "${GREEN}[OK] Función y cláusula de descarte correctas.${NC}"; else echo -e "${RED}[ERROR] Falla en la función evaluar_fruta o el if para 'Podrida'.${NC}"; FAILED=1; fi

# --- PASO 2: PATTERN MATCHING ---
echo -e "\n${YELLOW}PASO 2: Verificando Pattern Matching...${NC}"
if grep -qE "match\s+" "$FILE_PY" && grep -qE "case\s+[\"']Madura[\"']:" "$FILE_PY" && grep -qE "case\s+_:" "$FILE_PY"; then echo -e "${GREEN}[OK] match-case estructurado correctamente.${NC}"; else echo -e "${RED}[ERROR] Faltan sentencias match o cases correspondientes.${NC}"; FAILED=1; fi

# --- PASO 3: CICLOS FOR Y WHILE ---
echo -e "\n${YELLOW}PASO 3: Verificando Ciclos (for y while)...${NC}"
if grep -qE "for\s+.*\s+in\s+lote_frutas:" "$FILE_PY" && grep -qE "while\s+valor_lote\s*>\s*0:" "$FILE_PY"; then echo -e "${GREEN}[OK] Ciclos validados.${NC}"; else echo -e "${RED}[ERROR] Error en el 'for' sobre lote_frutas o la condición del 'while'.${NC}"; FAILED=1; fi

# --- PASO 4: CORTOCIRCUITO Y TERNARIO ---
echo -e "\n${YELLOW}PASO 4: Verificando Cortocircuito y Operador Ternario...${NC}"
if grep -qE "if\s+.*\s+or\s+exportacion_aprobada:" "$FILE_PY"; then echo -e "${GREEN}[OK] Cortocircuito con 'or' detectado.${NC}"; else echo -e "${RED}[ERROR] Falta el 'if' usando el operador lógico 'or'.${NC}"; FAILED=1; fi
if grep -qE "clasificacion\s*=\s*[\"'].*[\"']\s+if\s+.*\s+else\s+[\"'].*[\"']" "$FILE_PY"; then echo -e "${GREEN}[OK] Ternario asignado a clasificacion detectado.${NC}"; else echo -e "${RED}[ERROR] No se usó sintaxis ternaria en la variable 'clasificacion'.${NC}"; FAILED=1; fi

# --- PASO 5: COMPILACIÓN Y SINTAXIS ---
echo -e "\n${YELLOW}PASO 5: Verificando sintaxis de Python...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "${GREEN}[OK] Sintaxis correcta.${NC}"; else echo -e "${RED}[ERROR] Error de sintaxis en Python.${NC}"; python3 -m py_compile "$FILE_PY"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 4 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }