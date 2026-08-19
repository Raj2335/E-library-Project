@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "CATALINA_HOME=%SCRIPT_DIR%Tomcat 9.0_Tomcat"

if not exist "%CATALINA_HOME%\bin\startup.bat" (
    echo Tomcat installation not found at "%CATALINA_HOME%"
    exit /b 1
)

if exist "%SCRIPT_DIR%target\elibrary.war" (
    echo Deploying WAR...
    copy /Y "%SCRIPT_DIR%target\elibrary.war" "%CATALINA_HOME%\webapps\ROOT.war" >nul
) else (
    echo WAR not found at "%SCRIPT_DIR%target\elibrary.war".
    echo Build it first with: mvn -DskipTests package
)

call "%CATALINA_HOME%\bin\startup.bat"
endlocal
