#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Fix high memory usage with lazy PDF generation and async loading, fix PDF export failure"
git push
echo "Done!"
