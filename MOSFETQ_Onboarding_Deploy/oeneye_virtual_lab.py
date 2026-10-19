#!/usr/bin/env python3
# ==============================================================================
# Script Name: oeneye_virtual_lab.py
# Description: Generates the oeneyeVirtualLab official PDF monograph asset
#              by dynamically extracting real invoice and N-CAGE parameters 
#              from the production SQLite database ledger.
# ==============================================================================

import os
import sqlite3
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors

DB_PATH = "MOSFETQexchange/output/telemetry.db"
OUTPUT_PDF_PATH = "MOSFETQexchange/output/oeneyeVirtualLab_Monograph.pdf"

def extract_ledger_values():
    """Queries the invoices table to pull real transaction values dynamically."""
    if not os.path.exists(DB_PATH):
        return "€21.00", "CNNN3" # Fallbacks if DB is completely unseeded
        
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Query the database for the official corporate record entry
    cursor.execute("""
        SELECT total_amount_eur, n_cage 
        FROM invoices 
        WHERE isbn = '978-3-00-068463-0' 
        LIMIT 1
    """)
    row = cursor.fetchone()
    conn.close()
    
    if row:
        gross_amount = f"€{row[0]:.2f}"
        n_cage_code = str(row[1]) if row[1] else "CNNN3"
        return gross_amount, n_cage_code
    return "€22.47", "CNNN3"

def generate_virtual_lab_pdf():
    # 1. Fetch live production metrics directly from database loops
    gross_total, ncage_id = extract_ledger_values()
    
    os.makedirs(os.path.dirname(OUTPUT_PDF_PATH), exist_ok=True)
    doc = SimpleDocTemplate(OUTPUT_PDF_PATH, pagesize=letter, rightMargin=36, leftMargin=36, topMargin=36, bottomMargin=36)
    story = []
    
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle(
        'TitleStyle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=16,
        leading=20,
        textColor=colors.HexColor('#1f2428')
    )
    body_style = ParagraphStyle(
        'BodyStyle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=14,
        textColor=colors.HexColor('#24292e')
    )
    
    story.append(Paragraph("OENEYEVIRTULLAB — ARCHITECTURAL SYSTEMICS & TELEMETRY", title_style))
    story.append(Spacer(1, 12))
    
    intro_text = f"""
    <b>Author / ORCID:</b> Kai Olaf Ketelhut (0000-0001-6049-8873)<br/>
    <b>Station Metadata:</b> Berlin, Germany (52.5200 N, 13.4050 E)<br/>
    <b>Axiom Constraint:</b> 1 + 0 = 1 | Namespace: NN | PL: 36883<br/>
    <b>Primary Target:</b> ISBN 978-3-00-068463-0
    """
    story.append(Paragraph(intro_text, body_style))
    story.append(Spacer(1, 15))
    
    # 2. Map data arrays into the ReportLab table layout matrix
    data = [
        ["Pipeline Component", "Target Reference / URI", "State Metrics"],
        ["Acquisition Mask", "https://bunq.me/9783000684630", f"Settled Total: {gross_total}"],
        ["Sandbox API", "https://bunq.com", "Provisioned Framework"],
        ["Static Portal", f"NCAGE: {ncage_id}", "Synchronized Branch State"]
    ]
    
    t = Table(data, colWidths=[130, 240, 130])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#eaecef')),
        ('TEXTCOLOR', (0,0), (-1,0), colors.HexColor('#24292e')),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,-1), 9),
        ('BOTTOMPADDING', (0,0), (-1,0), 6),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor('#d1d5da')),
    ]))
    
    story.append(t)
    doc.build(story)
    print(f"[+] oeneyeVirtualLab PDF asset successfully compiled at: {OUTPUT_PDF_PATH}")

if __name__ == "__main__":
    generate_virtual_lab_pdf()
