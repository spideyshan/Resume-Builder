#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Fix Certification Title font weight in Preview and PDF Export"
git push
echo "Done!"
