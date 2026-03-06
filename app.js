async function loadRuntime(){
  const r = await fetch('data/runtime.json?t='+Date.now());
  if(!r.ok) throw new Error('runtime.json missing');
  return r.json();
}
function setText(id,val){const el=document.getElementById(id); if(el) el.textContent=val;}
function list(id,items,fmt){const el=document.getElementById(id); if(!el) return; el.innerHTML=''; items.forEach(i=>{const li=document.createElement('li'); li.innerHTML=fmt?fmt(i):String(i); el.appendChild(li);});}

loadRuntime().then(d=>{
  setText('updatedAt','Updated: '+new Date(d.updatedAt).toLocaleString());
  setText('kOpen', d.kpis.openTasks);
  setText('kSched', d.kpis.scheduledJobs);
  setText('kActive', d.kpis.activeJobs);
  setText('kAgents', d.kpis.agentsOnline);

  list('processing', d.activeJobs, x=>`<strong>${x.name}</strong> — ${x.detail}`);
  list('taskList', d.openTasks, x=>`<strong>${x.name}</strong> <span class='muted'>(${x.status})</span><br>${x.detail||''}`);
  list('calendarList', d.scheduledJobs, x=>`<strong>${x.name}</strong> — ${x.when||'unscheduled'}`);
  if(document.getElementById('calendarEmpty')) document.getElementById('calendarEmpty').style.display = d.scheduledJobs.length? 'none':'block';
  list('activeList', d.activeJobs, x=>`<strong>${x.name}</strong> — ${x.detail}`);
  if(document.getElementById('activeEmpty')) document.getElementById('activeEmpty').style.display = d.activeJobs.length? 'none':'block';
  list('agentList', d.agents, x=>`<strong>${x.name}</strong> (${x.id}) — ${x.online?'online':'offline'}<br><span class='muted'>${x.lastSeen||''}</span>`);
  list('memoryList', d.memories, x=>`<strong>${x.title}</strong><br><span class='muted'>${x.snippet}</span>`);
}).catch(err=>{
  const msg = 'Data not loaded yet. Run scripts/sync-openclaw-data.ps1';
  document.querySelectorAll('main .card').forEach(c=>c.innerHTML='<p>'+msg+'</p>');
});