#!/usr/bin/env bash
# =============================================================================
# 🛡️ Claude Pre-Tool Hook: Gitleaks Shield
# Ensures no secrets are about to be committed or used in tool execution.
# =============================================================================

set -euo pipefail

# Only run if gitleaks is installed
if ! command -v gitleaks >/dev/null 2>&1; then
  exit 0
fi

# Run gitleaks on staged files
if ! gitleaks protect --staged --staged --verbose; then
  echo "❌ [SECURITY BLOCK]: Secrets detected in staged changes. Tool execution aborted."
  exit 1
fi

exit 0
