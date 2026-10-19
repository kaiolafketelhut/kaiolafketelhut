from http.server import SimpleHTTPRequestHandler, HTTPServer
import sqlite3, json, time, os
DB2="cookiesDBomq.db"
class H(SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path=='/api/history':
            l=int(self.headers.get('Content-Length',0))
            j=json.loads(self.rfile.read(l).decode())
            con=sqlite3.connect(DB2)
            con.execute("INSERT INTO history VALUES (NULL,?,?,?)",(j.get('page','/'),int(j.get('noDate',0)),int(time.time())))
            con.commit(); con.close()
            print(f"SAVED: {j}")
            self.send_response(200); self.send_header('Content-Type','application/json'); self.send_header('Access-Control-Allow-Origin','*'); self.end_headers()
            self.wfile.write(b'{"ok":1}'); return
        super().do_POST()
    def log_message(self,s,*a): print(s%a)
print("SERVING on http://localhost:8000  + API on /api/history")
HTTPServer(("0.0.0.0",8000),H).serve_forever()
