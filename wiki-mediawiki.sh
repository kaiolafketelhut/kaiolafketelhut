#!/bin/bash
# Unix-like box: TeX -> Wikipedia MediaWiki converter
set -e
cd ~/demo-repository
echo "[*] Converting main.tex -> mediawiki"
if command -v pandoc >/dev/null; then
  pandoc main.tex -t mediawiki -o wiki-auto.txt
  echo "OK -> wiki-auto.txt"
  head -n 30 wiki-auto.txt
else
  echo "pandoc not found, using template wiki.txt"
  echo "pkg install pandoc  # on Termux"
fi
echo ""
echo "[*] Google TeX Gist index:"
echo "site:colegio-san-caio.github.io/demo-repository filetype:tex"
echo ""
echo "[*] Wikipedia namespace ready: Book:978-3-00-068463-0"
