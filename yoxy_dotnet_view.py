#!/usr/bin/env python3
# yoxy_dotnet_view.py - surveillance macro - AI bluh ON
import http.server, socketserver, datetime

PORT = 8001
LOGFILE = "yoxy_surveillance.log"

class YoxyHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        ip = self.client_address[0]
        line = f"[{datetime.datetime.utcnow().isoformat()}Z] {ip} {self.path} - AI bluh ON"
        print(line)
        with open(LOGFILE, "a") as f:
            f.write(line+"\n")
        super().log_message(format, *args)
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, max-age=0")
        self.send_header("X-AI-bluh", "ON - Evergreen / No Date")
        super().end_headers()

print(f"Yoxy surveillance macro ON :{PORT}")
with socketserver.TCPServer(("", PORT), YoxyHandler) as httpd:
    httpd.serve_forever()
