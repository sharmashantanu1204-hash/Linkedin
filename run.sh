#!/usr/bin/env bash
# =============================================================================
# SEO Analysis Agent — Run
# Reads config.json and launches Claude Code with the SEO analysis prompt.
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Sanity checks ─────────────────────────────────────────────────────────
if ! command -v claude &> /dev/null; then
  echo -e "${RED}Error:${NC} Claude Code not found. Run setup.sh first."
  exit 1
fi

if [ ! -f "config.json" ]; then
  echo -e "${RED}Error:${NC} config.json not found. Are you in the project root?"
  exit 1
fi

if [ ! -f "prompts/seo-analysis.md" ]; then
  echo -e "${RED}Error:${NC} prompts/seo-analysis.md not found."
  exit 1
fi

# ── Read config values ────────────────────────────────────────────────────
read_config() {
  if command -v python3 &> /dev/null; then
    python3 -c "import json; cfg=json.load(open('config.json')); print(cfg.get('$1',''))"
  elif command -v node &> /dev/null; then
    node -e "const c=require('./config.json'); console.log(c['$1']||'')"
  else
    grep -o "\"$1\": *\"[^\"]*\"" config.json | head -1 | cut -d'"' -f4
  fi
}

WEBSITE=$(read_config website_url)
NICHE=$(read_config niche)

if [ "$WEBSITE" = "https://your-website.com" ] || [ -z "$WEBSITE" ]; then
  echo -e "${RED}Error:${NC} Please edit ${BOLD}config.json${NC} and set ${BOLD}website_url${NC} before running."
  exit 1
fi

if [ "$NICHE" = "describe your niche here" ] || [ -z "$NICHE" ]; then
  echo -e "${YELLOW}Warning:${NC} 'niche' is not set in config.json. Keyword research will be less targeted."
fi

# ── Create output directories ─────────────────────────────────────────────
mkdir -p output/site output/keywords

# ── Build the prompt ──────────────────────────────────────────────────────
PROMPT=$(cat prompts/seo-analysis.md)

# ── Launch ────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}SEO Analysis Agent${NC}"
echo "=================================================="
echo -e "  Website : ${BOLD}$WEBSITE${NC}"
echo -e "  Niche   : ${BOLD}$NICHE${NC}"
echo -e "  Output  : ${BOLD}./output/${NC}"
echo "=================================================="
echo ""
echo -e "${YELLOW}Starting Claude Code...${NC}"
echo -e "The agent will crawl your site, research keywords, and write a report."
echo -e "This typically takes ${BOLD}10–25 minutes${NC} depending on site size."
echo ""

# Use --print for non-interactive mode so it runs headlessly and writes output.
# Remove --print if you prefer to watch it work interactively in the Claude Code UI.
exec claude --print "$PROMPT"
