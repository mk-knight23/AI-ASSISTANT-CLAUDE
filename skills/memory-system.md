# Auto-Memory System

## Overview

Claude Code's memory system enables persistent knowledge that survives across sessions. Memories are stored in markdown files within the project and user directories, allowing Claude to recall preferences, decisions, patterns, and project-specific context without being told repeatedly.

## Memory File Hierarchy

### CLAUDE.md (Project Root)

The primary memory file, located at the project root. Contains:

- Project-specific conventions and patterns
- Build commands and test commands
- Architecture decisions
- Team preferences

```markdown
# CLAUDE.md

## Build & Test
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Conventions
- Use functional components with hooks (no class components)
- All API responses use the envelope pattern: { success, data, error }
- Database queries use the repository pattern

## Architecture
- Monorepo with apps/ and packages/ directories
- Shared types in packages/types
- API gateway in apps/api
```

### ~/.claude/CLAUDE.md (User Global)

User-level preferences that apply across all projects:

```markdown
# Global Preferences

- Prefer TypeScript over JavaScript
- Use 2-space indentation
- Always include error handling
- Commit messages follow conventional commits
```

### Topic-Specific Memory Files

For larger projects, break memory into focused files:

```
.claude/
  CLAUDE.md              # Main project memory
  docs/
    architecture.md      # Architectural decisions
    api-patterns.md      # API design patterns
    testing-strategy.md  # Testing conventions
```

## How Memory Works

### Automatic Loading

When Claude Code starts a session, it automatically reads:

1. `~/.claude/CLAUDE.md` (user global)
2. `CLAUDE.md` in the project root
3. `.claude/CLAUDE.md` if present
4. Any files referenced or imported by the above

### Memory Priority

When memories conflict, more specific sources take precedence:

```
Project .claude/CLAUDE.md  (highest priority)
Project root CLAUDE.md
User ~/.claude/CLAUDE.md   (lowest priority)
```

### Cross-Session Learning

Claude can update memory files during a session when it discovers:

- New build commands or scripts
- Codebase conventions not yet documented
- Architectural decisions made during the session
- Corrections to previously stored information

## Writing Effective Memories

### Good Memory Entries

```markdown
## Database
- ORM: Prisma with PostgreSQL
- Migrations: `npx prisma migrate dev`
- Seed: `npx prisma db seed`
- Always use transactions for multi-table operations
```

### Poor Memory Entries

```markdown
## Stuff
- The database is Postgres
- We use some ORM
```

### Memory Categories

| Category | Examples |
|----------|---------|
| **Commands** | Build, test, lint, deploy commands |
| **Conventions** | Naming, file structure, code style |
| **Architecture** | Module boundaries, data flow, dependencies |
| **Decisions** | Why specific libraries or patterns were chosen |
| **Warnings** | Known issues, gotchas, things to avoid |
| **Preferences** | Output format, verbosity, interaction style |

## MCP Memory Server

For structured, queryable memory beyond flat files, the MCP Memory Server provides a knowledge graph:

### Entities

Named concepts with observations:

```
Entity: "AuthService"
Observations:
  - "Handles JWT token generation and validation"
  - "Located in src/services/auth.ts"
  - "Depends on UserRepository and TokenStore"
```

### Relations

Links between entities:

```
AuthService --depends_on--> UserRepository
AuthService --depends_on--> TokenStore
AuthService --implements--> IAuthProvider
```

### Querying

Search the knowledge graph during a session:

- `search_nodes`: Find entities by keyword
- `read_graph`: View the full graph structure
- `open_nodes`: Retrieve specific entities and their relations

## Best Practices

1. **Keep CLAUDE.md concise**: Focus on actionable information, not documentation
2. **Update regularly**: Remove outdated entries after refactoring
3. **Use sections**: Organize by category for quick scanning
4. **Be specific**: Include exact commands, paths, and patterns
5. **Document decisions**: Record *why*, not just *what*
6. **Avoid duplication**: Do not repeat information available in README or docs

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Claude ignores CLAUDE.md | Verify the file is in the project root or .claude/ directory |
| Conflicting memories | Check priority order; project-level overrides global |
| Memory too large | Split into topic-specific files; remove stale entries |
| Sensitive data in memory | Never store secrets; use environment variables instead |
