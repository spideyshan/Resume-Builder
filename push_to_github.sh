#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Add multi-format export (DOCX/TXT), fix multi-page PDF pagination"
git push
echo "Done!"
