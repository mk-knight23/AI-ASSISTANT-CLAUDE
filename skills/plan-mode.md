# Plan Mode

## Overview

Plan Mode is a structured approach to implementation within Claude Code CLI. When activated, Claude shifts from immediate execution to a deliberate planning phase, producing a step-by-step implementation plan before writing any code. This ensures alignment between user intent and agent behavior, reducing wasted effort and rework.

## Activation

Plan Mode can be activated in several ways:

- **Shift+Tab** toggles between Plan Mode and Act Mode during a conversation
- **CLI flag**: `claude --plan` starts a session in Plan Mode
- **Conversation prompt**: Asking Claude to "plan first" or "create an implementation plan" triggers planning behavior

## How Plan Mode Works

### Phase 1: Analysis

Claude analyzes the request and gathers context:

- Reads relevant files and understands the codebase structure
- Identifies dependencies, risks, and constraints
- Determines the scope of changes required

### Phase 2: Plan Generation

Claude produces a structured plan:

```
## Implementation Plan

### Phase 1: Data Layer
- [ ] Create user repository interface
- [ ] Implement database adapter
- [ ] Add input validation schemas

### Phase 2: Business Logic
- [ ] Build service layer with error handling
- [ ] Add caching strategy
- [ ] Write unit tests (TDD approach)

### Phase 3: API Surface
- [ ] Define route handlers
- [ ] Add middleware (auth, rate limiting)
- [ ] Write integration tests
```

### Phase 3: User Approval

The plan is presented for review. The user can:

- **Approve** the plan as-is to begin execution
- **Modify** specific steps before execution
- **Reject** and ask for an alternative approach
- **Ask questions** about any step for clarification

### Phase 4: Execution

Once approved, Claude executes the plan step by step, checking off items and reporting progress. Each step produces observable output.

## Best Practices

### When to Use Plan Mode

| Scenario | Recommended |
|----------|-------------|
| Complex multi-file features | Yes |
| Large-scale refactoring | Yes |
| Architectural changes | Yes |
| Simple bug fixes | No |
| Single-file edits | No |
| Documentation updates | No |

### Effective Planning Prompts

- "Plan the implementation of a user authentication system"
- "Create a plan to migrate from REST to GraphQL"
- "Plan how to refactor the payment module into smaller services"

### Combining with Extended Thinking

For maximum reasoning depth, enable both Plan Mode and Extended Thinking:

1. Enable Extended Thinking (Option+T on macOS)
2. Activate Plan Mode (Shift+Tab)
3. Describe the task with full context
4. Review the plan, which benefits from deeper reasoning

## Integration with Agents

Plan Mode works well with the **planner** agent:

```bash
# The planner agent automatically uses Plan Mode
claude "Use the planner agent to design a caching layer"
```

The planner agent produces plans with:

- Dependency graphs between tasks
- Risk assessments for each phase
- Estimated complexity ratings
- Suggested agent assignments for sub-tasks

## Configuration

Plan Mode behavior can be customized in project settings:

```json
{
  "planMode": {
    "autoActivate": false,
    "requireApproval": true,
    "maxPlanDepth": 3,
    "includeRiskAssessment": true
  }
}
```

## Limitations

- Plans are suggestions, not guarantees of exact execution order
- Very large plans may need to be broken into multiple sessions
- Plan Mode adds latency before execution begins; skip it for trivial tasks
