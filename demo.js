(function(){
var w=null, run=document.getElementById('demorun'), stop=document.getElementById('demostop'), box=document.getElementById('demoout'), src=document.getElementById('pysrc'), code='';
function head(){return '$ python3 emu_dos.py\n';}
function done(){run.disabled=false;stop.disabled=true;}
fetch('emu_dos.py?'+Date.now()).then(function(r){if(!r.ok)throw 0;return r.text();}).then(function(t){code=t;src.textContent=t;}).catch(function(){src.textContent='emu_dos.py is not published on this site yet.';});
function mk(){
  w=new Worker('emu_worker.js');
  w.onmessage=function(e){box.textContent=head()+e.data.out;done();};
  w.onerror=function(e){box.textContent+='\n[worker error] '+(e.message||'');done();};
}
run.onclick=function(){
  if(!code){box.textContent='emu_dos.py is not loaded.';return;}
  run.disabled=true;stop.disabled=false;
  box.textContent=head()+'Loading Python (first run ~10 MB)...';
  var v=document.getElementById('demoin').value;
  if(!w)mk();
  w.postMessage({code:code,lines:v===''?[]:v.split('\n')});
};
stop.onclick=function(){if(w){w.terminate();w=null;}box.textContent+='\n[stopped]';done();};
})();
