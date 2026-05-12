#!/bin/bash
export LANG=C.UTF-8
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab: Simulador OS"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }

echo -e "${YELLOW}PASO 1: Verificando Arreglo, Matriz y Cola Circular...${NC}"
if grep -qE "array\.array\(\s*['\"]i['\"]" "$FILE_PY" && grep -qE "\[1\]\[0\]" "$FILE_PY" && grep -qE "\.rotate\(\s*-1\s*\)" "$FILE_PY"; then echo -e "${GREEN}[OK] Estructuras estáticas y rotación de deque verificadas.${NC}"; else echo -e "${RED}[ERROR] Error en el array, coordenadas de disco_duro o no se usó .rotate(-1).${NC}"; FAILED=1; fi

echo -e "\n${YELLOW}PASO 2: Verificando Casting a Lista...${NC}"
if grep -qE "list\(.*\)" "$FILE_PY"; then echo -e "${GREEN}[OK] Casting de deque a list nativa comprobado.${NC}"; else echo -e "${RED}[ERROR] No se convirtió la cola de procesos a lista con list().${NC}"; FAILED=1; fi

echo -e "\n${YELLOW}PASO 3: Verificando Deserialización (JSON Loads)...${NC}"
if grep -qE "json\.loads\(" "$FILE_PY"; then echo -e "${GREEN}[OK] json.loads() utilizado para leer el string JSON.${NC}"; else echo -e "${RED}[ERROR] Faltó el uso de json.loads().${NC}"; FAILED=1; fi

if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "\n${GREEN}[OK] Sintaxis Python correcta.${NC}"; else echo -e "\n${RED}[ERROR] Falla sintáctica detectada.${NC}"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 4 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }
