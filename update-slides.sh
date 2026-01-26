#!/bin/bash
set -e

# Configuration
PRIVATE_REPO="git@github.com:xmodar/ai-pros.git"
BRANCH="main"
QUARTO_SUBDIR="slides"  # Quarto project is in this subdirectory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_DIR=$(mktemp -d)

echo "==> Cloning private repo..."
git clone --depth 1 --branch "$BRANCH" "$PRIVATE_REPO" "$TEMP_DIR/source"

echo "==> Rendering Quarto slides..."
cd "$TEMP_DIR/source/$QUARTO_SUBDIR"
quarto render

echo "==> Finding rendered output..."
OUTPUT_DIR=""
if [ -d "_site" ]; then
    OUTPUT_DIR="_site"
elif [ -d "docs" ]; then
    OUTPUT_DIR="docs"
elif [ -d "_output" ]; then
    OUTPUT_DIR="_output"
else
    echo "Error: Could not find output directory (_site, docs, or _output)"
    echo "Contents of slides dir:"
    ls -la
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "==> Copying rendered files from $OUTPUT_DIR..."
cd "$SCRIPT_DIR"

# Remove old rendered content but keep git and config files
find . -maxdepth 1 -type f \( -name "*.html" -o -name "*.json" \) -delete 2>/dev/null || true
rm -rf site_libs W* assets 2>/dev/null || true

# Copy new files
cp -r "$TEMP_DIR/source/$QUARTO_SUBDIR/$OUTPUT_DIR"/* .

echo "==> Cleaning up..."
rm -rf "$TEMP_DIR"

echo "==> Done! Review changes with 'git status', then:"
echo "    git add ."
echo "    git commit -m 'Update slides'"
echo "    git push"
