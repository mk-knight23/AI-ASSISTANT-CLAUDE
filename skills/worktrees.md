# Worktrees

## Overview

Claude Code supports git worktrees for isolated parallel development. A worktree is a separate working directory linked to the same repository, allowing you to work on multiple branches simultaneously without stashing or switching. Claude Code integrates worktree management directly into the CLI session.

## What Are Git Worktrees?

A standard git repository has a single working directory. Worktrees add additional working directories, each checked out to a different branch, all sharing the same `.git` history.

```
my-project/                    (main branch)
my-project/.claude/worktrees/
  feature-auth/                (feature/auth branch)
  bugfix-login/                (bugfix/login branch)
```

Each worktree operates independently: changes in one do not affect another.

## Using Worktrees in Claude Code

### Creating a Worktree

Ask Claude to work in a worktree:

```
"Start a worktree for the authentication feature"
"Create a worktree named payment-refactor"
"Work in a worktree to fix the login bug"
```

Claude creates the worktree inside `.claude/worktrees/` with a new branch based on HEAD.

### Automatic Session Isolation

When a worktree is active:

- The session's working directory switches to the worktree
- All file operations happen within the worktree
- The original working directory is unaffected
- Git operations (commits, branches) are scoped to the worktree

### Cleanup

When the session ends, Claude prompts you to either:

- **Keep** the worktree for continued work later
- **Remove** the worktree and clean up the branch

## Workflow Examples

### Parallel Feature Development

```
Session 1 (worktree: feature-auth)
  - Implement authentication service
  - Write tests
  - Commit changes

Session 2 (worktree: feature-notifications)
  - Build notification system
  - Write tests
  - Commit changes

Both sessions run independently, sharing the same repo history.
```

### Hotfix While Working on a Feature

```
Session 1: Working on a large feature in a worktree
  - Deep into multi-file refactoring
  - Cannot switch branches without losing context

Session 2: Create a new worktree for the hotfix
  - Fix the critical bug
  - Commit and push
  - Merge to production

Return to Session 1: Feature work is untouched
```

### Code Review in Isolation

```
Session 1: Your current work (main worktree)
Session 2: Create a worktree to review a PR
  - Check out the PR branch
  - Run tests
  - Review code changes
  - Leave comments
  - Remove worktree when done
```

## Configuration

Worktree behavior is configured in Claude Code settings:

```json
{
  "worktrees": {
    "baseDir": ".claude/worktrees",
    "autoCleanup": false,
    "branchPrefix": "claude/"
  }
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `baseDir` | `.claude/worktrees` | Directory where worktrees are created |
| `autoCleanup` | `false` | Automatically remove worktrees on session end |
| `branchPrefix` | `claude/` | Prefix for auto-generated branch names |

## Requirements

- Must be inside a git repository
- Git version 2.15 or later (worktree support)
- Must not already be inside a worktree (no nested worktrees)
- Sufficient disk space for the additional working directory

## Commands Reference

| Action | How |
|--------|-----|
| Create worktree | "Start a worktree" or "Create a worktree named X" |
| List worktrees | `git worktree list` |
| Remove worktree | `git worktree remove <path>` |
| Prune stale entries | `git worktree prune` |

## Best Practices

1. **Name worktrees descriptively**: Use feature or ticket names for clarity
2. **Clean up finished worktrees**: Stale worktrees consume disk space
3. **Avoid long-lived worktrees**: Merge frequently to prevent divergence
4. **Do not nest worktrees**: Claude Code prevents this, but manual git commands might not
5. **Use for genuinely parallel work**: If tasks are sequential, a single branch suffices

## Limitations

- Worktrees share the same `.git` directory; large repos may have lock contention
- Some IDE integrations may not detect worktree directories automatically
- Submodules require additional setup in worktrees
- Cannot check out the same branch in multiple worktrees simultaneously
