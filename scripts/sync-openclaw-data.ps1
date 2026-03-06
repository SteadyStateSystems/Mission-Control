$ErrorActionPreference='Stop'
$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root 'data'
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$status = openclaw status --json | ConvertFrom-Json
$sessions = openclaw sessions --json --all-agents | ConvertFrom-Json
$cron = openclaw cron list --json --all | ConvertFrom-Json

$now = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$activeWindowMs = 15 * 60 * 1000

$activeSessions = @($sessions.sessions | Where-Object { ($now - $_.updatedAt) -le $activeWindowMs })
$scheduledJobs = @($cron.jobs)
$agents = @($status.agents.agents | ForEach-Object {
  $ageMin = [math]::Round(($_.lastActiveAgeMs / 60000),1)
  [pscustomobject]@{
    id = $_.id
    name = ($_.name -replace 'Henry','Jarvis')
    online = ($_.lastActiveAgeMs -lt 900000)
    lastSeen = "$ageMin min ago"
  }
})

$mems = @()
$memCandidates = @(
  (Join-Path $root 'memory'),
  'C:\Users\asshole\memory'
) | Select-Object -Unique
foreach($memPath in $memCandidates){
  if (Test-Path $memPath) {
    $files = Get-ChildItem $memPath -Filter '*.md' | Sort-Object LastWriteTime -Descending | Select-Object -First 8
    foreach($f in $files){
      $lines = Get-Content $f.FullName
      $snippet = ($lines | Select-Object -First 4) -join ' '
      $mems += [pscustomobject]@{ title=$f.Name; snippet=$snippet.Substring(0,[Math]::Min(180,$snippet.Length)) }
    }
  }
}
$mems = $mems | Select-Object -First 12

$openTasks = @($sessions.sessions | ForEach-Object {
  [pscustomobject]@{
    name = $_.key
    status = if(($now-$_.updatedAt) -le $activeWindowMs){'running'} elseif(($now-$_.updatedAt) -le 86400000){'queued/recent'} else {'historic'}
    detail = "agent=$($_.agentId), updated=$([math]::Round((($now-$_.updatedAt)/60000),1)) min ago"
  }
})

$payload = [pscustomobject]@{
  updatedAt = (Get-Date).ToString('o')
  kpis = [pscustomobject]@{
    openTasks = $openTasks.Count
    scheduledJobs = $scheduledJobs.Count
    activeJobs = $activeSessions.Count
    agentsOnline = @($agents | Where-Object {$_.online}).Count
  }
  openTasks = $openTasks
  scheduledJobs = @($scheduledJobs | ForEach-Object { [pscustomobject]@{ name=$_.name; when=$_.schedule } })
  activeJobs = @($activeSessions | ForEach-Object { [pscustomobject]@{ name=$_.key; detail="agent=$($_.agentId)" } })
  agents = $agents
  memories = $mems
}

$payload | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $outDir 'runtime.json') -Encoding UTF8
Write-Host 'Synced data/runtime.json'
