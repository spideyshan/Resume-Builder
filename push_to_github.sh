#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Fix PDF export, immutable properties, and duplicate saves"
git push
echo "Done!"
