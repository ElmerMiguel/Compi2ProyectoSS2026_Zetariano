@echo off
setlocal
cd /d "%~dp0"

echo ==========================================
echo  Compilador Zetariano - Contacto Extraterrestre
echo  Proceso de Compilacion y Empaquetado
echo ==========================================

where java >nul 2>nul || (
  echo ERROR: Java no esta disponible en el PATH.
  pause
  exit /b 1
)

for /f "tokens=3" %%V in ('java -version 2^>^&1 ^| findstr /i "version"') do set "JAVA_VERSION=%%~V"
echo Java detectado: %JAVA_VERSION%

where mvn >nul 2>nul
if not errorlevel 1 (
  call mvn clean package
  goto :fin
)

set "NB_MVN=C:\Program Files\NetBeans-20\netbeans\java\maven\bin\mvn.cmd"
if exist "%NB_MVN%" (
  call "%NB_MVN%" clean package
  goto :fin
)

echo ERROR: No se encontro Maven en PATH ni en NetBeans.
pause
exit /b 1

:fin
if errorlevel 1 (
  echo ERROR: Fallo la compilacion.
  pause
  exit /b %errorlevel%
)

echo.
echo ==========================================
echo  Compilacion exitosa.
echo  JAR: target\compilador-zetariano-jar-with-dependencies.jar
echo ==========================================
pause
