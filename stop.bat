@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "CATALINA_HOME=%SCRIPT_DIR%Tomcat 9.0_Tomcat"

if not exist "%CATALINA_HOME%\bin\shutdown.bat" (
    echo Tomcat installation not found at "%CATALINA_HOME%"
    exit /b 1
)

call "%CATALINA_HOME%\bin\shutdown.bat"
endlocal
