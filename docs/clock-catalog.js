(function(){
function fmt(tz){return new Date().toLocaleString('sv-SE',{timeZone:tz,hour12:false});}
var slots=[];
document.querySelectorAll('input,span,div,p,b,code,time').forEach(function(e){
 var v=(e.tagName==='INPUT'?e.value:(e.children.length?'':e.textContent)).trim();
 if(/^[-–—]{1,2}:[-–—]{1,2}(:[-–—]{1,2})?$/.test(v)) slots.push(e);
});
if(!slots.length){var c=document.createElement('div');c.style.cssText='position:fixed;top:8px;right:8px;z-index:9999;background:#000;color:#0f0;font:14px monospace;padding:4px 8px;border-radius:6px';document.body.appendChild(c);slots.push(c);}
function tick(){slots.forEach(function(e,i){var t=fmt(i===0?'Asia/Tokyo':undefined);if(e.tagName==='INPUT'){e.value=t;e.size=19;}else e.textContent=t;});}
tick();setInterval(tick,1000);
var box=document.getElementById('catalog')||document.body.appendChild(Object.assign(document.createElement('div'),{id:'catalog'}));
box.style.cssText='padding:12px;font:14px monospace';
box.innerHTML='<h3>Repos &amp; releases</h3><div id="cat-list">Loading...</div>';
var list=box.querySelector('#cat-list');
var srcs=['https://api.github.com/orgs/Colegio-San-Caio/repos?per_page=100','https://api.github.com/users/clevjhon/repos?per_page=100'];
Promise.all(srcs.map(function(u){return fetch(u).then(function(r){return r.json()}).catch(function(){return []})})).then(function(a){
 var repos=[].concat(a[0]||[],a[1]||[]).filter(function(r){return r&&r.full_name});
 list.innerHTML='';
 repos.forEach(function(r){
  var d=document.createElement('div');d.style.margin='6px 0';
  d.innerHTML='<a href="'+r.html_url+'">'+r.full_name+'</a> - <a href="'+r.html_url+'/releases">releases</a>';
  list.appendChild(d);
 });
 if(!repos.length)list.textContent='No repos loaded (GitHub API limit?).';
});
})();
