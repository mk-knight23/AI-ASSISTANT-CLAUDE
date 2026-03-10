#!/usr/bin/env bash
# =============================================================================
# Claude Code Setup Script
# Sets up Claude Code with recommended MCP servers, hooks, and skills
# Run: chmod +x setup.sh && ./setup.sh
# =============================================================================

set -euo pipefail

BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${BLUE}[claude-setup]${NC} $*"; }
ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
die()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }

log "Claude Code Setup"

# Prerequisites
command -v node >/dev/null 2>&1 || die "Node.js 18+ required"
command -v npm  >/dev/null 2>&1 || die "npm required"
command -v git  >/dev/null 2>&1 || die "git required"
ok "Node $(node -v)"

# Install Claude Code
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code already installed: $(claude --version 2>/dev/null || echo 'installed')"
else
  log "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
  ok "Claude Code installed"
fi

# API Key
if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  warn "ANTHROPIC_API_KEY not set"
  read -p "Enter Anthropic API key (or press Enter to use claude.ai login): " KEY
  if [[ -n "$KEY" ]]; then
    echo "export ANTHROPIC_API_KEY=$KEY" >> ~/.zshrc 2>/dev/null || \
    echo "export ANTHROPIC_API_KEY=$KEY" >> ~/.bashrc
    export ANTHROPIC_API_KEY="$KEY"
    ok "API key saved"
  else
    warn "No key set - run 'claude' to login via browser"
  fi
else
  ok "ANTHROPIC_API_KEY configured"
fi

# MCP Servers
log "Installing MCP servers..."
add_mcp() { claude mcp add "$1" npx "$2" 2>/dev/null && ok "MCP: $1" || warn "MCP $1 skipped"; }
add_mcp filesystem    "@modelcontextprotocol/server-filesystem /"
add_mcp github        "@modelcontextprotocol/server-github"
add_mcp memory        "@modelcontextprotocol/server-memory"
add_mcp playwright    "@playwright/mcp@latest"

# Skills directory
SKILLS="$HOME/.claude/skills"
mkdir -p "$SKILLS"
ok "Skills dir: $SKILLS (add .md files to create /skill-name commands)"

# CLAUDE.md
if [[ ! -f CLAUDE.md ]]; then
  cat > CLAUDE.md << 'EOF'
# Project Instructions

## Stack
- Language:
- Framework:
- Database:
- Tests:

## Standards
- Immutable patterns (never mutate)
- Functions <50 lines, files <400 lines
- Error handling at all boundaries
- 80%+ test coverage

## Commands
- npm run dev → development
- npm test → tests
EOF
  ok "Created CLAUDE.md (fill in your stack)"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Setup Complete! Run: claude${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Shortcuts: Option+T=thinking, Ctrl+O=verbose, claude --continue=resume"
echo "MCP list:  claude mcp list"
echo "Skills:    $SKILLS"
