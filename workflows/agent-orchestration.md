# Agent Orchestration

## Overview

Agent orchestration is the practice of coordinating multiple specialized Claude Code agents to accomplish complex tasks. An orchestrator agent decomposes work, assigns sub-tasks to specialist agents, manages communication, and synthesizes results into a coherent output.

## Orchestration Patterns

### 1. Fan-Out / Fan-In

The orchestrator sends independent tasks to multiple agents in parallel, then collects and merges their results.

```
Orchestrator
  |--- spawn --> Agent A (security review)
  |--- spawn --> Agent B (performance review)
  |--- spawn --> Agent C (code quality review)
  |
  collect results
  |
  synthesize into unified report
```

**When to use**: Tasks with independent sub-problems that can run simultaneously.

**Example prompt**:
```
"Review the checkout module from three perspectives in parallel:
 security, performance, and code quality. Synthesize findings."
```

### 2. Pipeline

Each agent's output becomes the next agent's input, forming a sequential chain.

```
Planner --> Implementer --> Reviewer --> Tester --> Deployer
```

**When to use**: Workflows where each step depends on the previous step's output.

**Example prompt**:
```
"Plan the caching layer, implement it, review the code,
 write tests, and prepare deployment config."
```

### 3. Supervisor

A supervisor agent monitors worker agents, reassigns failed tasks, and ensures quality standards.

```
Supervisor
  |--- monitors --> Worker 1 (implementation)
  |--- monitors --> Worker 2 (implementation)
  |--- reassigns failed tasks
  |--- validates output quality
```

**When to use**: Long-running tasks where individual agents may encounter errors.

### 4. Multi-Perspective Analysis

Multiple agents analyze the same artifact from different viewpoints, then the orchestrator resolves conflicts.

```
                Code Under Review
               /       |         \
  Security Expert  Senior Dev  Consistency Checker
               \       |         /
            Orchestrator (resolve conflicts)
```

**When to use**: Critical decisions requiring diverse expert opinions.

## Available Specialist Agents

| Agent | Role | Typical Tasks |
|-------|------|---------------|
| `planner` | Implementation planning | Feature decomposition, risk assessment |
| `architect` | System design | Architecture decisions, technology selection |
| `tdd-guide` | Test-driven development | Write tests first, enforce coverage |
| `code-reviewer` | Code quality | Review code, suggest improvements |
| `security-reviewer` | Security analysis | Vulnerability scanning, OWASP compliance |
| `build-error-resolver` | Build debugging | Fix compilation errors, dependency issues |
| `e2e-runner` | End-to-end testing | Test critical user flows |
| `refactor-cleaner` | Code cleanup | Remove dead code, simplify abstractions |
| `doc-updater` | Documentation | Update docs to match code changes |

## Orchestration Workflow

### Step 1: Decompose the Task

The orchestrator analyzes the request and identifies:

- Independent sub-tasks (can run in parallel)
- Dependent sub-tasks (must run sequentially)
- Required specialist roles
- Shared context each agent needs

### Step 2: Assign and Spawn

For each sub-task:

- Select the appropriate specialist agent
- Provide task-specific context (files, requirements, constraints)
- Set success criteria and output format
- Spawn the agent

### Step 3: Monitor Progress

The orchestrator:

- Polls for status updates from each agent
- Handles blocked agents by providing additional context
- Reassigns tasks if an agent fails
- Tracks overall progress toward the objective

### Step 4: Synthesize Results

Once all agents complete:

- Collect outputs from all agents
- Resolve conflicts between agent recommendations
- Merge code changes, checking for compatibility
- Produce a unified summary

## Example: Full Feature Implementation

```
User: "Implement a rate limiting system for the API"

Orchestrator Plan:
  Phase 1 (Parallel):
    - Planner: Design rate limiting approach (sliding window vs token bucket)
    - Architect: Determine storage backend (Redis vs in-memory)

  Phase 2 (Sequential, after Phase 1):
    - TDD Guide: Write tests for the rate limiter
    - Worker: Implement the rate limiting middleware
    - Worker: Add configuration endpoints

  Phase 3 (Parallel, after Phase 2):
    - Code Reviewer: Review implementation quality
    - Security Reviewer: Audit for bypass vulnerabilities
    - E2E Runner: Test rate limiting under load

  Phase 4 (Sequential, after Phase 3):
    - Doc Updater: Update API documentation
    - Orchestrator: Synthesize all results and present summary
```

## Communication Between Agents

### Structured Messages

All inter-agent communication follows a standard format:

```json
{
  "from": "agent-1-security",
  "to": "orchestrator",
  "taskId": "sec-review-001",
  "status": "completed",
  "findings": [
    {
      "severity": "HIGH",
      "description": "Rate limit header exposes internal counter",
      "file": "src/middleware/rate-limiter.ts",
      "line": 42,
      "recommendation": "Use opaque remaining count instead of raw counter"
    }
  ]
}
```

### Conflict Resolution

When agents disagree:

1. The orchestrator identifies the conflict
2. Both perspectives are presented with reasoning
3. The orchestrator applies project conventions to resolve
4. If unresolvable, the orchestrator escalates to the user

## Best Practices

1. **Start with planning**: Always decompose before spawning agents
2. **Minimize dependencies**: Design tasks to be as independent as possible
3. **Provide sufficient context**: Each agent needs enough context to work autonomously
4. **Set clear boundaries**: Define which files and modules each agent owns
5. **Use the right model for each role**: Haiku for workers, Sonnet for orchestration
6. **Keep teams small**: 3-5 agents per orchestration; larger teams increase coordination overhead
7. **Handle failures**: Plan for agent failures with retry logic and fallback assignments
8. **Validate outputs**: The orchestrator should verify each agent's output before synthesizing

## Anti-Patterns

- **Over-orchestration**: Using teams for tasks a single agent can handle
- **Missing context**: Spawning agents without sufficient background information
- **Circular dependencies**: Creating task graphs where agents wait on each other
- **Ignoring conflicts**: Merging outputs without checking for contradictions
- **Monolithic orchestrators**: Orchestrators that do too much work instead of delegating
