#!/bin/bash
echo "Pushing code to GitHub..."
git add .
git commit -m "Add profile photo support with memory-safe image resizing"
git push
echo "Done!"
