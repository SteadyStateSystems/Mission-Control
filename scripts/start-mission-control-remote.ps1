$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# 1) Sync fresh OpenClaw data
& powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'sync-openclaw-data.ps1') | Out-Host

# 2) Start static server on :3001 only if not already running
$existing = Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $existing) {
  $cmd = "Set-Location '$root'; npx serve -l 3001"
  Start-Process -FilePath powershell -ArgumentList "-NoProfile -WindowStyle Hidden -Command $cmd" | Out-Null
  Start-Sleep -Seconds 2
}

# 3) Ensure ngrok is running with mission-control tunnel
function Get-Tunnels {
  try {
    return (Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:4040/api/tunnels' -TimeoutSec 3).Content | ConvertFrom-Json
  } catch {
    return $null
  }
}

$tunnels = Get-Tunnels
$mission = $null
if ($tunnels -and $tunnels.tunnels) {
  $mission = $tunnels.tunnels | Where-Object { $_.name -eq 'mission-control' } | Select-Object -First 1
}

if (-not $mission) {
  $ngrokCandidates = @(
    'C:\Users\asshole\Desktop\M3T-PRJ-DATA\ngrok\ngrok-v3-stable-windows-amd64\ngrok.exe',
    'ngrok'
  )
  $ngrok = $ngrokCandidates | Where-Object { if ($_ -eq 'ngrok') { (Get-Command ngrok -ErrorAction SilentlyContinue) -ne $null } else { Test-Path $_ } } | Select-Object -First 1
  if (-not $ngrok) { throw 'ngrok not found.' }

  if ($ngrok -eq 'ngrok') {
    Start-Process -FilePath 'powershell' -ArgumentList "-NoProfile -WindowStyle Hidden -Command ngrok start --all" | Out-Null
  } else {
    Start-Process -FilePath $ngrok -ArgumentList 'start --all' | Out-Null
  }
  Start-Sleep -Seconds 2

  $tunnels = Get-Tunnels
  if ($tunnels -and $tunnels.tunnels) {
    $mission = $tunnels.tunnels | Where-Object { $_.name -eq 'mission-control' } | Select-Object -First 1
  }
}

$localUrl = 'http://localhost:3001/index.html'
$remoteUrl = if ($mission) { "$($mission.public_url)/index.html" } else { '' }

Write-Host "Mission Control local: $localUrl"
if ($remoteUrl) {
  Write-Host "Mission Control remote: $remoteUrl"
} else {
  Write-Host 'Mission Control remote URL unavailable (ngrok tunnel not detected).'
}
