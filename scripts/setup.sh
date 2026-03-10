#!/bin/bash
# Claude Code Setup Script
# Run: chmod +x setup.sh && ./setup.sh

set -e
echo "🚀 Setting up Claude Code..."

# 1. Install Claude Code
echo "📦 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# 2. Verify installation
echo "✅ Verifying installation..."
claude --version

# 3. Install skills (Antigravity Awesome Skills — 856+ skills)
echo "🎯 Installing Antigravity Awesome Skills..."
npx antigravity-awesome-skills

# 4. Set up MCP servers
echo "🔌 Installing MCP servers..."
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-sequential-thinking

# 5. Copy MCP config
echo "⚙️  Copying MCP config (edit with your tokens)..."
cp configs/.mcp.json ~/.claude/.mcp.json
echo "⚠️  Edit ~/.claude/.mcp.json and replace YOUR_*_TOKEN_HERE with real values"

# 6. Copy workflow rules
echo "📋 Copying workflow rules..."
mkdir -p ~/.claude/rules/common
cp workflows/agents.md ~/.claude/rules/common/
cp workflows/coding-style.md ~/.claude/rules/common/
cp workflows/git-workflow.md ~/.claude/rules/common/
cp workflows/hooks.md ~/.claude/rules/common/
cp workflows/patterns.md ~/.claude/rules/common/
cp workflows/performance.md ~/.claude/rules/common/
cp workflows/security.md ~/.claude/rules/common/
cp workflows/testing.md ~/.claude/rules/common/

echo ""
echo "✨ Claude Code is ready!"
echo ""
echo "Next steps:"
echo "  1. Set ANTHROPIC_API_KEY: export ANTHROPIC_API_KEY=your_key"
echo "  2. Edit ~/.claude/.mcp.json with your tokens"
echo "  3. Copy examples/CLAUDE.md.example to your project as CLAUDE.md"
echo "  4. Run 'claude' in any project to start"
echo ""
echo "Useful commands:"
echo "  claude          # Start interactive session"
echo "  claude -p 'task' # One-shot task"
echo "  /help           # Show all commands in Claude"
echo "  /settings       # Open settings"
