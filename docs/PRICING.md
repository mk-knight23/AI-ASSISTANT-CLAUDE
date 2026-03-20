# Claude Code Pricing

## Subscription Tiers

### Free Tier

| Feature | Included |
|---------|----------|
| **Cost** | $0/month |
| **Usage** | Limited daily messages |
| **Model** | Sonnet 4 (limited) |
| **Extended Thinking** | Not available |
| **MCP Servers** | Basic set |
| **Multi-Agent Teams** | Not available |

Best for: Trying out Claude Code, occasional use, evaluating fit for your workflow.

### Pro Plan

| Feature | Included |
|---------|----------|
| **Cost** | $20/month |
| **Usage** | Higher message limits |
| **Models** | Sonnet 4, Haiku 4.5 |
| **Extended Thinking** | Available |
| **MCP Servers** | Full set |
| **Multi-Agent Teams** | Limited |

Best for: Individual developers using Claude Code regularly for personal projects and daily development work.

### Max Plan

| Feature | Included |
|---------|----------|
| **Cost** | $100/month (also available at $200/month for higher limits) |
| **Usage** | Significantly higher limits |
| **Models** | Opus 4, Sonnet 4, Haiku 4.5 |
| **Extended Thinking** | Full budget (31,999 tokens) |
| **MCP Servers** | Full set + custom |
| **Multi-Agent Teams** | Full access |

Best for: Power users, professional developers, and those who need Opus 4 for deep reasoning tasks.

### Team Plan

| Feature | Included |
|---------|----------|
| **Cost** | $30/user/month |
| **Usage** | Team-level pooled limits |
| **Models** | Sonnet 4, Haiku 4.5 |
| **Extended Thinking** | Available |
| **Admin Controls** | Team management, usage dashboards |
| **Shared Configs** | Team-wide MCP servers and settings |

Best for: Development teams that want centralized management, shared configurations, and pooled usage.

### Enterprise

| Feature | Included |
|---------|----------|
| **Cost** | Custom pricing |
| **Usage** | Custom limits |
| **Models** | All models with priority access |
| **Security** | SSO, audit logs, data retention policies |
| **Support** | Dedicated support, SLAs |
| **Deployment** | On-premise options available |

Best for: Organizations with compliance requirements, custom security needs, and large-scale deployments.

## API Usage (Pay-as-you-go)

For developers using Claude Code via the API directly:

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|------------------------|
| **Opus 4** | $15.00 | $75.00 |
| **Sonnet 4** | $3.00 | $15.00 |
| **Haiku 4.5** | $0.80 | $4.00 |

### Extended Thinking Tokens

Extended Thinking tokens are billed at the model's output token rate. A 31,999-token thinking budget consumes:

| Model | Thinking Cost (max budget) |
|-------|---------------------------|
| Opus 4 | ~$2.40 per max-budget response |
| Sonnet 4 | ~$0.48 per max-budget response |

## Cost Optimization Tips

### 1. Choose the Right Model

Use Haiku 4.5 for routine tasks (90% of Sonnet capability at ~27% of the cost):

```bash
# Default to Haiku for worker agents
export ANTHROPIC_MODEL="claude-haiku-4-20250414"
```

### 2. Manage Extended Thinking

Reduce thinking budget for simpler tasks:

```bash
# Lower thinking budget for routine work
export MAX_THINKING_TOKENS=8000
```

### 3. Use /compact Regularly

The `/compact` command summarizes the conversation to reduce context size, which reduces token consumption on subsequent messages.

### 4. Scope Prompts Tightly

Instead of broad requests, provide specific file paths and clear requirements. This reduces the tokens Claude spends on exploration.

### 5. Monitor Usage

Use `/cost` to check current session costs:

```
/cost
Session tokens: 45,230 input, 12,450 output
Estimated cost: $0.32
```

## Checking Your Plan

```bash
# View current subscription status
claude config get subscription
```

## Billing

- Subscription plans are billed monthly
- API usage is billed based on actual token consumption
- Team plans are billed per seat
- Usage dashboards available at console.anthropic.com
