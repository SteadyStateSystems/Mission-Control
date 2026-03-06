# Jarvis Mission Control

Read-only Next.js Mission Control dashboard inspired by the referenced YouTube flow.

## What this includes

- Mission-control style shell + dark UI
- Task Board (kanban columns)
- KPI strip
- Live activity feed
- Helpful modules section (Task Board, Calendar, Projects, Memories, Docs, Team, Office)
- Mobile-responsive layout
- Read-only page (no form input, no actions posted back to the agent)

## Self-host on this machine (no public deploy)

### One-click startup (Windows)

Double-click:

- `start-mission-control.bat`

It will:

1. install dependencies if missing
2. start Mission Control on `http://localhost:3000`
3. print a same-Wi-Fi phone link like `http://192.168.x.x:3000`

### Manual run

```bash
npm install
npm run dev
```

Then open:

- this PC: `http://localhost:3000`
- phone on same Wi-Fi: `http://<your-pc-ip>:3000`

## Notes

- This is self-hosted/private unless you intentionally expose your network port to the internet.
- Dashboard is read-only by design.
