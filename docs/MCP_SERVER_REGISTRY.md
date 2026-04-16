# MCP Server Registry: The Universal Context Layer
## Curated by Kazi Musharraf

The Model Context Protocol (MCP) is the backbone of the Claude Reasoning Hub. This registry catalogs the primary servers used to expand Claude's awareness across the enterprise.

---

## 🏛️ Native Servers (Built-in)

| Service | Description | Capability |
| :--- | :--- | :--- |
| **Filesystem** | Local directory access. | Read, Write, Edit, Create, Delete. |
| **GitHub** | Repository management. | Issues, Pull Requests, Comments, Searching. |
| **Google Drive** | Document access. | Searching docs, reading sheets, extracting text. |
| **Slack** | Team communication. | Reading channels, posting updates, searching history. |

---

## 🚀 Specialized Research Servers

### 1. Firecrawl MCP
- **Vendor**: Firecrawl
- **Usage**: Scrapes websites into clean Markdown for agentic consumption.
- **Goal**: Real-time API documentation discovery.

### 2. Tavily Search
- **Vendor**: Tavily
- **Usage**: LLM-optimized search engine.
- **Goal**: High-fidelity technical research without ad noise.

### 3. Puppeteer / Playwright
- **Vendor**: Integration
- **Usage**: Browser automation.
- **Goal**: Visual UI audits and automated E2E testing.

---

## 🛡️ Security & Utility Servers

### 4. Gitleaks MCP
- **Usage**: Pre-commit secret scanning.
- **Logic**: Intercepts `WriteFile` tool calls to prevent accidental credential leaks.

### 5. Postgres MCP
- **Usage**: Database interaction.
- **Logic**: Inspects schemas and runs test queries for data-driven agentic logic.

### 6. Memory MCP
- **Usage**: Cross-session knowledge persistence.
- **Logic**: Stores architectural decisions in a local vector graph.

---

## 🛠️ Implementation Patterns

To connect a new server, add it to the `mcpServers` object in your local configuration:

```json
{
  "mcpServers": {
    "every-mcp-server": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
    }
  }
}
```

---
*Maintained by the Spectrum Ecosystem | 2026.4*
