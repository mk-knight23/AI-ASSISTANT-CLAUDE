# MCP Servers (Model Context Protocol)

## Overview

The Model Context Protocol (MCP) is an open standard that allows Claude Code to connect to external tools and data sources through a unified interface. MCP servers expose tools, resources, and prompts that Claude can discover and invoke during a session.

## Architecture

```
Claude Code CLI
    |
    +-- MCP Client (built-in)
          |
          +-- MCP Server: Filesystem
          +-- MCP Server: GitHub
          +-- MCP Server: PostgreSQL
          +-- MCP Server: Custom (your own)
```

### Key Components

| Component | Description |
|-----------|-------------|
| **MCP Client** | Built into Claude Code, discovers and calls server tools |
| **MCP Server** | A process that exposes tools via the MCP protocol |
| **Tools** | Functions the server makes available (e.g., read_file, search) |
| **Resources** | Data the server can provide (e.g., database schemas) |
| **Prompts** | Pre-defined prompt templates the server offers |

## Built-in MCP Servers

Claude Code ships with several commonly used MCP servers:

### Filesystem Server

Provides file operations beyond the built-in tools:

- `list_directory`: List files with sizes and metadata
- `read_file` / `write_file`: File I/O operations
- `search_files`: Search by name pattern
- `directory_tree`: Recursive directory listing
- `edit_file`: Apply edits to files

### GitHub Server

Access GitHub APIs without leaving the CLI:

- `list_issues` / `get_issue`: Issue management
- `create_pull_request` / `get_pull_request`: PR workflows
- `search_code` / `search_repositories`: Code search
- `list_commits`: Commit history

### Memory Server

Persistent knowledge graph across sessions:

- `create_entities`: Store named concepts
- `create_relations`: Link entities together
- `search_nodes`: Query the knowledge graph
- `read_graph`: View the full graph

## Configuration

MCP servers are configured in the Claude settings file or project-level configuration.

### Global Configuration (~/.claude/settings.json)

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-filesystem", "/path/to/allowed/dir"],
      "env": {}
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

### Project Configuration (.claude/settings.json)

Project-level servers are scoped to a specific codebase:

```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-postgres", "postgresql://localhost/mydb"],
      "env": {}
    }
  }
}
```

## Creating a Custom MCP Server

### Step 1: Define Tools

Each tool has a name, description, and input schema:

```json
{
  "name": "search_logs",
  "description": "Search application logs by date range and severity",
  "inputSchema": {
    "type": "object",
    "properties": {
      "startDate": { "type": "string", "format": "date" },
      "endDate": { "type": "string", "format": "date" },
      "severity": { "type": "string", "enum": ["info", "warn", "error"] }
    },
    "required": ["severity"]
  }
}
```

### Step 2: Implement the Server

Use the MCP SDK (available in TypeScript and Python):

```bash
# TypeScript
npm install @anthropic/mcp-sdk

# Python
pip install mcp
```

### Step 3: Register with Claude Code

Add the server to your configuration file and restart Claude Code.

## Tool Discovery

When Claude Code starts, it queries all configured MCP servers to discover available tools. Tools appear alongside built-in tools and can be invoked naturally in conversation.

Some tools are **deferred** (loaded on demand) to keep startup fast. Use the ToolSearch mechanism to discover and load deferred tools during a session.

## Security Considerations

- MCP servers run as local processes with the permissions of the current user
- Sensitive environment variables (API keys, tokens) should use a secret manager
- Restrict filesystem server paths to project directories only
- Review third-party MCP servers before installing
- Servers have no network sandboxing by default; audit outbound connections

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Server fails to start | Check the command path and ensure dependencies are installed |
| Tools not appearing | Restart Claude Code after configuration changes |
| Authentication errors | Verify environment variables are set correctly |
| Slow tool responses | Check server process resource usage |

## Community Servers

The MCP ecosystem includes community-built servers for:

- Slack, Linear, Jira, Confluence
- PostgreSQL, MongoDB, Redis
- Docker, Kubernetes
- Figma, Canva
- Web scraping (Firecrawl, Playwright)

Browse available servers at the MCP server registry and install via npm or pip.
