# Keyboard Shortcuts and Slash Commands

## Keyboard Shortcuts

### Navigation and Input

| Shortcut | Action |
|----------|--------|
| **Enter** | Send message / confirm |
| **Shift+Enter** | New line in input |
| **Up Arrow** | Scroll through message history |
| **Ctrl+C** | Cancel current operation / clear input |
| **Ctrl+D** | Exit Claude Code |
| **Escape** | Cancel current action / dismiss dialog |

### Mode Toggles

| Shortcut | Action |
|----------|--------|
| **Option+T** (macOS) / **Alt+T** (Win/Linux) | Toggle Extended Thinking |
| **Shift+Tab** | Toggle Plan Mode (Plan vs Act) |
| **Ctrl+O** | Toggle Verbose Mode (show thinking output) |

### Session Management

| Shortcut | Action |
|----------|--------|
| **Ctrl+L** | Clear screen |
| **Ctrl+R** | Search command history |

## Slash Commands

### Session Commands

| Command | Description |
|---------|-------------|
| `/help` | Show available commands and usage |
| `/clear` | Clear the current conversation context |
| `/exit` or `/quit` | End the session |
| `/compact` | Compact conversation to reduce context usage |
| `/cost` | Show token usage and cost for current session |

### Mode Commands

| Command | Description |
|---------|-------------|
| `/model` | Switch the active model |
| `/fast` | Toggle fast mode (same model, faster output) |
| `/think` | Toggle Extended Thinking |
| `/plan` | Switch to Plan Mode |

### Tool and Permission Commands

| Command | Description |
|---------|-------------|
| `/permissions` | View and manage tool permissions |
| `/mcp` | List connected MCP servers and their tools |
| `/tools` | List all available tools |

### File and Context Commands

| Command | Description |
|---------|-------------|
| `/add` | Add a file or directory to the conversation context |
| `/remove` | Remove a file from context |
| `/memory` | View or edit CLAUDE.md memory files |

### Agent and Task Commands

| Command | Description |
|---------|-------------|
| `/commit` | Create a git commit with generated message |
| `/review-pr` | Review a pull request |
| `/pr` | Create a pull request |

### Skill Commands

Skills are custom slash commands defined in the project or user configuration:

| Command | Description |
|---------|-------------|
| `/skill-name` | Invoke a registered skill by name |

Skills are defined in `.claude/skills/` and loaded at session start.

## CLI Flags

### Session Configuration

```bash
claude                           # Start interactive session
claude "prompt here"             # Run with initial prompt
claude --plan                    # Start in Plan Mode
claude --model opus              # Use specific model
claude --resume                  # Resume last session
claude --continue                # Continue last conversation
claude -p "non-interactive"      # Print mode (non-interactive)
```

### Output Control

```bash
claude --verbose                 # Show detailed output including thinking
claude --json                    # Output in JSON format
claude --no-color                # Disable colored output
claude --quiet                   # Minimize output
```

### Configuration

```bash
claude config                    # Open configuration
claude config set key value      # Set a configuration value
claude config get key            # Get a configuration value
```

### MCP and Tools

```bash
claude mcp list                  # List MCP servers
claude mcp add <name> <cmd>      # Add an MCP server
claude mcp remove <name>         # Remove an MCP server
```

## Permission Shortcuts

When Claude requests permission to use a tool:

| Key | Action |
|-----|--------|
| **y** | Allow this invocation |
| **n** | Deny this invocation |
| **a** | Always allow this tool for this session |

## Quick Reference Card

```
Extended Thinking:  Option+T / Alt+T
Plan Mode:          Shift+Tab
Verbose Output:     Ctrl+O
Clear Screen:       Ctrl+L
Cancel:             Ctrl+C
Exit:               Ctrl+D

/help     - Help
/clear    - Reset context
/compact  - Reduce context
/cost     - Token usage
/model    - Switch model
/fast     - Toggle speed
/commit   - Git commit
/pr       - Pull request
```

## Customizing Shortcuts

Keyboard shortcuts are not currently customizable. Slash commands can be extended by creating custom skills in `.claude/skills/` that register as new commands.
