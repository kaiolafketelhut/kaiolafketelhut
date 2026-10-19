#!/usr/bin/env python3
# ==============================================================================
# Script Name: generate_omq_brand_manifest.py
# Description: Generates a commercial merchandise specification PDF featuring
#              the tall, block-segmented vector letterforms of OMQ.FNT.
# ==============================================================================

import os
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.platypus import Table, TableStyle

OUTPUT_PDF = "MOSFETQexchange/output/clevjhon_fashion_manifest.pdf"

def draw_omq_letter(c, char, x_offset, y_base, scale=1.0):
    """
    Programmatically draws the high-contrast multi-segmented vector 
    characters of OMQ.FNT using explicit point-coordinate matrix grids.
    """
    c.setFillColor(colors.HexColor('#ffffff'))
    w = 30 * scale
    h = 50 * scale
    
    # Structural block-coordinate array maps for each custom letterform
    if char == 'C':
        c.rect(x_offset, y_base, w, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset, y_base, 10 * scale, h, fill=1, stroke=0)
        c.rect(x_offset, y_base + h - 10 * scale, w, 10 * scale, fill=1, stroke=0)
    elif char == 'L':
        c.rect(x_offset, y_base, w, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset, y_base, 10 * scale, h, fill=1, stroke=0)
    elif char == 'E':
        c.rect(x_offset, y_base, w, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset, y_base, 10 * scale, h, fill=1, stroke=0)
        c.rect(x_offset, y_base + 20 * scale, w - 5 * scale, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset, y_base + h - 10 * scale, w, 10 * scale, fill=1, stroke=0)
    elif char == 'V':
        c.rect(x_offset, y_base + 10 * scale, 10 * scale, h - 10 * scale, fill=1, stroke=0)
        c.rect(x_offset + 10 * scale, y_base, w - 20 * scale, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset + w - 10 * scale, y_base + 10 * scale, 10 * scale, h - 10 * scale, fill=1, stroke=0)
    elif char == 'J':
        c.rect(x_offset, y_base, w - 10 * scale, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset, y_base + 10 * scale, 10 * scale, 15 * scale, fill=1, stroke=0)
        c.rect(x_offset + w - 10 * scale, y_base, 10 * scale, h, fill=1, stroke=0)
    elif char == 'H':
        c.rect(x_offset, y_base, 10 * scale, h, fill=1, stroke=0)
        c.rect(x_offset + 10 * scale, y_base + 20 * scale, w - 20 * scale, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset + w - 10 * scale, y_base, 10 * scale, h, fill=1, stroke=0)
    elif char == 'O':
        c.rect(x_offset, y_base, w, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset, y_base, 10 * scale, h, fill=1, stroke=0)
        c.rect(x_offset + w - 10 * scale, y_base, 10 * scale, h, fill=1, stroke=0)
        c.rect(x_offset, y_base + h - 10 * scale, w, 10 * scale, fill=1, stroke=0)
    elif char == 'N':
        c.rect(x_offset, y_base, 10 * scale, h, fill=1, stroke=0)
        c.rect(x_offset + 10 * scale, y_base + h - 15 * scale, w - 20 * scale, 10 * scale, fill=1, stroke=0)
        c.rect(x_offset + w - 10 * scale, y_base, 10 * scale, h, fill=1, stroke=0)

def build_manifest_pdf():
    os.makedirs(os.path.dirname(OUTPUT_PDF), exist_ok=True)
    c = canvas.Canvas(OUTPUT_PDF, pagesize=letter)
    
    # Page Header Elements
    c.setFont("Helvetica-Bold", 24)
    c.drawCentredString(306, 730, "C L E V J H O N")
    c.setFont("Helvetica", 9)
    c.drawCentredString(306, 712, "OMQ.FNT VECTOR LOOKBOOK & COMMERCIAL MERCHANDISE SPECIFICATION")
    
    c.setStrokeColor(colors.HexColor('#000000'))
    c.line(54, 695, 558, 695)
    
    c.setFont("Helvetica-Bold", 12)
    c.drawString(54, 670, "I. TYPOGRAPHIC SPECIMEN (OMQ.FNT EMULATION)")
    
    # Draw Negative Specimen Panel Box
    c.setFillColor(colors.HexColor('#111111'))
    c.rect(54, 530, 504, 110, fill=1, stroke=0)
    
    # Draw OMQ.FNT Letterforms inside the Panel Box
    word = "CLEVJHON"
    start_x = 100
    for idx, char in enumerate(word):
        draw_omq_letter(c, char, start_x + (idx * 52), 560, scale=1.2)
        
    c.setStrokeColor(colors.HexColor('#000000'))
    c.line(54, 500, 558, 500)
    
    # II. Commercial Production Matrix Table Layout
    c.setFillColor(colors.HexColor('#000000'))
    c.drawString(54, 475, "II. COMMERCIAL PRODUCTION MATRIX")
    
    matrix_data = [
        ["Specification Parameter", "Production Allocation Data Value"],
        ["Brand Identity Name", "clevjhon"],
        ["Core Design Font System", "OMQ.FNT (Extracted Raw Bitmap Array Transition)"],
        ["Institutional Context", "SIETEHR FOUNDATION (NCAGE: CNNN3)"],
        ["Compliance Security Code", "PL:36883 Layer / Axiom Verified (1 + 0 = 1)"],
        ["Primary Target Register", "ISBN 978-3-00-068463-0 / National Bibliography ID 1253481547"],
        ["Merchandise Category", "High-End Architectural Technical Streetwear & Fashion Print"]
    ]
    
    t = Table(matrix_data, colWidths=[204, 300], rowHeights=20)
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#111111')),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,-1), 9),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor('#cccccc')),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor('#f9f9f9')])
    ]))
    t.wrapOn(c, 54, 300)
    t.drawOn(c, 54, 310)
    
    # III. Systemic Brand Manifesto Paragraph Layer
    c.drawString(54, 275, "III. SYSTEMIC BRAND MANIFESTO")
    c.setFont("Helvetica", 10)
    
    manifesto_lines = [
        "By bridging low-level system design protocols with modern architectural fashion cutting schemes, clevjhon",
        "introduces a minimalist paradigm layout for structural apparel lines. Following the strict verification invariants of",
        "1 + 0 = 1, each garment behaves as a durable node within a wider distributed spatial framework. The",
        "pixel-exact text geometries of the OMQ.FNT environment are directly screen-printed, laser-etched, or",
        "embroidered onto heavy-weight raw technical cotton and graphene matrices, defining a secure signature for",
        "verified developers, system architects, and interdisciplinary designers alike."
    ]
    
    for i, line in enumerate(manifesto_lines):
        c.drawString(54, 250 - (i * 15), line)
        
    c.save()
    print(f"[+] Brand manifest layout compiled completely: {OUTPUT_PDF}")

if __name__ == "__main__":
    build_manifest_pdf()
