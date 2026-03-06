@echo off
setlocal
cd /d "%~dp0"

if not exist node_modules (
  echo [Mission Control] Installing dependencies...
  call npm install
  if errorlevel 1 (
    echo [Mission Control] npm install failed.
    exit /b 1
  )
)

echo [Mission Control] Starting on http://localhost:3000
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4 Address"') do (
  set ip=%%A
  goto :gotip
)
:gotip
if defined ip (
  set ip=%ip: =%
  echo [Mission Control] Phone link (same Wi-Fi): http://%ip%:3000
)

call npm run dev
