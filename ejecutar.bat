@echo off
setlocal
cd /d "%~dp0"

set "JAR_PATH=target\compilador-zetariano-jar-with-dependencies.jar"

if not exist "%JAR_PATH%" (
  echo No existe el JAR compilado (%JAR_PATH%). Se iniciara la compilacion automatica.
  call compilar.bat || (
    echo Error durante la compilacion automatica.
    pause
    exit /b 1
  )
)

echo Iniciando Compilador Zetariano (GUI)...
java -jar "%JAR_PATH%" %*
