#!/usr/bin/env python3
# ==============================================================================
# Script Name: mock_webhook_receiver.py
# Description: Implements a minimal HTTP callback receiver to parse incoming 
#              bunq mutation payloads and write transaction states to the 
#              production SQLite invoices schema.
# ==============================================================================

import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime
import bunq_db

PORT = 8080

class BunqWebhookHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        
        print(f"\n[+] Incoming transaction pulse captured via network routing!")
        
        try:
            # Parse the incoming simulated bunq mutation JSON structure
            payload = json.loads(post_data.decode('utf-8'))
            
            # Extract core mutation telemetry variables
            mutation_details = payload.get("NotificationUrl", {})
            object_data = mutation_details.get("object", {}).get("Payment", {})
            
            amount_val = float(object_data.get("amount", {}).get("value", "0.00"))
            currency = object_data.get("amount", {}).get("currency", "EUR")
            description = object_data.get("description", "No reference")
            counterparty = object_data.get("counterparty_alias", {}).get("display_name", "Unknown")
            
            print(f"    - Amount: €{amount_val:.2f} {currency}")
            print(f"    - From: {counterparty}")
            print(f"    - Ref: {description}")
            
            # Formulate proper corporate accounting values
            vat_calc = round(amount_val * 0.07 / 1.07, 2) if amount_val > 0 else 0.00
            net_calc = round(amount_val - vat_calc, 2)
            
            # Log the successful transaction state change into the production invoices ledger
            bunq_db.insert_invoice(
                date=datetime.utcnow().strftime("%Y-%m-%d"),
                isbn="978-3-00-068463-0",
                description=f"Webhook Recv: {description} (From: {counterparty})",
                status="SETTLED_HOOK",
                gateway="https://bunq.me/9783000684630",
                net=net_calc,
                vat=vat_calc,
                gross=amount_val,
                channel="RETAIL_MUTATION",
                entity="SIETEHR FOUNDATION",
                n_cage="CNNN3"
            )
            print("[+] Transaction ledger successfully updated in database.")
            
            # Respond to the mock server loop with an HTTP 200 OK success context
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"status": "PROCESSED"}).encode('utf-8'))
            
        except Exception as e:
            print(f"[-] Failed processing webhook payload structure: {e}")
            self.send_response(400)
            self.end_headers()

def run_server():
    bunq_db.init_db()
    server_address = ('', PORT)
    httpd = HTTPServer(server_address, BunqWebhookHandler)
    print(f"[*] Production Webhook Receiver listening locally on port {PORT}...")
    print(f"[*] Leave this window open to process transaction mock pulses. (Ctrl+C to stop)")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[-] Webhook receiver server terminated cleanly.")

if __name__ == "__main__":
    run_server()
