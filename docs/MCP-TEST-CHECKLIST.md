# MCP Server Test Checklist

**Restart Claude Code first**, then use these prompts to test each MCP server.

## Quick Test - All Servers
```
List all available MCP tools and show me which servers are connected
```

---

## Individual Server Tests

### 1. **Filesystem MCP** ✅
```
Read /Users/mkazi/.claude/.mcp.json and show me the first 20 lines
```
**Expected:** Shows the MCP configuration file

---

### 2. **Memory MCP** ✅
```
Store a memory: "Today I tested all MCP servers on 2026-02-16"
```
**Expected:** Confirmation that memory was stored

---

### 3. **Sequential-thinking MCP** ✅
```
Think step-by-step: What is 15 * 23?
```
**Expected:** Shows reasoning steps before final answer

---

### 4. **GitHub MCP** ✅
```
List my GitHub repositories
```
**Expected:** List of your repos (requires valid GitHub token)

---

### 5. **Context7 MCP** ✅
```
Search Context7 for "React hooks best practices"
```
**Expected:** Relevant documentation from Context7

---

### 6. **Magic MCP** ✅
```
Generate a login button component using Magic
```
**Expected:** UI component code from Magic

---

### 7. **Web-search-prime MCP** (HTTP) ✅
```
Search the web for "Model Context Protocol latest features 2026"
```
**Expected:** Recent search results with URLs

---

### 8. **Web-reader MCP** (HTTP) ✅
```
Read the content of https://www.anthropic.com and summarize it
```
**Expected:** Markdown summary of the webpage

---

### 9. **Zread MCP** (HTTP) ✅
```
Get the repository structure of facebook/react
```
**Expected:** Directory structure of React repo

---

### 10. **Vercel MCP** (HTTP) ✅
```
List my Vercel projects
```
**Expected:** Your Vercel projects (requires auth)

---

### 11. **Railway MCP** ✅
```
List my Railway services
```
**Expected:** Your Railway services (requires auth)

---

### 12. **Supabase MCP** ✅
```
List Supabase tables in my project
```
**Expected:** Database tables (requires project ref setup)

---

### 13. **Firecrawl MCP** ✅
```
Scrape https://example.com using Firecrawl
```
**Expected:** Scraped content (requires API key)

---

### 14. **Figma MCP** ✅
```
List my Figma files
```
**Expected:** Figma files (requires access token)

---

### 15. **ClickHouse MCP** (HTTP) ✅
```
Query ClickHouse for analytics (requires setup)
```
**Expected:** Analytics data (requires configuration)

---

### 16-19. **Cloudflare MCPs** (HTTP) ✅
```
Show Cloudflare documentation
Show Cloudflare Workers builds
Show Cloudflare Workers bindings
Show Cloudflare observability data
```
**Expected:** Relevant Cloudflare data (requires auth)

---

## Test Results Template

Copy and paste this after testing:

```markdown
## MCP Test Results - 2026-02-16

- [ ] Filesystem - Working
- [ ] Memory - Working
- [ ] Sequential-thinking - Working
- [ ] GitHub - Working
- [ ] Context7 - Working
- [ ] Magic - Working
- [ ] Web-search-prime - Working
- [ ] Web-reader - Working
- [ ] Zread - Working
- [ ] Vercel - Working
- [ ] Railway - Working
- [ ] Supabase - Working
- [ ] Firecrawl - Working
- [ ] Figma - Working
- [ ] ClickHouse - Working
- [ ] Cloudflare Docs - Working
- [ ] Cloudflare Workers Builds - Working
- [ ] Cloudflare Workers Bindings - Working
- [ ] Cloudflare Observability - Working

**Total:** X/19 servers working
```

---

## Troubleshooting

### Server not appearing?
1. Check `/Users/mkazi/.claude/.mcp.json` for syntax errors
2. Restart Claude Code completely
3. Check for missing API keys/tokens in env variables

### HTTP servers not working?
1. Verify internet connection
2. Check if API endpoints are accessible
3. Verify authentication tokens are valid

### npm-based servers not working?
1. Run `npx -y @modelcontextprotocol/server-*` to test
2. Check Node.js version: `node --version`
3. Ensure npm packages can download: `npm config get registry`

---

## Next Steps After Testing

1. **Configure missing API keys** for servers that need them:
   - GitHub: Update `GITHUB_PERSONAL_ACCESS_TOKEN`
   - Figma: Add `FIGMA_ACCESS_TOKEN`
   - Firecrawl: Add `FIRECRAWL_API_KEY`
   - Supabase: Update project ref

2. **Remove unused servers** from `.mcp.json` if needed

3. **Create project-specific MCP configs** in individual projects if desired
