# Claude Code — Features Deep Dive

## Core Architecture

Claude Code is a terminal-native AI coding agent that runs an **agentic loop**: it reads your codebase, plans changes, executes tools, verifies results, and iterates — all autonomously.

```
User Prompt → Agent Loop → Tools → Verification → Response
                  ↑                      |
                  └──────────────────────┘
                     (iterates until done)
```

---

## Feature 1: Agent Loop

Claude Code runs in a continuous loop until the task is complete:
- Reads files, searches code, runs bash commands
- Plans next action, executes, checks output
- Self-corrects on errors without user intervention
- Configurable via `MAX_THINKING_TOKENS` env var

**Config:**
```bash
export MAX_THINKING_TOKENS=31999  # Max extended thinking budget
export ANTHROPIC_MODEL=claude-opus-4-6  # Override model
```

---

## Feature 2: Hooks System

Hooks are shell commands that fire at lifecycle events. They let you inject custom logic around every tool Claude uses.

| Hook Type | Trigger | Use Case |
|-----------|---------|----------|
| `PreToolUse` | Before tool executes | Validate params, block dangerous ops |
| `PostToolUse` | After tool executes | Auto-format, lint, run tests |
| `Stop` | Session ends | Final verification, cleanup |
| `Notification` | Claude has a notification | Desktop alerts, logging |

**Hook config (`~/.claude/settings.json`):**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{"type": "command", "command": "prettier --write $CLAUDE_FILE_PATH"}]
    }]
  }
}
```

---

## Feature 3: Skills (Slash Commands)

Skills are markdown files that expand into full prompts when invoked with `/skill-name`.

**Location:** `~/.claude/skills/`
**Format:** Any `.md` file becomes a `/skill-name` command

**Personal skills detected on this system:**
- `/ui-ux-pro-max` — Design system intelligence (50 styles, 21 patterns)
- `/commit` — Conventional commit creator
- `/review-pr` — PR review orchestrator
- `/tdd` — Test-driven development enforcer
- `/security` — Security audit runner
- `/refactor` — Dead code cleanup
- `/plan` — Implementation planner
- `/debug` — Systematic debugger
- `/octo` — Smart router for all tasks
- `/gws-gmail` — Gmail automation
- `/persona-researcher` — Research orchestrator
- `/recipe-*` — Workflow recipes (50+ recipes)

---

## Feature 4: MCP Server Integrations

Model Context Protocol servers extend Claude's capabilities beyond the terminal.

| Server | Capability |
|--------|-----------|
| `filesystem` | Read/write any file |
| `github` | PRs, issues, repos |
| `memory` | Persistent cross-session memory |
| `playwright` | Browser automation |
| `claude-teams` | Multi-agent coordination |
| `firecrawl` | Web scraping & research |
| `figma` | Design file access |
| `railway` | Cloud deployments |
| `gmail` | Email automation |
| `linear` | Issue tracking |
| `sequential-thinking` | Structured reasoning |
| `web-search-prime` | Web research |

**Add an MCP server:**
```bash
claude mcp add filesystem npx @modelcontextprotocol/server-filesystem /
```

---

## Feature 5: CLAUDE.md Project Instructions

Place `CLAUDE.md` in any project root for project-specific instructions that Claude reads automatically.

```markdown
# My Project

## Tech Stack
- Framework: Next.js 15
- DB: PostgreSQL + Prisma

## Code Standards
- Always use TypeScript strict mode
- Test coverage must be 80%+
- Never commit .env files

## Commands
- `npm run dev` — start dev server
- `npm test` — run tests
```

---

## Feature 6: Extended Thinking

Claude reserves up to **31,999 tokens** for internal reasoning before responding.

- Enabled by default
- Toggle: `Option+T` (macOS)
- Visible in verbose mode: `Ctrl+O`
- Best for: architectural decisions, complex debugging, security analysis

---

## Feature 7: Multi-Agent via claude-teams

Spawn parallel agents on the same task using the `claude-teams` MCP server:

```
Team Lead (Orchestrator)
├── Agent A: Research competitor APIs
├── Agent B: Write implementation
└── Agent C: Security review
```

**Spawn a team:**
```bash
# The claude-teams MCP handles coordination
# Agents communicate via SendMessage tool
# Tasks tracked in ~/.claude/tasks/{team-name}/
```

---

## Feature 8: Memory System

Persistent memory across sessions stored in markdown:

```
~/.claude/projects/{project-hash}/memory/
├── MEMORY.md          # Auto-loaded every session
├── patterns.md        # Coding patterns
├── debugging.md       # Debug insights
└── architecture.md    # System design notes
```

---

## Feature 9: Git Integration

Full git workflow built-in:
- `git status`, `diff`, `log` — reads repo state
- Smart commit messages following Conventional Commits
- PR creation via `gh` CLI
- Branch management
- Never force-pushes without confirmation

---

## Model Selection Guide

| Task | Model | Reason |
|------|-------|--------|
| Architecture, complex bugs | `claude-opus-4-6` | Deepest reasoning |
| Daily coding, reviews | `claude-sonnet-4-6` | Best coding model |
| Simple edits, quick tasks | `claude-haiku-4-5` | 3x cost savings |

---

## Performance Tips

1. Keep `CLAUDE.md` under 500 lines
2. Use `/compact` before long sessions
3. Enable extended thinking for complex refactors
4. Use multi-agent for parallel workstreams
5. Set `MAX_THINKING_TOKENS=10000` for faster responses on simple tasks
