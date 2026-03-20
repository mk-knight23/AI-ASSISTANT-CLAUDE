# Claude Models

## Overview

Claude Code supports multiple Claude model variants, each optimized for different use cases. Selecting the right model balances quality, speed, and cost for your specific task.

## Model Comparison

| Model | Strengths | Best For | Relative Cost |
|-------|-----------|----------|---------------|
| **Opus 4** | Deepest reasoning, highest accuracy | Complex architecture, research, analysis | Highest |
| **Sonnet 4** | Best coding model, strong reasoning | Day-to-day development, orchestration | Medium |
| **Haiku 4.5** | Fast, cost-effective, 90% of Sonnet capability | Worker agents, pair programming | Lowest |

## Opus 4

### Capabilities

- Deepest chain-of-thought reasoning
- Strongest performance on complex multi-step problems
- Best at architectural decisions requiring trade-off analysis
- Highest accuracy on ambiguous or underspecified tasks

### When to Use

- Designing system architecture from scratch
- Making decisions with significant long-term impact
- Analyzing complex security vulnerabilities
- Research tasks requiring synthesis of many sources
- Debugging issues that span multiple systems

### When to Avoid

- Simple code generation with clear specifications
- High-volume, repetitive tasks (cost adds up quickly)
- Tasks where Sonnet 4 produces equivalent results

### Configuration

```bash
export ANTHROPIC_MODEL="claude-opus-4-20250514"
```

## Sonnet 4

### Capabilities

- Best balance of coding ability and reasoning
- Strong at multi-file refactoring and feature implementation
- Excellent at orchestrating multi-agent workflows
- Fast enough for interactive development

### When to Use

- Primary development work (features, bug fixes, refactoring)
- Code review and quality analysis
- Orchestrating multi-agent teams
- Complex coding tasks with clear requirements
- Interactive pair programming sessions

### When to Avoid

- Tasks where Haiku 4.5 is sufficient (simple edits, formatting)
- Tasks requiring maximum reasoning depth (use Opus 4)

### Configuration

```bash
export ANTHROPIC_MODEL="claude-sonnet-4-20250514"
```

## Haiku 4.5

### Capabilities

- 90% of Sonnet's coding capability at roughly one-third the cost
- Fastest response times across all models
- Strong at well-defined, scoped tasks
- Excellent for high-frequency agent invocations

### When to Use

- Worker agents in multi-agent systems
- Pair programming and code generation
- Simple bug fixes with clear reproduction steps
- Code formatting and style corrections
- Documentation updates
- Lightweight agents invoked frequently

### When to Avoid

- Complex architectural decisions
- Tasks requiring deep multi-step reasoning
- Ambiguous requirements needing interpretation

### Configuration

```bash
export ANTHROPIC_MODEL="claude-haiku-4-20250414"
```

## Model Selection Strategy

### By Task Complexity

```
Low Complexity  --> Haiku 4.5
  - Single-file edits
  - Clear specifications
  - Formatting/style fixes

Medium Complexity --> Sonnet 4
  - Multi-file features
  - Refactoring
  - Code review

High Complexity  --> Opus 4
  - Architecture design
  - Complex debugging
  - Security analysis
```

### By Role in Multi-Agent Systems

```
Orchestrator Agent  --> Sonnet 4 or Opus 4
  - Needs strong reasoning to decompose tasks
  - Must synthesize results from multiple workers

Worker Agents       --> Haiku 4.5
  - Execute well-defined sub-tasks
  - High invocation frequency makes cost important

Reviewer Agents     --> Sonnet 4
  - Needs good judgment for code quality
  - Must catch subtle issues
```

### Cost Optimization

For teams managing costs:

1. Default to Haiku 4.5 for routine tasks
2. Escalate to Sonnet 4 for coding work
3. Reserve Opus 4 for architectural decisions and complex analysis
4. Monitor usage by model to identify optimization opportunities

## Switching Models

### Per Session

```bash
ANTHROPIC_MODEL=claude-opus-4-20250514 claude
```

### In Settings

```json
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4-20250514"
  }
}
```

### Within a Conversation

Use the `/model` command to switch models mid-session (subject to availability).

## Context Window

All current Claude models share a 200K token context window. Context management best practices:

- Avoid the last 20% of the context window for complex tasks
- Start fresh sessions for unrelated tasks
- Use focused prompts to reduce context consumption
- Extended Thinking tokens count against the context budget
