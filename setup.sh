#!/usr/bin/env bash
# =============================================================================
# SEO Analysis Agent — One-time MCP Setup
# Run this once before using the agent for the first time.
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}SEO Analysis Agent — Setup${NC}"
echo "=================================================="
echo ""

# ── Prerequisite: Claude Code ──────────────────────────────────────────────
if ! command -v claude &> /dev/null; then
  echo -e "${RED}Error:${NC} Claude Code is not installed."
  echo "  Visit https://claude.ai/code to install it, then re-run this script."
  exit 1
fi

echo -e "${GREEN}✔${NC} Claude Code found: $(claude --version 2>/dev/null || echo 'installed')"

# ── Prerequisite: Node / npx (needed for Playwright MCP) ───────────────────
if ! command -v npx &> /dev/null; then
  echo -e "${RED}Error:${NC} npx is not installed. Install Node.js from https://nodejs.org/ and retry."
  exit 1
fi

echo -e "${GREEN}✔${NC} Node/npx found"
echo ""

# ── Step 1: Install Playwright MCP ─────────────────────────────────────────
echo -e "${BOLD}Step 1/3${NC} — Installing Playwright MCP..."
if claude mcp add playwright -- npx @anthropic-ai/mcp-server-playwright 2>&1; then
  echo -e "${GREEN}✔${NC} Playwright MCP installed"
else
  echo -e "${YELLOW}⚠${NC}  Playwright MCP may already be installed — continuing."
fi
echo ""

# ── Step 2: SerpAPI key ────────────────────────────────────────────────────
echo -e "${BOLD}Step 2/3${NC} — SerpAPI setup"
echo "  Get a free API key at: https://serpapi.com/manage-api-key"
echo ""

if [ -n "$SERPAPI_KEY" ]; then
  echo -e "${GREEN}✔${NC} Using SERPAPI_KEY from environment."
else
  echo -n "  Enter your SerpAPI key: "
  read -r SERPAPI_KEY
  echo ""

  if [ -z "$SERPAPI_KEY" ]; then
    echo -e "${RED}Error:${NC} No API key provided. Re-run setup once you have one."
    exit 1
  fi
fi

# ── Step 3: Install SerpAPI MCP ────────────────────────────────────────────
echo -e "${BOLD}Step 3/3${NC} — Installing SerpAPI MCP..."
if claude mcp add serpapi --url "https://mcp.serpapi.com/${SERPAPI_KEY}/mcp" 2>&1; then
  echo -e "${GREEN}✔${NC} SerpAPI MCP installed"
else
  echo -e "${YELLOW}⚠${NC}  SerpAPI MCP may already be installed — continuing."
fi
echo ""

# ── Persist the key into config.json ───────────────────────────────────────
if python3 -c "import json, sys
cfg = json.load(open('config.json'))
cfg['serpapi_key'] = sys.argv[1]
json.dump(cfg, open('config.json','w'), indent=2)
print('config.json updated')
" "$SERPAPI_KEY" 2>/dev/null; then
  echo -e "${GREEN}✔${NC} Saved SerpAPI key to config.json"
elif command -v node &> /dev/null; then
  node -e "
const fs = require('fs');
const cfg = JSON.parse(fs.readFileSync('config.json','utf8'));
cfg.serpapi_key = process.argv[1];
fs.writeFileSync('config.json', JSON.stringify(cfg, null, 2));
console.log('config.json updated');
" "$SERPAPI_KEY"
  echo -e "${GREEN}✔${NC} Saved SerpAPI key to config.json"
else
  echo -e "${YELLOW}⚠${NC}  Could not update config.json automatically."
  echo "   Please open config.json and set the serpapi_key field manually."
fi

# ── Verify both MCPs are registered ────────────────────────────────────────
echo ""
echo "Verifying registered MCPs..."
claude mcp list 2>/dev/null && echo "" || true

# ── Done ───────────────────────────────────────────────────────────────────
echo "=================================================="
echo -e "${GREEN}${BOLD}Setup complete!${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Edit ${BOLD}config.json${NC} — set your website_url and niche"
echo -e "  2. Run ${BOLD}./run.sh${NC} to start the SEO analysis"
echo ""
