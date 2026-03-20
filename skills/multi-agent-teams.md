# Multi-Agent Teams

## Overview

Claude Code supports spawning and coordinating multiple agent instances that work together on complex tasks. Teams enable parallel execution, specialized roles, and structured communication between agents through a message-passing system.

## Core Concepts

### Team Creation

A team is a named group of agents with a shared objective. The orchestrator creates a team and spawns teammates to handle sub-tasks.

```
TeamCreate: Define the team scope, objective, and communication rules
SpawnTeammate: Launch individual agents with specific roles
SendMessage: Coordinate between agents via structured messages
PollInbox: Check for messages from other agents
```

### Agent Roles

Each teammate receives a role that constrains its focus:

| Role | Responsibility |
|------|---------------|
| Orchestrator | Decomposes tasks, assigns work, synthesizes results |
| Worker | Executes a specific sub-task and reports back |
| Reviewer | Validates output from workers |
| Specialist | Handles domain-specific concerns (security, performance) |

## Creating a Team

### Step 1: Define the Team

```bash
# The orchestrator creates a team with a clear objective
claude "Create a team to implement the user notification system"
```

### Step 2: Spawn Teammates

The orchestrator spawns specialized teammates:

- **Backend worker**: Implements the notification service and database schema
- **Frontend worker**: Builds the notification UI components
- **Test worker**: Writes tests for both backend and frontend
- **Security reviewer**: Audits the implementation for vulnerabilities

### Step 3: Task Assignment

Each teammate receives:

- A specific task description
- Context about the broader objective
- File paths relevant to their work
- Constraints and requirements

### Step 4: Coordination

Agents communicate through structured messages:

- **Status updates**: Progress reports from workers to orchestrator
- **Queries**: Workers asking for clarification or additional context
- **Handoffs**: One agent passing completed work to another
- **Blockers**: Flagging issues that prevent progress

## Communication Patterns

### Hub and Spoke

The orchestrator communicates directly with each worker. Workers do not communicate with each other. Best for independent, parallelizable tasks.

```
        Orchestrator
       /     |      \
  Worker1  Worker2  Worker3
```

### Pipeline

Each agent's output feeds into the next agent's input. Best for sequential workflows like code generation followed by review followed by testing.

```
Writer --> Reviewer --> Tester --> Deployer
```

### Broadcast

The orchestrator sends the same context to all workers and collects diverse perspectives. Best for multi-perspective analysis.

```
Orchestrator --> [Security, Performance, UX, Accessibility]
                        |
                 Orchestrator (synthesize)
```

## Practical Examples

### Feature Implementation Team

```
1. Orchestrator analyzes requirements
2. Spawn planner agent to create implementation plan
3. Spawn 2-3 worker agents for parallel implementation
4. Spawn tdd-guide agent to write tests
5. Spawn code-reviewer agent to review output
6. Orchestrator synthesizes and resolves conflicts
```

### Code Review Team

```
1. Orchestrator identifies files to review
2. Spawn security-reviewer for vulnerability analysis
3. Spawn performance agent for optimization review
4. Spawn consistency agent for style and pattern checks
5. Orchestrator consolidates findings into a single report
```

## Task Management

Teams use a shared task system:

- **task_create**: Define a new task with description and assignee
- **task_get**: Check the status of a specific task
- **task_list**: View all tasks and their states
- **task_update**: Mark tasks as in-progress, completed, or blocked

### Task States

```
Created --> In Progress --> Completed
                |
                +--> Blocked --> In Progress
```

## Best Practices

1. **Keep teams small**: 3-5 agents maximum for most tasks
2. **Define clear boundaries**: Each agent should own distinct files or modules
3. **Use structured messages**: Include task IDs and status in all communication
4. **Handle failures gracefully**: If a teammate fails, the orchestrator should reassign or retry
5. **Avoid circular dependencies**: Design task graphs as DAGs (directed acyclic graphs)

## Limitations

- Teammates share the same billing context
- Each teammate consumes its own context window
- Communication adds latency compared to single-agent execution
- Best suited for tasks that are genuinely parallelizable
- Maximum team size is bounded by available resources

## When to Use Teams vs Single Agent

| Scenario | Approach |
|----------|----------|
| Independent modules to build | Team |
| Multi-perspective review needed | Team |
| Simple sequential task | Single agent |
| Tight file-level dependencies | Single agent |
| Time-sensitive with parallelism | Team |
