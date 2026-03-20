# Multi-Agent Team Coordination Example

## Scenario: Building a User Authentication System

This example demonstrates how to orchestrate multiple Claude Code agents to build a complete authentication system with login, registration, password reset, and session management.

## Team Structure

```
Orchestrator (Main Session)
    |
    +-- Agent 1: Backend Worker (auth service + database)
    +-- Agent 2: Frontend Worker (login/register UI)
    +-- Agent 3: Test Worker (unit + integration tests)
    +-- Agent 4: Security Reviewer (vulnerability audit)
```

## Step 1: Create the Team and Plan

```
Prompt: "Create a team to implement user authentication.
Plan the work breakdown, then spawn agents for parallel execution."
```

The orchestrator produces a plan:

```markdown
## Authentication System - Implementation Plan

### Agent 1: Backend Worker
- Create User model with password hashing (bcrypt)
- Implement AuthService (register, login, logout, resetPassword)
- Build API routes (/auth/register, /auth/login, /auth/logout, /auth/reset)
- Add JWT token generation and validation
- Add rate limiting middleware

### Agent 2: Frontend Worker
- Build LoginForm component with validation
- Build RegisterForm component with validation
- Build PasswordResetForm component
- Add auth state management (context/store)
- Implement protected route wrapper

### Agent 3: Test Worker
- Write unit tests for AuthService (all methods)
- Write integration tests for auth API routes
- Write component tests for auth forms
- Verify 80%+ code coverage

### Agent 4: Security Reviewer
- Review password hashing implementation
- Audit JWT token handling (expiry, refresh, storage)
- Check for SQL injection in user queries
- Verify CSRF protection on auth endpoints
- Check rate limiting configuration
```

## Step 2: Spawn Agents

The orchestrator spawns each agent with specific context:

### Agent 1: Backend Worker

```
Task: Implement the authentication backend
Files: src/models/user.ts, src/services/auth-service.ts, src/routes/auth.ts
Constraints:
  - Use bcrypt with 12 salt rounds
  - JWT tokens expire in 24 hours
  - Use repository pattern for database access
  - All functions return immutable result objects
```

### Agent 2: Frontend Worker

```
Task: Build authentication UI components
Files: src/components/auth/*, src/contexts/auth-context.tsx
Constraints:
  - Functional components with hooks only
  - Client-side validation before API calls
  - Accessible form inputs (ARIA labels)
  - Loading states for all async operations
```

### Agent 3: Test Worker

```
Task: Write comprehensive tests for the auth system
Files: tests/unit/auth-service.test.ts, tests/integration/auth-api.test.ts
Constraints:
  - TDD approach (write tests, verify they fail, then fill in stubs)
  - Mock external dependencies (database, email service)
  - Cover happy paths, error cases, and edge cases
  - Target 85%+ coverage
```

### Agent 4: Security Reviewer

```
Task: Audit the authentication implementation for vulnerabilities
Files: All files created by agents 1 and 2
Constraints:
  - Follow OWASP authentication guidelines
  - Check for all Top 10 vulnerabilities
  - Produce a findings report with severity ratings
  - Block any CRITICAL findings
```

## Step 3: Parallel Execution

Agents 1 and 2 run in parallel (no dependencies between backend and frontend).
Agent 3 starts writing test stubs immediately, filling in assertions as Agents 1 and 2 produce code.
Agent 4 waits until Agents 1 and 2 complete before reviewing.

### Communication Flow

```
Agent 1 --> Orchestrator: "Backend complete. AuthService at src/services/auth-service.ts"
Agent 2 --> Orchestrator: "Frontend complete. Components at src/components/auth/"
Orchestrator --> Agent 3: "Backend and frontend ready. Finalize tests."
Orchestrator --> Agent 4: "All code ready. Begin security review."
Agent 3 --> Orchestrator: "Tests passing. Coverage at 87%."
Agent 4 --> Orchestrator: "Review complete. 0 critical, 2 medium findings."
```

## Step 4: Synthesize Results

The orchestrator collects outputs from all agents:

### From Agent 3 (Tests)

```
Test Results:
  AuthService.register: 5 tests passed
  AuthService.login: 4 tests passed
  AuthService.logout: 2 tests passed
  AuthService.resetPassword: 3 tests passed
  Auth API routes: 8 tests passed
  Auth components: 6 tests passed
  Coverage: 87% statements, 82% branches
```

### From Agent 4 (Security Review)

```
Security Findings:
  MEDIUM: JWT refresh token stored in localStorage (recommend httpOnly cookie)
  MEDIUM: Password reset token has no expiry (recommend 1-hour expiry)
  LOW: Missing Content-Security-Policy header on auth pages
```

## Step 5: Address Findings

The orchestrator assigns remediation tasks:

```
Agent 1: Fix JWT storage (move to httpOnly cookie)
Agent 1: Add 1-hour expiry to password reset tokens
Agent 2: Add CSP headers to auth page layout
Agent 3: Update tests to verify the fixes
```

## Final Output

The orchestrator delivers:

- All implemented files with paths
- Test results and coverage report
- Security review findings (all addressed)
- Summary of architectural decisions

## Key Takeaways

1. **Decompose by domain**: Backend, frontend, tests, and security are natural boundaries
2. **Parallelize independent work**: Backend and frontend have no dependencies on each other
3. **Pipeline dependent work**: Security review depends on implementation; run it after
4. **Close the loop**: Address security findings before declaring the work complete
5. **Use structured communication**: Task IDs and status updates keep coordination clean
