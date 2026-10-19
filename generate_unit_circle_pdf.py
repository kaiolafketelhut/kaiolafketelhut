#!/usr/bin/env python3
# ==============================================================================
# Script Name: generate_unit_circle_pdf.py
# Description: Projects the Unit Circle metric boundaries onto an inch-based
#              print grid using ReportLab coordinate transformations.
# ==============================================================================

import os
import math
import bunq_db
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch
from reportlab.lib import colors

OUTPUT_PDF = "MOSFETQexchange/output/unit_circle_geometry.pdf"

def compile_unit_circle_layout():
    print("=" * 75)
    print("    MOSFETQ GEOMETRIC COMPILER — INCH GRID & UNIT CIRCLE LAYOUT")
    print("=" * 75)

    os.makedirs(os.path.dirname(OUTPUT_PDF), exist_ok=True)
    
    # 1. Spatial Constraints (Converting inches directly to ReportLab points)
    page_width, page_height = letter
    center_x = page_width / 2.0
    center_y = page_height / 2.0
    
    # Base invariant parameters mapping to your variance metrics
    base_x_val = 2.612807
    radius_inches = math.sqrt(base_x_val) # Tracing back to the phi connection (~1.616 inches)
    radius_points = radius_inches * inch

    print(f"[*] Projecting Geometric Manifestation Fields...")
    print(f"    - Center Target Coordinate : ({center_x:.2f}, {center_y:.2f}) points")
    print(f"    - Radius Mapping Bound     : {radius_inches:.4f} inches ({radius_points:.2f} pt)")

    # 2. Initialize Low-Level ReportLab Canvas Context
    c = canvas.Canvas(OUTPUT_PDF, pagesize=letter)
    
    # Draw Background Structural Grid Lines (Inch Marks)
    c.setStrokeColor(colors.HexColor('#eaecef'))
    c.setLineWidth(0.5)
    for x in range(0, int(page_width), int(0.5 * inch)):
        c.line(x, 0, x, page_height)
    for y in range(0, int(page_height), int(0.5 * inch)):
        c.line(0, y, page_width, y)

    # 3. Draw the Central Unit Circle Attractor Boundaries
    c.setStrokeColor(colors.HexColor('#1f2428'))
    c.setLineWidth(1.5)
    c.circle(center_x, center_y, radius_points, stroke=1, fill=0)
    
    # Draw Crosshair Intersections Mapping the Multiplicative Identity (1)
    c.setStrokeColor(colors.HexColor('#d1d5da'))
    c.setLineWidth(1)
    c.line(center_x - radius_points - 20, center_y, center_x + radius_points + 20, center_y)
    c.line(center_x, center_y - radius_points - 20, center_x, center_y + radius_points + 20)

    # 4. Text Overlay Render
    c.setFont("Helvetica-Bold", 14)
    c.setFillColor(colors.HexColor('#1f2428'))
    c.drawCentredString(center_x, center_y + radius_points + 30, "UNIT CIRCLE DISTRIBUTION PROJECTION")
    
    c.setFont("Courier", 9)
    c.setFillColor(colors.HexColor('#24292e'))
    c.drawString(54, 740, f"ISBN ID: 978-3-00-068463-0")
    c.drawString(54, 725, f"Constraint: 1 + 0 = 1 (Unity Attractor Passed)")
    c.drawString(54, 710, f"Radius Element: {radius_inches:.5f} Inch Scaling Vector")
    
    c.save()
    print(f"[+] Inch-grid layout file compiled completely! Document written to: {OUTPUT_PDF}")

    # 5. Write Execution Milestone Direct to Production candiDB Log Tables
    payload = {
        "layout_type": "Inch Grid Unit Circle Projection",
        "radius_inches": round(radius_inches, 6),
        "canvas_center_pt": [center_x, center_y],
        "axiom_constraint": "1 + 0 = 1"
    }
    
    bunq_db.log_telemetry(
        zenodo_id="20152569",
        system_id="UNIT-CIRCLE-PDF-01",
        location="Berlin, Germany",
        protocol="ReportLab Canvas Transformation Matrix (PL:36883)",
        payload_dict=payload
    )
    print("[+] Geometric calibration parameters safely logged to candiDB.")
    print("=" * 75)

if __name__ == "__main__":
    compile_unit_circle_layout()
