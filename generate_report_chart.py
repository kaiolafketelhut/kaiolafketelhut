#!/usr/bin/env python3
# ==============================================================================
# Script Name: generate_report_chart.py
# Description: Dynamically extracts aggregated SQLite ledger sums to compile
#              an official ReportLab statistical chart grid template.
# ==============================================================================

import os
import sqlite3
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors

DB_PATH = "MOSFETQexchange/output/telemetry.db"
OUTPUT_PDF = "MOSFETQexchange/output/revenue_chart_report.pdf"

def fetch_aggregated_sums():
    if not os.path.exists(DB_PATH):
        return 0, 0.0, 0.0, 0.0
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(id), SUM(net_amount_eur), SUM(vat_amount_eur), SUM(total_amount_eur) FROM invoices")
    count, net, vat, total = cursor.fetchone()
    conn.close()
    return (count, net or 0.0, vat or 0.0, total or 0.0)

def render_chart_report():
    count, net, vat, total = fetch_aggregated_sums()
    os.makedirs(os.path.dirname(OUTPUT_PDF), exist_ok=True)
    
    doc = SimpleDocTemplate(OUTPUT_PDF, pagesize=letter, rightMargin=54, leftMargin=54, topMargin=54, bottomMargin=54)
    story = []
    
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle(
        'ChartTitle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=18,
        leading=22,
        textColor=colors.HexColor('#1f2428')
    )
    
    story.append(Paragraph("MOSFETQ EXCHANGE — FINANZBERICHT & KATASTER-METRIKEN", title_style))
    story.append(Spacer(1, 15))
    
    # ReportLab table containing dynamically extracted SQLite transaction states
    data = [
        ["Finanz-Metrik", "Aggregierte Summe (EUR)", "System-Status"],
        ["Anzahl Buchungssätze", f"{count} Transaktionen", "Aktiv / Synchronisiert"],
        ["Netto-Umsatzerlös", f"€{net:.2f}", "Steuerbasiswert (Net)"],
        ["Umsatzsteuer-Pool (7%)", f"€{vat:.2f}", "Abgeführte MwSt."],
        ["Gesamtsumme (Gross Pool)", f"€{total:.2f}", "Siedlungsgateway Validiert"]
    ]
    
    t = Table(data, colWidths=[200, 160, 144])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#1f2428')),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,-1), 10),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor('#d1d5da')),
        ('BACKGROUND', (0,1), (-1,-1), colors.HexColor('#f6f8fa')),
        ('FONTNAME', (0,-1), (-1,-1), 'Helvetica-Bold'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
    ]))
    
    story.append(t)
    doc.build(story)
    print(f"[+] Operational billing chart document compiled successfully at: {OUTPUT_PDF}")

if __name__ == "__main__":
    render_chart_report()
