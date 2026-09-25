#!/bin/bash
set -e

# Ir al directorio donde se encuentra este script
cd "$(dirname "$0")"

echo "=========================================="
echo " Compilador Zetariano - Contacto Extraterrestre"
echo " Proceso de Compilacion y Empaquetado"
echo "=========================================="

# Verificar Java
if ! command -v java &> /dev/null; then
    echo "ERROR: Java no esta disponible en el PATH."
    echo "Instala Java 21 LTS o superior para continuar."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
echo "Java detectado: $JAVA_VERSION"

# Verificar Maven
if ! command -v mvn &> /dev/null; then
    echo "ERROR: Maven ('mvn') no esta disponible en el PATH."
    echo "Instala Maven con: sudo apt install maven"
    exit 1
fi

echo "Iniciando compilacion completa con Maven..."
mvn clean package

echo ""
echo "=========================================="
echo " Compilacion exitosa."
echo " JAR generado en: target/compilador-zetariano-jar-with-dependencies.jar"
echo "=========================================="
