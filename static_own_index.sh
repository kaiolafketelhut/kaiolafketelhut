#!/usr/bin/env bash
mkdir -p articles assets ".chat" lectures
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ); EPOCH=$(date +%s); CNT=$(ls articles/|wc -l|tr -d ' ')
NEWCPY="© Colegio-San-Caio / Julia_Menge_eigenOENEYE / OENEYEbluh — (0)b — Evergreen / No Date — Ostpreußen-russe-Gakushūjo Further Education College"

# === 1. ENGINE + BOOK (no date) ===
cat >candiOQM_xTitin.html <<HTML
<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>OENEYEbluh — No Date + Clock + Catalog</title>
<style>body{background:#050a14;color:#8fc8ff;font-family:monospace;margin:0;padding:0}a{color:#0ff}header{background:#000;border-bottom:2px solid #0af;padding:12px;text-align:center}#book{display:flex;flex-wrap:wrap;gap:15px;padding:15px;background:#081020;border:1px solid #0af;margin:15px}#book img{max-width:300px;border:2px solid #0af}#gallery{display:flex;gap:8px;flex-wrap:wrap;padding:10px 15px}#gallery img{height:140px;border:1px solid #0af}#engine{margin:15px;border:1px solid #0f0;padding:10px;color:#0f0;background:#000}#footer{margin:20px 15px 0 15px;border-top:1px solid #0af;padding:10px;color:#a0c0ff;font-size:11px;text-align:center;background:#000}#minimum-box{margin:0 15px 15px 15px;border:1px dashed #0af;background:#001020;padding:10px;color:#8cf;font-size:11px}#chatlog{height:100px;overflow:auto;background:#000;border:1px solid #0a3;padding:5px;color:#0f0}#chatinput{width:60%;background:#000;color:#0ff;border:1px solid #0af;padding:5px}button{background:#002040;color:#0ff;border:1px solid #0af;padding:5px 8px}.tartan{height:18px;background:repeating-linear-gradient(90deg,#0af 0 10px,#003060 10px 20px,#05f 20px 30px);margin:8px 0}</style></head><body>
<header><h2 style="color:#4af;margin:0">OENEYEbluh (0)b — Q2 — No Date + Clock + Catalog</h2><p id=liveclock>00:00:00</p><div class=tartan></div>
<p><a href="candiOQM_clock.html?ts=$EPOCH">CLOCK</a> | <a href="catalog_macro.html?ts=$EPOCH">CATALOG MACRO — Ostpreußen-russe-Gakushūjo — Pages/Jobs/Lectures</a></p></header>
<div id=book><img src="assets/mosfetq-cover.jpeg" onerror="this.src='assets/og-preview.jpg'"><div><h3>Full + No Date</h3><p>$TS $CNT arts</p><p>$NEWCPY</p></div></div>
<div id=gallery><img src="assets/mosfetq-cover.jpeg"><img src="assets/og-preview.jpg"></div>
<div id=engine>xTitin_(n+1)=Ŵ(xTitin_n)+A — $TS — Clock Linked — Catalog Macro Active</div>
<div id=footer>$NEWCPY — Connected: Engine↔Clock↔Catalog</div>
<div id=minimum-box><b>MINIMUM BOX — ENGINE CHAT (0)b</b><div id=chatlog></div><input id=chatinput placeholder="chat"><button onclick="sendChat()">SEND</button></div>
<script>
setInterval(()=>{document.getElementById('liveclock').textContent=new Date().toISOString().slice(11,19)+" xTitin("+Math.floor(Date.now()/1000)+") (0)b"},1000);
const bus=new BroadcastChannel("oeneye-bluh-chat"); const log=document.getElementById('chatlog');
function addLine(r,m,ts){const d=document.createElement('div'); d.textContent="["+new Date(ts).toISOString().slice(11,19)+"] "+r+": "+m; log.appendChild(d); log.scrollTop=log.scrollHeight;}
function load(){try{return JSON.parse(localStorage.getItem('oeneye_chat')||"[]")}catch(e){return[]}} function save(a){localStorage.setItem('oeneye_chat',JSON.stringify(a.slice(-100)))}
let hist=load(); hist.forEach(h=>addLine(h.role,h.msg,h.ts));
window.postChat=function(r,m){const item={role:r,msg:m,ts:Date.now()}; hist.push(item); save(hist); addLine(item.role,item.msg,item.ts); bus.postMessage(item); return item;}
function sendChat(){const i=document.getElementById('chatinput'); if(!i.value.trim())return; window.postChat('ENGINE',i.value.trim()); i.value="";}
bus.onmessage=e=>{hist.push(e.data); save(hist); addLine(e.data.role,e.data.msg,e.data.ts);};
</script></body></html>
HTML

# === 2. CLOCK (no date + connected) ===
cat >candiOQM_clock.html <<HTML
<!doctype html><html><head><meta charset="utf-8"><title>CLOCK — No Date — Linked</title><style>body{background:#000;color:#0f0;font-family:monospace;padding:15px;text-align:center}#clock{font-size:42px;color:#0ff;border:2px solid #0af;padding:15px;margin:15px;background:#001020}#footer{border-top:1px solid #0af;padding:10px;color:#a0c0ff;font-size:11px;background:#000;margin-top:20px}#minimum-box{border:1px dashed #0af;background:#001020;padding:10px;color:#8cf;text-align:left;margin:15px}#chatlog{height:80px;overflow:auto;background:#000;border:1px solid #0a3;padding:5px;color:#0f0}#chatinput{width:60%;background:#000;color:#0ff;border:1px solid #0af;padding:5px}button{background:#002040;color:#0ff;border:1px solid #0af;padding:5px}a{color:#0ff}</style></head><body>
<h2>CLOCK xTitin(t) — (0)b — No Date</h2><div id=clock>00:00:00</div>
<p><a href="candiOQM_xTitin.html?ts=$EPOCH">ENGINE</a> | <a href="catalog_macro.html?ts=$EPOCH">CATALOG MACRO</a></p>
<div id=footer>$NEWCPY — Clock Linked to Engine + Catalog</div>
<div id=minimum-box><b>MINIMUM BOX — CLOCK CHAT</b><div id=chatlog></div><input id=chatinput placeholder="clock chat"><button onclick="sendChat()">SEND</button></div>
<script>
setInterval(()=>{document.getElementById('clock').textContent=new Date().toISOString().slice(11,19)+" — xTitin("+Math.floor(Date.now()/1000)+")"},1000);
const bus=new BroadcastChannel("oeneye-bluh-chat"); const log=document.getElementById('chatlog');
function addLine(r,m,ts){const d=document.createElement('div'); d.textContent="["+new Date(ts).toISOString().slice(11,19)+"] "+r+": "+m; log.appendChild(d); log.scrollTop=log.scrollHeight;}
function load(){try{return JSON.parse(localStorage.getItem('oeneye_chat')||"[]")}catch(e){return[]}} function save(a){localStorage.setItem('oeneye_chat',JSON.stringify(a.slice(-100)))}
let hist=load(); hist.forEach(h=>addLine(h.role,h.msg,h.ts));
window.postChat=function(r,m){const item={role:r,msg:m,ts:Date.now()}; hist.push(item); save(hist); addLine(item.role,item.msg,item.ts); bus.postMessage(item); return item;}
function sendChat(){const i=document.getElementById('chatinput'); if(!i.value.trim())return; window.postChat('CLOCK',i.value.trim()); i.value="";}
bus.onmessage=e=>{hist.push(e.data); save(hist); addLine(e.data.role,e.data.msg,e.data.ts);};
</script></body></html>
HTML

# === 3. CATALOG MACRO — Ostpreußen-russe-Gakushūjo — Pages / Jobs IDs / Lectures ===
PAGES=$(ls -1 *.html 2>/dev/null | tr '\n' ' ')
ARTS=$(ls -1 articles/ 2>/dev/null | sort | tr '\n' ' ')
JOBS=$(gh run list --workflow="pages.yml" -L 15 --json databaseId,status,conclusion,createdAt --jq '.[] | "\(.databaseId) \(.status) \(.conclusion) \(.createdAt)"' 2>/dev/null | head -n 20)

cat >catalog_macro.html <<HTML
<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Catalog Macro — Ostpreußen-russe-Gakushūjo — Pages/Jobs/Lectures</title>
<style>
body{background:#0a0a0a;color:#cde;font-family:monospace;margin:0;padding:0}
header{background:#000;border-bottom:3px solid #0af;padding:15px;text-align:center}
h2{color:#0ff}
#grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;padding:15px}
.card{background:#101830;border:1px solid #0af;padding:10px;min-height:200px;overflow:auto}
.card h3{margin:0 0 8px 0;color:#4af;border-bottom:1px solid #0af;padding-bottom:4px}
pre{white-space:pre-wrap;word-break:break-all;font-size:10px;color:#8fc}
#footer{border-top:1px solid #0af;padding:10px;color:#a0c0ff;font-size:11px;text-align:center;background:#000}
#minimum-box{margin:15px;border:1px dashed #0af;background:#001020;padding:10px;color:#8cf;font-size:11px}
#chatlog{height:90px;overflow:auto;background:#000;border:1px solid #0a3;padding:5px;color:#0f0}
#chatinput{width:60%;background:#000;color:#0ff;border:1px solid #0af;padding:5px}button{background:#002040;color:#0ff;border:1px solid #0af;padding:5px}
a{color:#0ff}
table{width:100%;font-size:10px;border-collapse:collapse}
td,th{border:1px solid #0a3;padding:3px;text-align:left}
</style></head><body>
<header>
<h2>Ostpreußen-russe-Gakushūjo Further Education College</h2>
<p>About User Catalog — Pages / Jobs IDs / Lectures — Macro View</p>
<p>User: Colegio-San-Caio / Julia_Menge / OENEYEbluh (0)b — Build $TS — Epoch $EPOCH</p>
<p><a href="candiOQM_xTitin.html?ts=$EPOCH">ENGINE</a> | <a href="candiOQM_clock.html?ts=$EPOCH">CLOCK</a> | <a href="index.html?ts=$EPOCH">INDEX</a></p>
</header>

<div id=grid>
<div class=card><h3>📄 PAGES CATALOG</h3><table>
<tr><th>Page</th><th>Link</th><th>ID</th></tr>
<tr><td>Engine Full</td><td><a href="candiOQM_xTitin.html">xTitin</a></td><td>candiOQM_xTitin</td></tr>
<tr><td>Clock</td><td><a href="candiOQM_clock.html">clock</a></td><td>candiOQM_clock</td></tr>
<tr><td>Index</td><td><a href="index.html">index</a></td><td>index</td></tr>
<tr><td>Catalog Macro</td><td><a href="catalog_macro.html">catalog</a></td><td>catalog_macro</td></tr>
</table><pre>
$PAGES

Assets:
$(ls assets/ | tr '\n' ' ')
</pre></div>

<div class=card><h3>⚙️ JOBS IDs — Pages Deploy</h3><pre>$JOBS</pre>
<p>Clipboard IDs you had: 001020, 002040, O, 123</p>
<p>Recent run you just did:</p><pre>37753888041 — no date + clock linked
30da0b6 commit — evergreen copyright
</pre><p><a href="https://github.com/Colegio-San-Caio/demo-repository/actions" target="_blank">→ Actions list</a></p></div>

<div class=card><h3>🎓 LECTURES CATALOG</h3><p>$CNT lectures / articles</p><pre>$ARTS</pre>
<p>About User Catalog Macro:</p><pre>
001 — OENEYEbluh Token Spec
020 — Q2 Blue Chromatic
040 — INT 48h Telemetry
100 — xTitin(t) Engine
200 — Clock Sync
... lectures auto-listed from articles/
</pre></div>
</div>

<div style="padding:0 15px"><div class=card><h3>🔗 User Catalog — About</h3><pre>
College: Ostpreußen-russe-Gakushūjo Further Education College
User: @Colegio-San-Caio
Course: Hosted AGI Identity — OENEYEbluh (0)b
Module: About User Catalog of Pages / Jobs IDs / Lectures Catalog Macro

Macro Logic:
- Pages = *.html in repo root
- Jobs IDs = gh run list --workflow=pages.yml IDs
- Lectures = articles/ *.md files (each md = lecture)

This macro auto-generates from Termux static_own_index.sh
No Date copyright — Evergreen
</pre></div></div>

<div id=footer>$NEWCPY — Catalog Macro — Pages/Jobs/Lectures — Connected to Engine + Clock — ONE AUTO</div>

<div id=minimum-box><b>MINIMUM BOX — CATALOG MACRO CHAT (0)b — About User Catalog</b><div id=chatlog></div><input id=chatinput placeholder="catalog macro chat — e.g. lecture 001020"><button onclick="sendChat()">SEND</button></div>

<script>
const bus=new BroadcastChannel("oeneye-bluh-chat"); const log=document.getElementById('chatlog');
function addLine(r,m,ts){const d=document.createElement('div'); d.textContent="["+new Date(ts).toISOString().slice(11,19)+"] "+r+": "+m; log.appendChild(d); log.scrollTop=log.scrollHeight;}
function load(){try{return JSON.parse(localStorage.getItem('oeneye_chat')||"[]")}catch(e){return[]}} function save(a){localStorage.setItem('oeneye_chat',JSON.stringify(a.slice(-100)))}
let hist=load(); hist.forEach(h=>addLine(h.role,h.msg,h.ts));
window.postChat=function(r,m){const item={role:r,msg:m,ts:Date.now()}; hist.push(item); save(hist); addLine(item.role,item.msg,item.ts); bus.postMessage(item); return item;}
function sendChat(){const i=document.getElementById('chatinput'); if(!i.value.trim())return; window.postChat('CATALOG',i.value.trim()); i.value="";}
bus.onmessage=e=>{hist.push(e.data); save(hist); addLine(e.data.role,e.data.msg,e.data.ts);};
setTimeout(()=>{window.postChat('CATALOG','Ostpreußen-russe-Gakushūjo Catalog Macro active — Pages/Jobs/Lectures — (0)b');},600);
</script>
</body></html>
HTML

cat >index.html <<HTML
<!doctype html><html><body style="background:#000;color:#0f0;font-family:monospace;padding:15px"><h2>FULL — No Date + Clock + Catalog Macro</h2><p>$TS $CNT</p><p><a href="candiOQM_xTitin.html?ts=$EPOCH">ENGINE</a> | <a href="candiOQM_clock.html?ts=$EPOCH">CLOCK</a> | <a href="catalog_macro.html?ts=$EPOCH"><b>CATALOG MACRO — Ostpreußen-russe-Gakushūjo</b></a></p><pre>Pages: $PAGES
Jobs: $(gh run list --workflow="pages.yml" -L 3 --json databaseId --jq '.[].databaseId' 2>/dev/null)
Lectures: $CNT — $(ls articles/|tail -n 10)</pre></body></html>
HTML
echo "No date + clock + catalog macro — Ostpreußen-russe-Gakushūjo — $TS"
