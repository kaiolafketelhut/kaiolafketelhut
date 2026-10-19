const CookiesDBOmq = {
  KEY: 'omq_page_history',
  save: function(page, noDateMode){
    let h = JSON.parse(localStorage.getItem(this.KEY)||'[]');
    h.push({page: page, noDate: noDateMode, ts: Date.now()});
    if(h.length>200) h=h.slice(-200);
    localStorage.setItem(this.KEY, JSON.stringify(h));
    document.cookie = this.KEY+"="+encodeURIComponent(JSON.stringify(h))+"; path=/; max-age=2592000";
    try{ fetch('/api/history',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({page,noDate:noDateMode})})}catch(e){}
  },
  get: function(){ return JSON.parse(localStorage.getItem(this.KEY)||'[]'); },
  render: function(){
    const c=document.getElementById('historyPanel'); if(!c) return;
    c.innerHTML='<h4>Page History (No Date)</h4>'+this.get().slice().reverse().slice(0,20).map(x=>`<div style="font-size:12px;border-bottom:1px solid #eee;padding:4px">${x.page} - ${x.noDate?'NO DATE':'dated'} - ${new Date(x.ts).toLocaleString()}</div>`).join('');
  }
};
function toggleNoDate(p){ const isNo=document.body.classList.toggle('no-date-mode'); CookiesDBOmq.save(p||location.pathname,isNo); CookiesDBOmq.render(); }
