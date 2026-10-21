#!/data/data/com.termux/files/usr/bin/bash
cd ~/marketplace
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode fermat_euler_reflection.tex
pdflatex -interaction=nonstopmode jc_sigma.tex
ls -lh *.pdf
cp -v *.pdf ~/kai/docs/ 2>/dev/null; true
echo Done - now push
