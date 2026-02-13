#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Fix PDF export layout, simplify languages, add custom section links"
git push
echo "Done!"
