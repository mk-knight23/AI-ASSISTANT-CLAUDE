# Hooks System

## Overview

Hooks are user-defined automation scripts that run at specific points in the Claude Code lifecycle. They enable validation, formatting, logging, and custom checks without manual intervention.

## Hook Types

### PreToolUse

Runs **before** a tool is executed. Use cases:

- Validate tool parameters before execution
- Modify parameters (e.g., add default flags)
- Block dangerous operations
- Log tool invocations for auditing

### PostToolUse

Runs **after** a tool completes. Use cases:

- Auto-format generated code (e.g., run Prettier, Black)
- Run linting after file modifications
- Trigger builds after file changes
- Send notifications on completion

### Stop

Runs **when a session ends** or Claude produces a final response. Use cases:

- Final verification of all changes
- Generate summary reports
- Run test suites before accepting results
- Clean up temporary files

## Configuration

Hooks are defined in `.claude/settings.json` at the project or user level:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "name": "block-force-push",
        "description": "Prevent force pushes to protected branches",
        "command": "bash .claude/hooks/block-force-push.sh",
        "toolNames": ["Bash"],
        "condition": "always"
      }
    ],
    "PostToolUse": [
      {
        "name": "auto-format",
        "description": "Run formatter after file edits",
        "command": "bash .claude/hooks/auto-format.sh",
        "toolNames": ["Write", "Edit"],
        "condition": "on_success"
      },
      {
        "name": "lint-check",
        "description": "Run linter after code changes",
        "command": "bash .claude/hooks/lint-check.sh",
        "toolNames": ["Write", "Edit"],
        "condition": "on_success"
      }
    ],
    "Stop": [
      {
        "name": "final-tests",
        "description": "Run test suite before session ends",
        "command": "bash .claude/hooks/run-tests.sh",
        "condition": "always"
      }
    ]
  }
}
```

## Hook Script Structure

Each hook script receives context via environment variables:

| Variable | Description |
|----------|-------------|
| `CLAUDE_TOOL_NAME` | Name of the tool being invoked |
| `CLAUDE_TOOL_INPUT` | JSON string of tool parameters |
| `CLAUDE_TOOL_OUTPUT` | JSON string of tool result (PostToolUse only) |
| `CLAUDE_SESSION_ID` | Current session identifier |
| `CLAUDE_PROJECT_DIR` | Root directory of the project |

### Example: Block Force Push Hook

```bash
#!/bin/bash
# .claude/hooks/block-force-push.sh

INPUT="$CLAUDE_TOOL_INPUT"

if echo "$INPUT" | grep -q "push.*--force"; then
  echo "BLOCKED: Force push is not allowed on this repository."
  exit 1
fi

if echo "$INPUT" | grep -q "reset --hard"; then
  echo "BLOCKED: Hard reset requires explicit user approval."
  exit 1
fi

exit 0
```

### Example: Auto-Format Hook

```bash
#!/bin/bash
# .claude/hooks/auto-format.sh

FILE=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // empty')

if [ -z "$FILE" ]; then
  exit 0
fi

case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx)
    npx prettier --write "$FILE" 2>/dev/null
    ;;
  *.py)
    python -m black "$FILE" 2>/dev/null
    ;;
  *.go)
    gofmt -w "$FILE" 2>/dev/null
    ;;
esac

exit 0
```

## Condition Types

| Condition | When It Runs |
|-----------|-------------|
| `always` | Every time the hook type triggers |
| `on_success` | Only when the tool execution succeeds |
| `on_failure` | Only when the tool execution fails |

## Hook Execution Flow

```
User Request
    |
    v
Claude selects tool
    |
    v
PreToolUse hooks run --> If any hook exits non-zero, tool is BLOCKED
    |
    v
Tool executes
    |
    v
PostToolUse hooks run --> Results are logged but do not block
    |
    v
Response to user
    |
    v
(Session ends) --> Stop hooks run
```

## Automation Patterns

### Pattern 1: Continuous Linting

Run ESLint after every file edit to catch issues immediately:

```json
{
  "name": "eslint-check",
  "command": "npx eslint --fix $CLAUDE_TOOL_INPUT_FILE_PATH",
  "toolNames": ["Write", "Edit"],
  "condition": "on_success"
}
```

### Pattern 2: Security Gate

Block commits that contain potential secrets:

```json
{
  "name": "secret-scan",
  "command": "bash .claude/hooks/secret-scan.sh",
  "toolNames": ["Bash"],
  "condition": "always"
}
```

### Pattern 3: Test on Stop

Run the full test suite before accepting a session's output:

```json
{
  "name": "run-all-tests",
  "command": "npm test",
  "condition": "always"
}
```

## Best Practices

1. Keep hooks fast (under 5 seconds) to avoid slowing down the workflow
2. Use `condition` to avoid running hooks unnecessarily
3. Scope hooks to specific tools with `toolNames` for precision
4. Log hook outputs for debugging but avoid noisy logging
5. Test hooks independently before adding them to configuration
6. Use exit codes consistently: 0 for success, non-zero to block (PreToolUse)
