# 🚀 AI-ASSISTANT-CLAUDE (Collective Production Edition)

## 💎 Overview
Fully production-grade implementation of AI-ASSISTANT-CLAUDE, refactored by the **69-Agent Opencode Collective**.

## 🛡️ Trust & Compliance
- **CI/CD**: Automated GitHub Actions with Gitleaks security scans.
- **Security**: Standardized [SECURITY.md](SECURITY.md) protocol.
- **Design**: Opencode Premium Design Tokens integrated.

## 🏁 48-Hour Roadmap
1. Initialize infrastructure via `.github/workflows`.
2. Set your secrets in GitHub Environment settings.
3. Deploy to production via Vercel/Docker.

![Claude Code](https://img.shields.io/badge/Claude_Code-Anthropic-FF7F00?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-Latest_2026-22C55E?style=for-the-badge)
![CLI](https://img.shields.io/badge/Interface-CLI_First-0F172A?style=for-the-badge&logo=gnubash)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

> **"90% of Claude Code's code is written by Claude Code itself."** — Anthropic, 2026

Claude Code is Anthropic's official CLI for Claude — a terminal-native, agentic coding assistant that turns your terminal into an autonomous software engineering partner. Unlike IDE-based tools, Claude Code operates directly in your shell, giving you full agent loops, lifecycle hooks, a rich skills system, MCP server integrations, and multi-agent orchestration via claude-teams.

---

## Table of Contents

- [What is Claude Code?](#what-is-claude-code)
- [Key Features](#key-features)
- [How I Use It](#how-i-use-it-personally)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Skills & Agents](#skills--agents)
- [MCP Servers](#mcp-servers)
- [Hooks System](#hooks-system)
- [Workflows](#workflows)
- [Scripts](#scripts)
- [Resources](#resources)

---

## What is Claude Code?

Claude Code is a **CLI-first AI coding assistant** built by Anthropic. It runs in your terminal, reads your files, executes commands, and can autonomously implement features, fix bugs, write tests, manage git history, and deploy code — all while following instructions defined in `CLAUDE.md` files.

**Key differentiators:**
- **Agent loops**: Claude runs in a loop — it reads, writes, executes, observes output, and corrects itself
- **Hooks system**: Pre/PostToolUse, Stop, Notification hooks for full lifecycle control
- **Skills system**: Reusable slash-command workflows stored as markdown in `~/.claude/skills/`
- **MCP servers**: Connect to GitHub, Gmail, Linear, Filesystem, Playwright, and 20+ tools
- **Multi-agent**: Spawn parallel sub-agents via claude-teams for complex tasks
- **CLAUDE.md**: Project-specific AI instructions that persist across sessions
- **Memory**: Persistent notes stored in `~/.claude/projects/*/memory/`

---

## Key Features

### 🤖 Agent Mode
Claude Code runs autonomous multi-step tasks. Give it a goal, and it plans, executes, verifies, and corrects without constant supervision.

```bash
claude "implement user authentication with JWT tokens, add tests, and update the README"
```

### 🔧 Hooks System
Automate lifecycle events:
- `PreToolUse` — validate before any tool executes
- `PostToolUse` — auto-format, lint, or notify after
- `Stop` — final checks when session ends
- `Notification` — alerts on important events

### 🎯 Skills (Slash Commands)
Invoke reusable workflows with `/skill-name`:
```bash
/commit          # Smart conventional commit
/review-pr       # Full PR review with multiple agents
/ui-ux-pro-max   # Generate design systems
/octo            # Smart task router
/tdd             # Test-driven development
```

### 🔌 MCP Servers
Connect external tools — filesystem, GitHub, Gmail, Linear, Slack, Playwright, and more.

### 📋 CLAUDE.md
Project instructions that Claude always reads:
```markdown
# My Project
- Always use TypeScript strict mode
- Run tests before committing
- Use conventional commits format
```

### 🧠 Extended Thinking
Reserve up to 31,999 tokens for deep reasoning. Toggle with `Option+T` or set `alwaysThinkingEnabled` in settings.

### 🌐 Multi-Agent Orchestration
Spawn parallel sub-agents for independent tasks:
```javascript
// claude-teams MCP — spawn 3 agents simultaneously
await spawnTeammate({ task: "security audit" });
await spawnTeammate({ task: "performance review" });
await spawnTeammate({ task: "test coverage" });
```

---

## How I Use It Personally

### Daily Workflow
```bash
# Morning: plan the day
claude "review yesterday's commits and suggest today's priorities"

# Feature work: TDD approach
claude "implement /feature-name using TDD - write tests first"

# Code review before push
/review-pr

# Smart commit
/commit
```

### My Setup
- **Model**: claude-sonnet-4-6 for execution, claude-opus-4-6 for architecture
- **Hooks**: Auto-format (Prettier/Black) on PostToolUse
- **Skills**: 50+ custom skills in `~/.claude/skills/`
- **MCP**: GitHub, Linear, Gmail, Filesystem, Playwright all connected
- **Memory**: Project-specific context stored in memory files

### My CLAUDE.md Template
See `examples/CLAUDE.md` for the template I use on every project.

---

## Quick Start

### Installation
```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Verify
claude --version

# Set API key
export ANTHROPIC_API_KEY="your-key-here"
# Or add to ~/.zshrc / ~/.bashrc
```

### First Project Setup
```bash
# Navigate to your project
cd my-project

# Initialize with CLAUDE.md
claude "create a CLAUDE.md for this project based on the existing codebase"

# Start a task
claude "add input validation to the login form"
```

### Key Commands
```bash
claude                    # Interactive mode
claude "task"             # Single task
claude --model opus       # Use Opus model
claude --dangerously-skip-permissions  # Skip confirmations (caution!)
/help                     # Show available slash commands
/clear                    # Clear conversation
/compact                  # Compress history
/cost                     # Show token usage
```

---

## Project Structure

```
AI-ASSISTANT-CLAUDE/
├── README.md                    # This file
├── index.html                   # Project website
├── docs/
│   ├── FEATURES.md              # Exhaustive feature list
│   ├── GETTING_STARTED.md       # Setup guide
│   ├── WORKFLOWS.md             # Real workflows
│   ├── SKILLS_GUIDE.md          # Skills system deep-dive
│   ├── MCP_SERVERS.md           # MCP integration guide
│   └── HOOKS.md                 # Hooks system guide
├── scripts/
│   ├── setup.sh                 # Full setup script
│   ├── claude-workflow.sh       # Productivity helpers
│   └── create-claude-md.sh      # CLAUDE.md generator
├── workflows/
│   ├── feature-dev.md           # Feature development
│   ├── daily-standup.md         # Daily workflow
│   └── code-review.md           # Code review
├── agents/
│   ├── planner.md               # Planning agent
│   └── code-reviewer.md         # Review agent
├── skills/
│   └── custom-skill-template.md # Skill template
├── examples/
│   ├── CLAUDE.md                # Example project instructions
│   └── hooks-example.json       # Hooks configuration
└── configs/
    ├── .gitignore
    └── mcp-example.json         # MCP configuration
```

---

## Skills & Agents

### Available Skills (from ~/.claude/skills/)
| Skill | Command | Description |
|-------|---------|-------------|
| UI/UX Pro Max | `/ui-ux-pro-max` | Design systems, 50+ styles, 97 color palettes |
| Octo Router | `/octo` | Smart task routing to best agent |
| Commit | `/commit` | Conventional commits with analysis |
| PR Review | `/review-pr` | Multi-agent PR review |
| TDD | `/tdd` | Test-driven development workflow |
| Claude API | `/claude-api` | Build apps with Anthropic SDK |

### Agents (from ~/.claude/agents/)
- `ai-engineer.md` — LLM app development
- `code-reviewer.md` — Security & quality review
- `frontend-developer.md` — React/UI development
- `backend-architect.md` — API & system design
- `tdd-guide.md` — Test-driven workflow
- `security-reviewer.md` — Security analysis
- 40+ more agents configured

---

## MCP Servers

Connected MCP servers in my setup:
```json
{
  "filesystem": "Read/write files beyond project",
  "github": "Issues, PRs, repos",
  "gmail": "Read/compose emails",
  "linear": "Issues & projects",
  "playwright": "Browser automation",
  "claude-teams": "Multi-agent orchestration",
  "firecrawl": "Web scraping",
  "memory": "Knowledge graph"
}
```

See `docs/MCP_SERVERS.md` for full configuration guide.

---

## Hooks System

Example hooks config (`~/.claude/settings.json`):
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{
          "type": "command",
          "command": "prettier --write $CLAUDE_TOOL_OUTPUT_FILE 2>/dev/null || true"
        }]
      }
    ],
    "Stop": [{
      "type": "command",
      "command": "~/.claude/scripts/session-summary.sh"
    }]
  }
}
```

See `docs/HOOKS.md` for full hooks documentation.

---

## Workflows

| Workflow | File | Description |
|----------|------|-------------|
| Feature Dev | `workflows/feature-dev.md` | Plan → TDD → Implement → Review → Commit |
| Daily Standup | `workflows/daily-standup.md` | Morning review + priority setting |
| Code Review | `workflows/code-review.md` | Multi-agent review before PR |

---

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/setup.sh` | Full environment setup |
| `scripts/claude-workflow.sh` | Productivity helper functions |
| `scripts/create-claude-md.sh` | Auto-generate CLAUDE.md |

---

## Resources

- [Official Docs](https://docs.anthropic.com/claude-code)
- [GitHub](https://github.com/anthropics/claude-code)
- [Skills Marketplace](https://skills.anthropic.com)
- [MCP Registry](https://github.com/anthropics/mcp-servers)

---

*Built and maintained with Claude Code itself. Star the repo if it helped!*

## Security

This project follows security best practices:
- No hardcoded credentials
- Dependency scanning enabled
- Security headers configured
- Regular security audits performed
