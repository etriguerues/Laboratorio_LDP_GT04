#!/bin/bash
export LANG=C.UTF-8
python3 -m pip install pytest --user -q
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0;0m' 
FAILED=0

echo "Validando Lab 4: Rastreador Fitness"
if python3 -m py_compile "fitness.py" 2>/dev/null; then echo -e "${GREEN}✔ Compilación OK${NC}"; else echo -e "${RED}✘ Error de sintaxis${NC}"; exit 1; fi

if [ -f "test_fitness.py" ]; then
    echo -e "${GREEN}✔ Archivo test_fitness.py encontrado. Ejecutando pytest...${NC}"
    pytest test_fitness.py -q -s || FAILED=1
else
    echo -e "${RED}✘ Falta test_fitness.py${NC}"; FAILED=1
fi
[ $FAILED -eq 0 ] && exit 0 || exit 1
