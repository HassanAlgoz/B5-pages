# B5-pages

Rendered Quarto slides from `xmodar/ai-pros`, published via GitHub Pages.

**Live at:** https://hassanalgoz.github.io/B5-pages/

## Usage

To update the slides:

```bash
cd /home/halgoz/work/AthkaX/just-pages
./update-slides.sh
git add . && git commit -m "Update slides" && git push
```

## Requirements

- Git access to `xmodar/ai-pros`
- [Quarto](https://quarto.org/docs/get-started/) installed locally

## GitHub Pages Setup

This repo circumvents the GitHub Pages limitation on free accounts with private repos:

1. Clone the private repo locally (you have access)
2. Render Quarto slides locally
3. Push the HTML output to this public repo
4. GitHub Pages serves it for free

To enable GitHub Pages (one-time setup):
1. Go to: https://github.com/HassanAlgoz/B5-pages/settings/pages
2. Under "Source", select **Branch: `main`**, Folder: `/ (root)`
3. Click **Save**
