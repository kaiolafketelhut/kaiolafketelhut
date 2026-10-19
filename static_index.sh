#!/usr/bin/env bash
# ==============================================================================
# Script Name: static_index.sh
# Description: Generates a static HTML landing page for MOSFETQexchange PDFs.
# ==============================================================================

OUTPUT_DIR="./MOSFETQexchange/output"
INDEX_FILE="./MOSFETQexchange/output/index.html"

echo "[*] Generating static publication index..."

cat << HTML_EOF > "${INDEX_FILE}"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MOSFETQexchange — Static Publication Hub</title>
    <style>
        body { font-family: monospace; background: #121212; color: #00ff66; padding: 2rem; }
        h1 { border-bottom: 1px solid #00ff66; padding-bottom: 0.5rem; }
        ul { list-style-type: none; padding: 0; }
        li { margin: 1rem 0; background: #1e1e1e; padding: 1rem; border: 1px solid #333; }
        a { color: #66d9ef; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
        .meta { font-size: 0.8rem; color: #888; margin-top: 0.3rem; }
    </style>
</head>
<body>
    <h1>MOSFETQexchange Static Hub</h1>
    <p>Framework: (0)b Evergreen / Fermat-Euler / JC Theta Constraints ($1 + 0 = 1$)</p>
    <ul>
HTML_EOF

for PDF in "${OUTPUT_DIR}"/*.pdf; do
    [ -f "$PDF" ] || continue
    FILENAME=$(basename "$PDF")
    FILESIZE=$(du -h "$PDF" | cut -f1)
    TIMESTAMP=$(date -r "$PDF" -u +"%Y-%m-%d %H:%M:%S UTC")
    
    cat << HTML_EOF >> "${INDEX_FILE}"
        <li>
            <a href="${FILENAME}" target="_blank">${FILENAME}</a>
            <div class="meta">Size: ${FILESIZE} | Built: ${TIMESTAMP}</div>
        </li>
HTML_EOF
done

cat << 'HTML_EOF' >> "${INDEX_FILE}"
    </ul>
</body>
</html>
HTML_EOF

echo "[+] Static index generated at ${INDEX_FILE}"
