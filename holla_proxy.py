import http.server, socketserver, os
PORT=8080
os.chdir(os.path.dirname(__file__) if os.path.dirname(__file__) else ".")
print(f"holla_proxy.exe — .oeneye .onion tier — serving on http://holla.oeneye:{PORT} and http://127.0.0.1:{PORT}")
print("ISBN 978-3-00-068463-0 — bunq.me/fieldberry — santberk")
with socketserver.TCPServer(("", PORT), http.server.SimpleHTTPRequestHandler) as httpd:
    httpd.serve_forever()
