#!/bin/bash
set -e

# Configuration
PRIVATE_REPO="git@github.com:xmodar/ai-pros.git"
BRANCH="main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_DIR=$(mktemp -d)

echo "==> Cloning private repo..."
git clone --depth 1 --branch "$BRANCH" "$PRIVATE_REPO" "$TEMP_DIR/source"

echo "==> Rendering Quarto slides..."
cd "$TEMP_DIR/source"
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
    echo "Contents of repo:"
    ls -la
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "==> Copying rendered files from $OUTPUT_DIR..."
cd "$SCRIPT_DIR"

# Remove old HTML files but keep git and config files
find . -maxdepth 1 -name "*.html" -delete 2>/dev/null || true
rm -rf site_libs search.json 2>/dev/null || true

# Copy new files
cp -r "$TEMP_DIR/source/$OUTPUT_DIR"/* .

echo "==> Cleaning up..."
rm -rf "$TEMP_DIR"

echo "==> Done! Review changes with 'git status', then:"
echo "    git add ."
echo "    git commit -m 'Update slides'"
echo "    git push"
