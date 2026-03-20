# TDD Workflow with Claude Code

## Overview

Test-Driven Development (TDD) with Claude Code follows the Red-Green-Refactor cycle. Claude writes failing tests first, implements the minimum code to pass them, then refactors for quality. This workflow produces well-tested, well-designed code by default.

## The Red-Green-Refactor Cycle

### Phase 1: RED (Write Failing Test)

Claude writes a test that describes the desired behavior before any implementation exists.

```typescript
// tests/user-service.test.ts
describe("UserService", () => {
  describe("createUser", () => {
    it("should create a user with valid input", async () => {
      const service = new UserService(mockRepository);
      const result = await service.createUser({
        email: "alice@example.com",
        name: "Alice"
      });

      expect(result.success).toBe(true);
      expect(result.data.email).toBe("alice@example.com");
      expect(result.data.id).toBeDefined();
    });

    it("should reject duplicate email addresses", async () => {
      const service = new UserService(mockRepository);
      await service.createUser({ email: "bob@example.com", name: "Bob" });

      const result = await service.createUser({
        email: "bob@example.com",
        name: "Bob Again"
      });

      expect(result.success).toBe(false);
      expect(result.error).toContain("already exists");
    });

    it("should validate email format", async () => {
      const service = new UserService(mockRepository);
      const result = await service.createUser({
        email: "not-an-email",
        name: "Invalid"
      });

      expect(result.success).toBe(false);
      expect(result.error).toContain("invalid email");
    });
  });
});
```

Run the tests. They should all fail because `UserService` does not exist yet.

```bash
npm test -- --testPathPattern=user-service
# Expected: 3 failed, 0 passed
```

### Phase 2: GREEN (Minimal Implementation)

Claude writes the minimum code to make all tests pass.

```typescript
// src/services/user-service.ts
interface CreateUserInput {
  readonly email: string;
  readonly name: string;
}

interface UserResult {
  readonly success: boolean;
  readonly data?: User;
  readonly error?: string;
}

class UserService {
  constructor(private readonly repository: UserRepository) {}

  async createUser(input: CreateUserInput): Promise<UserResult> {
    if (!this.isValidEmail(input.email)) {
      return { success: false, error: "invalid email format" };
    }

    const existing = await this.repository.findByEmail(input.email);
    if (existing) {
      return { success: false, error: "email already exists" };
    }

    const user = await this.repository.create({
      ...input,
      id: generateId()
    });

    return { success: true, data: user };
  }

  private isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}
```

Run the tests again. They should all pass.

```bash
npm test -- --testPathPattern=user-service
# Expected: 3 passed, 0 failed
```

### Phase 3: REFACTOR (Improve Quality)

Claude refactors while keeping all tests green:

- Extract validation into a dedicated module
- Improve error messages with specific details
- Add input sanitization (trim whitespace, lowercase email)
- Ensure immutability patterns are used throughout

```bash
npm test -- --testPathPattern=user-service
# Expected: 3 passed, 0 failed (still green after refactoring)
```

## Using the TDD Guide Agent

Claude Code includes a `tdd-guide` agent that enforces the TDD workflow:

```bash
claude "Use the tdd-guide agent to implement a notification service"
```

The agent will:

1. Ask clarifying questions about requirements
2. Write comprehensive tests covering happy paths and edge cases
3. Verify all tests fail (RED)
4. Implement the minimum code (GREEN)
5. Refactor for quality (IMPROVE)
6. Verify 80%+ code coverage

## Coverage Requirements

The minimum coverage threshold is 80%. Check coverage after implementation:

```bash
npm test -- --coverage
```

### Coverage Breakdown

| Type | Target | Description |
|------|--------|-------------|
| Statements | 80%+ | Lines of code executed |
| Branches | 80%+ | If/else paths covered |
| Functions | 80%+ | Functions called |
| Lines | 80%+ | Physical lines executed |

## Test Categories

### Unit Tests

Test individual functions and classes in isolation:

- Mock all dependencies
- Test one behavior per test case
- Fast execution (milliseconds)

### Integration Tests

Test components working together:

- Use real database (test instance)
- Test API endpoints end-to-end
- Verify data flows correctly between layers

### Edge Case Tests

Always test:

- Empty inputs and null values
- Boundary values (min, max, zero)
- Invalid formats and types
- Concurrent operations
- Error conditions and timeouts

## Common Prompts

```
"Write tests first for a payment processing module"
"TDD approach: build a rate limiter with sliding window"
"Red-green-refactor: implement a search service with pagination"
"Use the tdd-guide to add caching to the user service"
```

## Anti-Patterns to Avoid

1. **Writing implementation before tests**: Always start with RED
2. **Writing too many tests at once**: One test at a time keeps the cycle tight
3. **Fixing tests instead of implementation**: If a test fails, fix the code, not the test (unless the test itself is wrong)
4. **Skipping refactor phase**: GREEN is not done; REFACTOR completes the cycle
5. **Testing implementation details**: Test behavior and outcomes, not internal methods
