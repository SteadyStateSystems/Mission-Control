$ErrorActionPreference = 'Continue'

$listeners = Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue
if ($listeners) {
  $pids = $listeners | Select-Object -ExpandProperty OwningProcess -Unique
  foreach ($procId in $pids) {
    try { Stop-Process -Id $procId -Force } catch {}
  }
  Write-Host 'Mission Control server on :3001 stopped.'
} else {
  Write-Host 'No Mission Control server running on :3001.'
}

Write-Host 'ngrok left running (so M3T is not disrupted).'
