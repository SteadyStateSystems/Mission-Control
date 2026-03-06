@echo off
setlocal
cd /d "%~dp0"

if not exist node_modules (
  echo [Mission Control] Installing dependencies...
  call npm install
  if errorlevel 1 (
    echo [Mission Control] npm install failed.
    pause
    exit /b 1
  )
)

echo [Mission Control] Starting on http://localhost:3000
echo [Mission Control] For phone on same Wi-Fi, use: http://YOUR-PC-IP:3000
echo [Mission Control] Press Ctrl+C to stop.

call npm run dev

if errorlevel 1 (
  echo [Mission Control] Server exited with an error.
  pause
)
