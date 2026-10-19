#!/usr/bin/env python3
# ==============================================================================
# Script Name: bunq_db.py
# Description: Production SQLite3 relational engine mapped to corporate invoices
#              and raw telemetric hardware log payloads.
# ==============================================================================

import sqlite3
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"

def init_db():
    """Establishes formal production database schemas inside your active directory path."""
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # 1. Real Corporate Accounting Table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS invoices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invoice_date TEXT,
            isbn TEXT,
            item_description TEXT,
            runtime_status TEXT,
            payment_gateway TEXT,
            net_amount_eur REAL,
            vat_amount_eur REAL,
            total_amount_eur REAL,
            channel TEXT DEFAULT 'RETAIL',
            entity TEXT DEFAULT 'Fieldberry Group',
            n_cage TEXT DEFAULT NULL
        )
    """)
    
    # 2. Real Telemetric Record Keeping Layer
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS telemetry_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            zenodo_id TEXT,
            system_identifier TEXT,
            location TEXT,
            protocol TEXT,
            json_payload TEXT
        )
    """)
    
    conn.commit()
    conn.close()

def insert_invoice(date, isbn, description, status, gateway, net, vat, gross, channel='RETAIL', entity='Fieldberry Group', n_cage=None):
    """Inserts an official accounting transaction receipt into the invoices ledger table."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO invoices (
            invoice_date, isbn, item_description, runtime_status, payment_gateway, 
            net_amount_eur, vat_amount_eur, total_amount_eur, channel, entity, n_cage
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (date, isbn, description, status, gateway, net, vat, gross, channel, entity, n_cage))
    conn.commit()
    conn.close()

def log_telemetry(zenodo_id, system_id, location, protocol, payload_dict):
    """Logs raw hardware or deployment telemetry payloads safely as serialized strings."""
    import json
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO telemetry_records (
            zenodo_id, system_identifier, location, protocol, json_payload
        ) VALUES (?, ?, ?, ?, ?)
    """, (zenodo_id, system_id, location, protocol, json.dumps(payload_dict)))
    conn.commit()
    conn.close()

if __name__ == "__main__":
    init_db()
    print(f"[+] Relational production data layer activated at: {DB_PATH}")
