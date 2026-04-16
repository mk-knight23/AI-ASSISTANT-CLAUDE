#!/usr/bin/env bash
# =============================================================================
# ✨ Claude Post-Tool Hook: Lint & Format Auto-Fix
# Automatically cleans up code after Claude's edits.
# =============================================================================

set -euo pipefail

FILE="${1:-}"

# If no file provided, or file doesn't exist, just exit
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  exit 0
fi

# 1. ESLint Auto-Fix (if package.json exists)
if [[ -f package.json ]] && command -v npx >/dev/null 2>&1; then
  echo "🧹 Auto-fixing $FILE..."
  npx eslint --fix "$FILE" 2>/dev/null || true
  npx prettier --write "$FILE" 2>/dev/null || true
fi

# 2. Python (ruff/black)
if [[ "$FILE" == *.py ]] && command -v ruff >/dev/null 2>&1; then
  ruff check --fix "$FILE" 2>/dev/null || true
  ruff format "$FILE" 2>/dev/null || true
fi

exit 0
