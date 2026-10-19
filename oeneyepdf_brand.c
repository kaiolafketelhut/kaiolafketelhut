#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ==============================================================================
 * Script Name: oeneyepdf_brand.c
 * Description: Clean low-level C graphics generation pipeline emulating the
 *              771-byte oeneyepdf.c writer to output the blocky vector OMQ.FNT.
 * ============================================================================== */

void draw_omq_box(FILE *f, float x, float y, float w, float h) {
    fprintf(f, "%.2f %.2f %.2f %.2f re f\n", x, y, w, h);
}

void render_omq_character(FILE *f, char c, float x_offset, float y_base, float scale) {
    float w = 24.0f * scale;
    float h = 46.0f * scale;
    float th = 8.0f * scale; // Segment-Dicke

    if (c == 'C' || c == 'c') {
        draw_omq_box(f, x_offset, y_base, w, th);
        draw_omq_box(f, x_offset, y_base, th, h);
        draw_omq_box(f, x_offset, y_base + h - th, w, th);
    } else if (c == 'L' || c == 'l') {
        draw_omq_box(f, x_offset, y_base, w, th);
        draw_omq_box(f, x_offset, y_base, th, h);
    } else if (c == 'E' || c == 'e') {
        draw_omq_box(f, x_offset, y_base, w, th);
        draw_omq_box(f, x_offset, y_base, th, h);
        draw_omq_box(f, x_offset, y_base + 19.0f * scale, w - 4.0f * scale, th);
        draw_omq_box(f, x_offset, y_base + h - th, w, th);
    } else if (c == 'V' || c == 'v') {
        draw_omq_box(f, x_offset, y_base + th, th, h - th);
        draw_omq_box(f, x_offset + th, y_base, w - (2 * th), th);
        draw_omq_box(f, x_offset + w - th, y_base + th, th, h - th);
    } else if (c == 'J' || c == 'j') {
        draw_omq_box(f, x_offset, y_base, w - th, th);
        draw_omq_box(f, x_offset, y_base + th, th, 14.0f * scale);
        draw_omq_box(f, x_offset + w - th, y_base, th, h);
    } else if (c == 'H' || c == 'h') {
        draw_omq_box(f, x_offset, y_base, th, h);
        draw_omq_box(f, x_offset + th, y_base + 19.0f * scale, w - (2 * th), th);
        draw_omq_box(f, x_offset + w - th, y_base, th, h);
    } else if (c == 'O' || c == 'o') {
        draw_omq_box(f, x_offset, y_base, w, th);
        draw_omq_box(f, x_offset, y_base, th, h);
        draw_omq_box(f, x_offset + w - th, y_base, th, h);
        draw_omq_box(f, x_offset, y_base + h - th, w, th);
    } else if (c == 'N' || c == 'n') {
        draw_omq_box(f, x_offset, y_base, th, h);
        draw_omq_box(f, x_offset + th, y_base + h - 14.0f * scale, w - (2 * th), th);
        draw_omq_box(f, x_offset + w - th, y_base, th, h);
    }
}

int main() {
    const char *out_path = "MOSFETQexchange/output/clevjhon_fashion_manifest.pdf";
    FILE *f = fopen(out_path, "w");
    if (!f) {
        printf("[-] Error creating target output path file structure.\n");
        return 1;
    }

    // PDF-Struktur-Header schreiben
    fprintf(f, "%%PDF-1.4\n");
    fprintf(f, "1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n");
    fprintf(f, "2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n");
    fprintf(f, "3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R >> endobj\n");
    
    // Stream-Inhalt starten
    fprintf(f, "4 0 obj << /Length 5 0 obj >> stream\n");
    
    // Dunkle Box zeichnen
    fprintf(f, "0.067 0.078 0.082 rg\n");
    fprintf(f, "54.00 530.00 504.00 110.00 re f\n");
    
    // Weiße Schriftfarbe für OMQ-Glyphen einstellen
    fprintf(f, "1.00 1.00 1.00 rg\n");
    
    const char *brand_name = "CLEVJHON";
    float start_x = 94.0f;
    float y_base = 562.0f;
    float text_scale = 1.25f;
    
    for (size_t i = 0; i < strlen(brand_name); i++) {
        render_omq_character(f, brand_name[i], start_x + (i * 54.0f), y_base, text_scale);
    }
    
    fprintf(f, "\nendstream\nendobj\n");
    fprintf(f, "5 0 obj 4000 endobj\n"); 
    fprintf(f, "xref\n0 6\n0000000000 65535 f\n");
    fprintf(f, "trailer << /Size 6 /Root 1 0 R >>\nstartxref\n4500\n%%EOF\n");
    
    fclose(f);
    return 0;
}
