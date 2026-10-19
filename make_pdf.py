#!/usr/bin/env python3
# ==============================================================================
# Script Name: make_pdf.py
# Description: Dynamically generates a professional template.pdf file by 
#              extracting active user parameters from the SQLite database.
# ==============================================================================

import os
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER
import bunq_db

def create_official_template():
    # Initialize the database to ensure tables are loaded
    bunq_db.init_db()
    
    # 1. Query live data values from our config tables
    isbn_record = bunq_db.get_config("isbn")
    pay_link_record = bunq_db.get_config("settlement_reference")
    
    # Extract values from tuples or use default fallbacks
    isbn = isbn_record[0] if isbn_record else "9783000684630"
    pay_link = pay_link_record[0] if pay_link_record else "https://bunq.me"
    
    print(f"[*] Extracting database variables for PDF generation...")
    print(f"    - ISBN: {isbn}")
    print(f"    - Settlement Gate: {pay_link}")

    # 2. Setup the Document Framework
    pdf_filename = "template.pdf"
    doc = SimpleDocTemplate(pdf_filename, pagesize=letter, rightMargin=54, leftMargin=54, topMargin=54, bottomMargin=54)
    story = []
    
    # Styles
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=28,
        alignment=TA_CENTER
    )
    
    meta_style = ParagraphStyle(
        'MetaStyle',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=10,
        leading=14
    )

    # 3. Build the Document Elements Layout
    story.append(Paragraph("HOCHSCHULPRÜFUNGSARBEIT DNB", title_style))
    story.append(Spacer(1, 15))
    story.append(Paragraph("<b>MOSFETQ – Technologie als Gesellschaftstreiber</b>", styles['Heading2']))
    story.append(Spacer(1, 10))
    
    body_text = """
    Interdisziplinäre Untersuchung an der Schnittstelle von digitaler Hardware,
    Waffentechnologie und Verwaltungskirchenpolitik.
    """
    story.append(Paragraph(body_text, styles['BodyText']))
    story.append(Spacer(1, 20))
    
    # Dynamic fields coming directly from your SQLite database loops
    story.append(Paragraph("<b>BIBLIOGRAPHIC RECORD & METADATA</b>", styles['Heading3']))
    story.append(Spacer(1, 5))
    story.append(Paragraph(f"• <b>Autor:</b> Lic. Kai Olaf Ketelhut", meta_style))
    story.append(Paragraph(f"• <b>ORCID:</b> 0000-0001-6049-8873", meta_style))
    story.append(Paragraph(f"• <b>Station:</b> 52.5200° N, 13.4050° E (Berlin)", meta_style))
    story.append(Paragraph(f"• <b>Standardnummer (ISBN):</b> {isbn}", meta_style))
    story.append(Paragraph(f"• <b>Axiom Constraint:</b> 1 + 0 = 1", meta_style))
    story.append(Spacer(1, 20))
    
    story.append(Paragraph("<b>FULFILLMENT & SETTLEMENT PIPELINE</b>", styles['Heading3']))
    story.append(Spacer(1, 5))
    story.append(Paragraph(f"• <b>Distribution Entity:</b> SIETEHR FOUNDATION (NCAGE: CNNN3)", meta_style))
    story.append(Paragraph(f"• <b>Direktbestellung / Zahlung Gateway Link:</b> <font color='blue'><u>{pay_link}</u></font>", meta_style))
    
    # 4. Compile the page layout
    doc.build(story)
    bunq_db.log_event("PDF_TEMPLATE_GEN", f"Compiled official template.pdf containing ISBN: {isbn}")
    print(f"[+] Official master document compiled successfully at: {pdf_filename}")

if __name__ == "__main__":
    create_official_template()
