#!/bin/bash
export LANG=C.UTF-8

# Colores para la salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' # Sin color

echo "--------------------------------------------------------"
echo "Iniciando validación: Menú Convertidor Multi-Función"
echo "--------------------------------------------------------"

# Variable de control de errores
FAILED=0

# Buscar el archivo .psc
FILE_PSC=$(find . -name "*.psc" | head -n 1)

if [ -z "$FILE_PSC" ]; then
    echo -e "${RED}[ERROR] No se encontró ningún archivo .psc (PSeInt).${NC}"
    exit 1
fi

echo -e "Archivo detectado: ${YELLOW}$FILE_PSC${NC}"

# --- PASO 1: VERIFICAR FUNCIONES MATEMÁTICAS ---
echo -e "\n${YELLOW}PASO 1: Verificando Funciones de Conversión...${NC}"

# Función 1: Dólares a Euros
if grep -qi "Funcion.*ConvertirDolarAEuro" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Función 'ConvertirDolarAEuro' encontrada.${NC}"
else
    echo -e "${RED}[ERROR] Falta la función 'ConvertirDolarAEuro'.${NC}"
    FAILED=1
fi

# Función 2: Km a Millas
if grep -qi "Funcion.*ConvertirKmAMillas" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Función 'ConvertirKmAMillas' encontrada.${NC}"
else
    echo -e "${RED}[ERROR] Falta la función 'ConvertirKmAMillas'.${NC}"
    FAILED=1
fi

# --- PASO 2: VERIFICAR CICLO DE MENÚ (MIENTRAS) ---
echo -e "\n${YELLOW}PASO 2: Verificando Ciclo Principal...${NC}"

# Validar Mientras que termine en 3 (opcion <> 3 o opcion != 3)
if grep -qiE "Mientras.*opcion.*(<>|!=).*3" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Ciclo 'Mientras' controlado por la opción 3 detectado.${NC}"
else
    echo -e "${RED}[ERROR] El ciclo 'Mientras' debe ejecutarse hasta que la opción sea 3.${NC}"
    FAILED=1
fi

# --- PASO 3: VERIFICAR ENRUTADOR (SEGUN) ---
echo -e "\n${YELLOW}PASO 3: Verificando Estructura SEGUN y Casos...${NC}"

# Verificar inicio de Segun
if grep -qi "Segun.*opcion.*Hacer" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Estructura 'Segun' correctamente implementada.${NC}"
else
    echo -e "${RED}[ERROR] No se encontró la estructura 'Segun opcion Hacer'.${NC}"
    FAILED=1
fi

# Verificar bloque de error obligatorio (De Otro Modo)
if grep -qi "De Otro Modo" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Bloque de validación 'De Otro Modo' detectado.${NC}"
else
    echo -e "${RED}[ERROR] Es obligatorio incluir 'De Otro Modo' para opciones inválidas.${NC}"
    FAILED=1
fi

# --- PASO 4: VARIABLES Y TIPOS ---
echo -e "\n${YELLOW}PASO 4: Verificando Definición de Variables...${NC}"

if grep -qi "opcion.*Como Entero" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Variable 'opcion' definida como Entero.${NC}"
else
    echo -e "${RED}[ERROR] La variable 'opcion' debe ser tipo Entero.${NC}"
    FAILED=1
fi

# --- RESULTADO FINAL ---
echo -e "\n--------------------------------------------------------"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✔ LABORATORIO: CONVERTIDOR APROBADO${NC}"
    exit 0
else
    echo -e "${RED}✘ EL ALGORITMO NO CUMPLE CON LOS REQUISITOS${NC}"
    exit 1
fi
