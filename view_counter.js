(function(){
 async function hit(){
  try{
   let r=await fetch("http://localhost:5005/api/views/hit",{method:"POST"});
   if(r.ok){ let j=await r.json(); localStorage.setItem("views", j.total_views); return j.total_views; }
  }catch(e){}
  try{ let r=await fetch("./view_count.json",{cache:"no-store"}); if(r.ok){ let j=await r.json(); return j.total_views; } }catch(e){}
  return localStorage.getItem("views")||1;
 }
 async function render(){
  let c=await hit();
  let el=document.getElementById("view-counter-badge");
  if(!el){ el=document.createElement("span"); el.id="view-counter-badge"; el.style.cssText="background:#24292e;color:#fff;padding:4px 10px;border-radius:12px;font-size:12px;font-family:monospace"; document.querySelector(".top-right")?.appendChild(el); }
  el.innerHTML="👁 "+c+" views <span style='opacity:.6'>by proxy.NET</span>";
 }
 document.addEventListener("DOMContentLoaded", render);
})();
