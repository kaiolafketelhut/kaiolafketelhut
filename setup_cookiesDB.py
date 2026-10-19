with open('cookiesDBomq.js','w') as f:
 f.write(r"""
// cookiesDBomq.net - Page history by No date function
const CookiesDBOmq = {
  DOMAIN: 'omq.net',
  KEY: 'omq_page_history',
  
  save: function(page, noDateMode){
    let h = JSON.parse(localStorage.getItem(this.KEY)||'[]');
    h.push({page: page, noDate: noDateMode, ts: Date.now(), date: new Date().toISOString()});
    if(h.length>200) h = h.slice(-200);
    localStorage.setItem(this.KEY, JSON.stringify(h));
    document.cookie = this.KEY+"="+encodeURIComponent(JSON.stringify(h))+"; path=/; max-age=2592000";
    // sync to proxy if available
    try{ fetch('/api/history',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({page,noDate:noDateMode})}) }catch(e){}
  },
  
  get: function(){
    return JSON.parse(localStorage.getItem(this.KEY)||'[]');
  },
  
  render: function(){
    const c = document.getElementById('historyPanel');
    if(!c) return;
    const h = this.get().reverse();
    c.innerHTML = '<h4>Page History (No Date)</h4>' + h.map(x=>`<div style="font-size:12px;border-bottom:1px solid #eee;padding:4px">${x.page} - ${x.noDate?'NO DATE':'dated'} - ${new Date(x.ts).toLocaleString()}</div>`).join('');
  }
};

function toggleNoDate(page){
  const isNoDate = document.body.classList.toggle('no-date-mode');
  CookiesDBOmq.save(page||location.pathname, isNoDate);
  CookiesDBOmq.render();
}
""")
print("OK cookiesDBomq.js created")
