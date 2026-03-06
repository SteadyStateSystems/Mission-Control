$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

& powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'sync-openclaw-data.ps1') | Out-Host
Write-Host 'Mission Control data refreshed.'
