#!/usr/bin/env bash
# =============================================================================
# 🟠 Claude Code Setup Script (Premium Edition)
# Sets up Claude Code with Hooks, MCPs, and synced High-Fidelity Skills.
# Run: chmod +x setup.sh && ./setup.sh
# =============================================================================

set -euo pipefail

BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${BLUE}[claude-setup]${NC} $*"; }
ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
die()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }

log "System Check..."
command -v node >/dev/null 2>&1 || die "Node.js 18+ required"
command -v npm  >/dev/null 2>&1 || die "npm required"
command -v git  >/dev/null 2>&1 || die "git required"
ok "Node $(node -v)"

# 1. Install/Update Claude Code
if command -v claude >/dev/null 2>&1; then
  log "Updating Claude Code to latest April 2026 Release..."
  npm install -g @anthropic-ai/claude-code@latest >/dev/null 2>&1 || warn "Update failed, using existing version."
  ok "Claude Code: $(claude --version 2>/dev/null || echo 'Ready')"
else
  log "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code@latest
  ok "Claude Code installed"
fi

# 2. Config & Directory Setup
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
HOOKS_DIR="$CLAUDE_DIR/hooks"
mkdir -p "$SKILLS_DIR" "$HOOKS_DIR"

# 3. Automatic Skill Sync (The "Elite" Library)
log "Syncing Elite Skills from repository..."
if [[ -d "../skills" ]]; then
  cp ../skills/*.md "$SKILLS_DIR/" 2>/dev/null || true
  ok "Synced $(ls ../skills/*.md 2>/dev/null | wc -l | xargs) ecosystem skills to $SKILLS_DIR"
fi

# 4. Hooks Configuration
log "Initializing Lifecycle Hooks..."
cat > "$CLAUDE_DIR/config.json" << EOF
{
  "alwaysThinkingEnabled": true,
  "maxThinkingTokens": 32000,
  "theme": "dark-premium",
  "hooks": {
    "PostToolUse": "npx eslint --fix \$file 2>/dev/null || true",
    "PreToolUse": "gitleaks protect --staged 2>/dev/null || true"
  }
}
EOF
ok "Hooks configured: ESLint Auto-Fix & Gitleaks Shield enabled."

# 5. Common MCP Servers
log "Installing Core MCP Servers..."
add_mcp() { claude mcp add "$1" npx "$2" 2>/dev/null && ok "MCP: $1" || warn "MCP $1 skipped (already exists or error)"; }
add_mcp filesystem    "@modelcontextprotocol/server-filesystem $PWD"
add_mcp github        "@modelcontextprotocol/server-github"
add_mcp memory        "@modelcontextprotocol/server-memory"
add_mcp playwright    "@playwright/mcp@latest"
add_mcp postgres      "@modelcontextprotocol/server-postgres"

# 6. Initialize CLAUDE.md
if [[ ! -f CLAUDE.md ]]; then
  log "Initializing CLAUDE.md..."
  cat > CLAUDE.md << 'EOF'
# Project Intelligence
## Stack
- Frontend: 
- Backend: 
- Database: 
- Tests: 

## Rules
- Prefer functional components and hooks.
- Every tool use must be followed by manual verification.
- Maintain strict documentation parity.
EOF
  ok "CLAUDE.md created"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Ecosystem Setup Complete!                      ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Commands enabled:"
echo " - /plan-mode        (Skill: multi-step blueprinting)"
echo " - /ui-ux-pro-max    (Skill: Design system generation)"
echo " - Shift+Enter       (Send command)"
echo " - Option+T          (Toggle Extended Thinking)"
echo ""
log "Run 'claude' to begin."
