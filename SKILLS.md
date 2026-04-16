# 🌌 Elite Skill Set: AI-ASSISTANT-CLAUDE

This file defines the high-fidelity agentic skills for the Claude Code / Gemini CLI environment.

---

## 🧠 Skill: Extended Thinking (O1/Opus/Sonnet 2026)
**Trigger**: When encountering complex architectural logic, deep refactors, or high-stakes debugging.
**Instructions**:
1. Use `Option+T` or prepend `(Thinking Mode)` to the request.
2. Force the model to generate a `<thinking>` block of at least 1500 tokens.
3. Analyze "Second-Order Effects" (how this change affects distant components).
4. Verify edge cases (nulls, timeouts, race conditions) before outputting code.

---

## 🏗️ Skill: Plan Mode (Implementation Plan)
**Trigger**: Every non-trivial task.
**Instructions**:
1. Before editing any file, create `implementation_plan.md`.
2. Follow the 4-Phase workflow: Research → Design → Execute → Verify.
3. Include a "User Review Required" section for breaking changes.
4. Do not proceed with execution until the plan is approved.

---

## 🪝 Skill: Hooks Lifecycle Management
**Trigger**: On startup or during environment setup.
**Instructions**:
1. Check `~/.claude/config.json` for active hooks.
2. Ensure `PreToolUse` includes a Gitleaks scan.
3. Ensure `PostToolUse` includes a lint/format execution.
4. If a hook fails, the entire tool chain must abort for safety.

---

## 🤝 Skill: Multi-Assistant Orchestration
**Trigger**: When a task requires specialized execution (e.g., UI design, mass refactoring).
**Instructions**:
1. **Delegate** to Opencode for mechanical tasks using `opencode-switch.sh`.
2. **Consult** Cursor for semantic inline edits in a specific IDE context.
3. **Audit** using Copilot BugBot for production-grade security reviews.
4. Maintain a "Central Repository of Truth" in the `ECOSYSTEM` repository.

---

## 🖇️ Skill: MCP Server Discovery
**Trigger**: When context is missing (database, GitHub, web, local files).
**Instructions**:
1. Run `claude mcp list` to check active servers.
2. If context is missing, suggest: `claude mcp add <name> npx <server>`.
3. Use the `filesystem` server to bridge the gap between isolated repo folders.
4. Use `playwright` for real-time visual verification of UI changes.

---

## 💾 Skill: Persistent Memory (Entity Tracking)
**Trigger**: Complex, long-running projects.
**Instructions**:
1. Maintain an `entities/` folder with JSON files for key modules.
2. Update the `memory` MCP server after every successful task.
3. Summarize "Session Context" in a `SESSION.md` file before closing the CLI.
4. Auto-resume using `claude --continue`.
