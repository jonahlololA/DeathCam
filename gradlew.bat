@echo off
setlocal
set "GRADLE_VERSION=9.5.0"
set "DIST_DIR=%USERPROFILE%\.gradle\deathcam-bootstrap\gradle-%GRADLE_VERSION%"
set "GRADLE_EXE=%DIST_DIR%\bin\gradle.bat"
if exist "%GRADLE_EXE%" goto run_gradle
set "BOOT_DIR=%USERPROFILE%\.gradle\deathcam-bootstrap"
set "ZIP=%BOOT_DIR%\gradle-%GRADLE_VERSION%-bin.zip"
if not exist "%BOOT_DIR%" mkdir "%BOOT_DIR%"
echo Gradle %GRADLE_VERSION% is not installed. Downloading it now...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%ZIP%'"
if errorlevel 1 (
  echo Failed to download Gradle. Check your internet connection and try again.
  exit /b 1
)
echo Extracting Gradle...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '%BOOT_DIR%' -Force"
if errorlevel 1 (
  echo Failed to extract Gradle.
  exit /b 1
)
:run_gradle
call "%GRADLE_EXE%" %*
exit /b %ERRORLEVEL%
