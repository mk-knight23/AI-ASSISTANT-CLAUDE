# Security Scanning Workflow

## Overview

Claude Code provides integrated security scanning through agents, hooks, and manual review workflows. This guide covers how to use these tools to identify and remediate vulnerabilities before they reach production.

## Security Scanning Approaches

### 1. Agent-Based Scanning

Use the `security-reviewer` agent for comprehensive analysis:

```
"Use the security-reviewer agent to audit the authentication module"
"Run a security review on the payment processing service"
"Scan src/api/ for OWASP Top 10 vulnerabilities"
```

The agent examines code for:

- Hardcoded secrets (API keys, passwords, tokens)
- SQL injection vulnerabilities
- Cross-site scripting (XSS) vectors
- Cross-site request forgery (CSRF) gaps
- Insecure authentication patterns
- Missing input validation
- Sensitive data exposure
- Insecure deserialization

### 2. Hook-Based Automated Scanning

Configure PreToolUse hooks to catch issues before code is written:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "name": "secret-detection",
        "description": "Block writes containing hardcoded secrets",
        "command": "bash .claude/hooks/detect-secrets.sh",
        "toolNames": ["Write", "Edit"],
        "condition": "always"
      }
    ]
  }
}
```

#### Secret Detection Hook Script

```bash
#!/bin/bash
# .claude/hooks/detect-secrets.sh

INPUT="$CLAUDE_TOOL_INPUT"

PATTERNS=(
  'AKIA[0-9A-Z]{16}'                    # AWS Access Key
  'ghp_[a-zA-Z0-9]{36}'                 # GitHub Personal Token
  'sk-[a-zA-Z0-9]{48}'                  # OpenAI API Key
  'xoxb-[0-9]+-[a-zA-Z0-9]+'           # Slack Bot Token
  'password\s*[:=]\s*["\x27][^$][^"]*'  # Hardcoded passwords
)

for pattern in "${PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qiE "$pattern"; then
    echo "BLOCKED: Potential hardcoded secret detected (pattern: $pattern)"
    exit 1
  fi
done

exit 0
```

### 3. Manual Security Review Prompts

For targeted analysis, use specific prompts:

```
"Review all API endpoints for missing authentication checks"
"Check if user input is sanitized before database queries in src/repositories/"
"Audit the session management implementation for token leakage"
"Verify that error messages in src/api/ do not leak internal details"
```

## Security Checklist

### Authentication and Authorization

- [ ] Passwords hashed with bcrypt (12+ salt rounds) or argon2
- [ ] JWT tokens have reasonable expiry (24 hours or less)
- [ ] Refresh tokens stored in httpOnly cookies, not localStorage
- [ ] Role-based access control on all protected endpoints
- [ ] Account lockout after failed login attempts
- [ ] Password reset tokens expire within 1 hour

### Input Validation

- [ ] All user input validated at API boundaries
- [ ] Schema-based validation (Zod, Joi, or similar)
- [ ] SQL queries use parameterized statements only
- [ ] HTML output sanitized to prevent XSS
- [ ] File uploads validated for type, size, and content

### Data Protection

- [ ] Sensitive data encrypted at rest
- [ ] TLS/HTTPS enforced for all connections
- [ ] PII excluded from logs and error messages
- [ ] Database credentials use environment variables
- [ ] No secrets in source code or git history

### API Security

- [ ] Rate limiting on all public endpoints
- [ ] CORS configured with specific origins (no wildcards)
- [ ] CSRF tokens on state-changing requests
- [ ] Request size limits enforced
- [ ] API versioning prevents breaking changes

## Multi-Agent Security Review

For critical systems, use a multi-perspective security review:

```
Spawn 3 agents in parallel:
  Agent 1: OWASP Top 10 audit of the API layer
  Agent 2: Dependency vulnerability scan (npm audit, pip audit)
  Agent 3: Infrastructure security review (env vars, configs, secrets)
```

### Agent 1: Application Security

```
Focus areas:
  - Injection flaws (SQL, NoSQL, OS command, LDAP)
  - Broken authentication and session management
  - Sensitive data exposure
  - XML external entities (XXE)
  - Broken access control
  - Security misconfiguration
  - Cross-site scripting (XSS)
  - Insecure deserialization
  - Components with known vulnerabilities
  - Insufficient logging and monitoring
```

### Agent 2: Dependency Scanning

```bash
# Node.js
npm audit --production
npx better-npm-audit audit

# Python
pip audit
safety check

# Go
govulncheck ./...
```

### Agent 3: Configuration Review

```
Check for:
  - .env files committed to git
  - Debug mode enabled in production configs
  - Default credentials in configuration files
  - Overly permissive CORS or CSP headers
  - Missing security headers (HSTS, X-Frame-Options)
```

## Severity Ratings

| Severity | Action Required | Examples |
|----------|----------------|---------|
| CRITICAL | Block immediately, fix before proceeding | Hardcoded production secrets, SQL injection |
| HIGH | Fix before commit | Missing auth checks, XSS vulnerabilities |
| MEDIUM | Fix before merge to main | Weak password policy, missing rate limiting |
| LOW | Track and fix in next sprint | Missing security headers, verbose error messages |

## Automated CI Integration

Add security scanning to your CI pipeline:

```yaml
security-scan:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - run: npm audit --production --audit-level=high
    - run: npx eslint --plugin security src/
    - run: claude "Run security-reviewer agent on src/ and report findings"
```

## Response Protocol

When a security issue is found:

1. **Stop** current work immediately
2. **Assess** the severity using the ratings above
3. **Fix** CRITICAL and HIGH issues before continuing
4. **Rotate** any secrets that may have been exposed
5. **Review** the entire codebase for similar patterns
6. **Document** the finding and fix for future reference
