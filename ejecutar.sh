#!/bin/bash
set -e

# Ir al directorio donde se encuentra este script
cd "$(dirname "$0")"

JAR_PATH="target/compilador-zetariano-jar-with-dependencies.jar"

# Si el JAR no existe, compilarlo primero
if [ ! -f "$JAR_PATH" ]; then
    echo "No se encontro el paquete ejecutable ($JAR_PATH)."
    echo "Iniciando compilacion automatica..."
    ./compilar.sh
fi

echo "Iniciando Compilador Zetariano (GUI)..."
java -jar "$JAR_PATH" "$@"
