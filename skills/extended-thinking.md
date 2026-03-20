# Extended Thinking

## Overview

Extended Thinking allows Claude Code to reserve up to 31,999 tokens for internal reasoning before producing a response. This deeper deliberation improves accuracy on complex tasks such as architectural decisions, multi-step debugging, and large-scale refactoring.

## How It Works

When Extended Thinking is enabled, Claude performs chain-of-thought reasoning in a dedicated thinking buffer before responding. This thinking is internal by default but can be made visible with Verbose Mode.

### Token Budget

- **Maximum**: 31,999 tokens reserved for thinking
- **Default**: Enabled with full budget
- **Custom cap**: Set via environment variable

```bash
# Cap thinking tokens to reduce latency on simpler tasks
export MAX_THINKING_TOKENS=10000
```

## Toggling Extended Thinking

| Method | Action |
|--------|--------|
| **Keyboard** | Option+T (macOS) / Alt+T (Windows/Linux) |
| **Config** | Set `alwaysThinkingEnabled` in `~/.claude/settings.json` |
| **Per-session** | Toggle during conversation with Option+T |

### Configuration

```json
{
  "alwaysThinkingEnabled": true
}
```

## Viewing Thinking Output

By default, thinking is hidden. To see Claude's reasoning process:

- **Verbose Mode**: Press Ctrl+O to toggle verbose output
- Thinking appears as indented, lighter text above the response
- Useful for understanding why Claude made specific decisions

## When to Use Extended Thinking

### High-Value Scenarios

- **Architectural decisions**: Evaluating trade-offs between approaches
- **Complex debugging**: Tracing issues across multiple files and layers
- **Security analysis**: Thorough review of authentication and authorization flows
- **Performance optimization**: Analyzing bottlenecks and evaluating solutions
- **Multi-file refactoring**: Planning changes that span many modules

### Lower-Value Scenarios (Consider Disabling)

- Single-file edits with clear instructions
- Documentation updates
- Simple code generation from templates
- Routine git operations

## Combining with Other Features

### Extended Thinking + Plan Mode

The most powerful combination for complex tasks:

1. Enable Extended Thinking (Option+T)
2. Activate Plan Mode (Shift+Tab)
3. Claude uses deep reasoning to produce a thorough plan
4. Review and approve the plan
5. Execution benefits from the same deep reasoning

### Extended Thinking + Multi-Agent Teams

When orchestrating multiple agents, the orchestrator benefits from Extended Thinking to:

- Determine optimal task decomposition
- Assign work to the right specialist agents
- Synthesize results from parallel agents
- Handle conflicts between agent outputs

## Context Window Considerations

Extended Thinking consumes tokens from the context window. Be mindful when working near context limits:

| Context Usage | Recommendation |
|--------------|----------------|
| Below 60% | Full thinking budget safe |
| 60-80% | Consider reducing MAX_THINKING_TOKENS |
| Above 80% | Disable or use minimal budget |

### Tasks Safe at High Context Usage

- Single-file edits
- Independent utility creation
- Simple bug fixes
- Documentation updates

### Tasks Requiring Low Context Usage

- Large-scale refactoring across many files
- Feature implementation spanning multiple modules
- Complex debugging with many stack frames

## Performance Impact

Extended Thinking adds latency proportional to the thinking budget:

- **10,000 tokens**: ~2-5 seconds additional
- **20,000 tokens**: ~5-10 seconds additional
- **31,999 tokens**: ~10-15 seconds additional

The trade-off is higher quality output. For time-sensitive tasks with clear requirements, disabling thinking reduces response time.

## Troubleshooting

### Thinking seems to repeat or loop

Reduce the token budget. Sometimes a smaller budget forces more concise reasoning:

```bash
export MAX_THINKING_TOKENS=8000
```

### Response quality drops when disabled

Some tasks genuinely require deep reasoning. Re-enable thinking for:

- Multi-step logic
- Code that involves complex state management
- Security-sensitive implementations

### Context window exhaustion

If sessions end prematurely, reduce the thinking budget or start a fresh session with a focused prompt.
