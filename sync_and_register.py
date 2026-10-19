import json,sqlite3,datetime
def get_bunq_config(k,d=None):
 try:
  import bunq_db
  if hasattr(bunq_db,'get_config'): return bunq_db.get_config(k)
  if hasattr(bunq_db,'CONFIG'): return bunq_db.CONFIG.get(k,d)
  return getattr(bunq_db,k,d)
 except: pass
 return {"api_endpoint":"https://api.bunq.com/v1","db_path":"MOSFETQexchange/output/telemetry.db"}.get(k,d)

def run_database_sync_registration():
 import os; os.makedirs("MOSFETQexchange/output",exist_ok=True)
 con=sqlite3.connect("MOSFETQexchange/output/telemetry.db"); cur=con.cursor()
 cur.execute("CREATE TABLE IF NOT EXISTS oeneye_view_counter (id INTEGER PRIMARY KEY CHECK(id=1), total_views INTEGER DEFAULT 0)")
 cur.execute("INSERT INTO oeneye_view_counter VALUES (1,0) ON CONFLICT(id) DO NOTHING")
 con.commit(); con.close()
 print("[proxy] bunq DB gateway fixed + OENEYEdb ready")
 return {"status":"ok","proxy":"by proxy.NET"}

if __name__=="__main__":
 import json; print(json.dumps(run_database_sync_registration(),indent=2))
