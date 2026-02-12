#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Re-implemented Certifications with Dates, Links, and Black Color; Fixed PDF Filename"
git push
echo "Done!"
