# IDE Integration

## Overview

Claude Code integrates with popular editors and IDEs, providing AI-assisted development directly within your coding environment. This guide covers setup and usage for VS Code, JetBrains IDEs, and Vim/Neovim.

## VS Code

### Installation

1. Open the Extensions panel (Cmd+Shift+X on macOS, Ctrl+Shift+X on Windows/Linux)
2. Search for "Claude Code"
3. Click Install
4. Restart VS Code

Alternatively, install from the command line:

```bash
code --install-extension anthropic.claude-code
```

### Features

| Feature | Description |
|---------|-------------|
| **Inline Chat** | Open Claude Code in a panel alongside your editor |
| **Terminal Integration** | Run Claude Code in the VS Code integrated terminal |
| **File Context** | Automatically includes open files as context |
| **Diff View** | Review proposed changes in VS Code's diff viewer |
| **Quick Actions** | Code actions menu includes Claude-powered suggestions |

### Usage

- **Open Claude Panel**: Cmd+Shift+P (macOS) / Ctrl+Shift+P, then "Claude Code: Open"
- **Send Selection**: Select code, right-click, "Ask Claude about selection"
- **Inline Edit**: Select code, Cmd+K (macOS) / Ctrl+K, type your edit instruction
- **Terminal Mode**: Open terminal and run `claude` directly

### Configuration

Settings can be configured in VS Code's settings.json:

```json
{
  "claude-code.model": "claude-sonnet-4-20250514",
  "claude-code.enableExtendedThinking": true,
  "claude-code.terminalIntegration": true,
  "claude-code.autoFormat": true
}
```

### Recommended Extensions to Pair

- **GitLens**: Enhanced git integration alongside Claude's git workflows
- **Error Lens**: Inline error display that complements Claude's error fixing
- **Prettier**: Auto-formatting that works with Claude's PostToolUse hooks

## JetBrains IDEs

### Supported IDEs

- IntelliJ IDEA
- WebStorm
- PyCharm
- GoLand
- PhpStorm
- Rider
- CLion
- RubyMine

### Installation

1. Open Settings/Preferences (Cmd+, on macOS, Ctrl+Alt+S on Windows/Linux)
2. Navigate to Plugins > Marketplace
3. Search for "Claude Code"
4. Click Install and restart the IDE

### Features

| Feature | Description |
|---------|-------------|
| **Tool Window** | Dedicated Claude Code panel in the IDE |
| **Terminal Integration** | Run Claude Code in the built-in terminal |
| **Context Awareness** | Understands project structure, run configurations |
| **Refactoring Support** | Integrates with JetBrains refactoring tools |

### Usage

- **Open Claude Panel**: View > Tool Windows > Claude Code
- **Ask about Code**: Right-click on code > Claude Code > Ask about this code
- **Terminal**: Open the terminal tab and run `claude`
- **Action Search**: Double-tap Shift, type "Claude" to see all actions

### Configuration

Configure in Settings > Tools > Claude Code:

```
Model: claude-sonnet-4-20250514
Extended Thinking: Enabled
Auto-format on save: Enabled
Terminal integration: Enabled
```

## Vim / Neovim

### Neovim Setup (Recommended)

Claude Code works with Neovim through the terminal. The recommended approach is to use Claude Code in a terminal split or tab.

#### Using Terminal Splits

```vim
" Open Claude Code in a vertical split terminal
:vsplit | terminal claude

" Open in a horizontal split
:split | terminal claude

" Open in a new tab
:tabnew | terminal claude
```

#### Plugin Integration (claude.nvim)

For deeper integration, community plugins provide:

```lua
-- lazy.nvim configuration
{
  "anthropics/claude.nvim",
  config = function()
    require("claude").setup({
      model = "claude-sonnet-4-20250514",
      keymaps = {
        open_chat = "<leader>cc",
        send_selection = "<leader>cs",
        accept_change = "<leader>ca",
        reject_change = "<leader>cr",
      },
    })
  end,
}
```

### Vim Setup

For classic Vim, use terminal mode:

```vim
" Open Claude Code in a terminal window
:terminal claude

" Switch between terminal and editor
Ctrl+W then N (terminal to normal mode)
i (normal to terminal mode)
```

### Key Bindings (Example)

```vim
" Open Claude Code
nnoremap <leader>cc :vsplit \| terminal claude<CR>

" Send visual selection to Claude
vnoremap <leader>cs :w !claude -p "Explain this code"<CR>

" Ask Claude to fix the current file
nnoremap <leader>cf :!claude -p "Fix any issues in %"<CR>
```

## Terminal-First Workflow

For any editor, Claude Code works directly in the terminal:

```bash
# Start Claude Code in the project directory
cd /path/to/project
claude

# Or run a one-shot command
claude -p "Explain the authentication flow in this project"

# Pipe code to Claude
cat src/auth.ts | claude -p "Review this code for security issues"
```

## Editor-Agnostic Tips

1. **Use CLAUDE.md**: All editors benefit from project-level memory files
2. **Configure hooks**: Auto-formatting hooks work regardless of editor
3. **Terminal is always available**: Claude Code's CLI works in any terminal emulator
4. **File watchers**: Some editors detect file changes made by Claude Code automatically; enable auto-reload if not
5. **Git integration**: Claude Code's git workflows complement any editor's git support
