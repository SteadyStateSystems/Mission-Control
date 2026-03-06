# Jarvis Mission Control (GitHub Pages style)

Mission Control customized for your stack:
- Primary agent: **Jarvis**
- Sub-bot: **Pip**
- KPI cards are clickable detail links
- Calendar/Tasks/Active Jobs/Agents/Memories are real pages
- Data source: **OpenClaw runtime only** (not M3T)

## How data works

This repo uses a static web UI (GitHub Pages friendly) plus a local sync script.

- UI files: `index.html`, `calendar.html`, `tasks.html`, `jobs.html`, `agents.html`, `memories.html`
- Runtime data file: `data/runtime.json`
- Sync script: `scripts/sync-openclaw-data.ps1`

Run sync before viewing to refresh live runtime data:

```powershell
npm run sync:data
```

## Local view

```powershell
npm run serve:static
```

Open:
- `http://localhost:3001/index.html`

## GitHub Pages view

Once pushed, open your repo Pages URL. The UI loads from GitHub directly.

> Note: runtime data freshness depends on how often you run `sync:data` and push updates.

## Remote start/refresh/stop (away from home)

These commands keep Mission Control **off by default** and only run when requested.

```powershell
npm run mc:start
npm run mc:refresh
npm run mc:stop
```

- `mc:start` syncs data, starts local static server on `:3001`, ensures ngrok tunnel exists, and prints local+remote URL.
- `mc:refresh` updates runtime data only.
- `mc:stop` stops Mission Control server on `:3001` and leaves ngrok up (so M3T is unaffected).

## GitHub setup guide (one-time)

1. Open repo: `SteadyStateSystems/Mission-Control`
2. Go to **Settings → Pages**
3. Under **Build and deployment**, set:
   - **Source:** Deploy from a branch
   - **Branch:** `main` / `/ (root)`
4. Save
5. Wait ~1-3 minutes, then open:
   - `https://steadystatesystems.github.io/Mission-Control/`

## KPI semantics

- **Open Tasks**: all known OpenClaw sessions/items
- **Scheduled Jobs**: OpenClaw cron jobs
- **Active Jobs**: only sessions updated in the live window (processing now)
- **Agents Online**: agents active recently
