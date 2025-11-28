# CLAUDE.md

## Tool Preferences

Local tool preferences for Claude Code when working in this repository.

### Git Operations

- **CRITICAL**: NEVER EVER commit directly to the `main` branch. Work should always be done on a branch.
- When you are asked to create a branch, use the '-b' option as the intent is usually for work to be committed to that
  new branch
- **Prefer**: Direct `git` commands via Bash tool for simple operations
  - `git add`, `git commit`, `git push`, `git pull`, `git status`, `git diff`, `git checkout`, `git branch`, `git merge`
- **Use MCP Git tools only for**: Complex operations that benefit from structured responses
  - Never use MCP Git tools for `git add` or `git commit`
- **NEVER** use `git add .`. Always specify each file that is part of the work being done by name (including new files,
  updated files, and deleted files)

### GitHub Operations

- Prefer the 'gh' GitHub CLI tool over the GitHub MCP
- Always use the '--method' argument when using 'gh api', even for 'GET' operations

### Atlassian/Jira/Confluence Operations

- When asked about Jira tickets always use the 'acli' Atlassian CLI tool
- When asked about Confluence pages always use the 'acli' Atlassian CLI tool

#### Examples
**User**: "Show me details about CLM-36797"
**You**: Use `acli jira workitem view CLM-36797`
**User**: "What tickets are assigned to me?"
**You**: Use `acli jira workitem list --jql "assignee = currentUser()"`
**User**: "List all in-progress GUIDE tickets"
**You**: Use `acli jira workitem list --jql "project = GUIDE AND status = 'In Progress'"`

### File Operations

- **Prefer**: Built-in file tools (Read, Write, Edit, MultiEdit) over IntelliJ MCP equivalents
  - Reading files: Use `Read` tool instead of `mcp__intellij__get_file_text_by_path`
  - Writing files: Use `Write` tool instead of IntelliJ file creation
  - Editing files: Use `Edit` or `MultiEdit` tools instead of `mcp__intellij__replace_text_in_file`
  - Directory listing: Use `Bash` (ls) or `Glob` tools, NOT IntelliJ MCP for listing directories or files
- **Use IntelliJ MCP tools only for**: IDE-specific features like symbol navigation, refactoring, code analysis

### Search Operations

- **Prefer**: `Grep` and `Glob` tools for file searching over IntelliJ MCP search tools
- **Use IntelliJ MCP search tools for**: Semantic code searches or IDE-indexed searches

### Jira Integration

- **Pull Request Descriptions**: When creating a PR that addresses a Jira ticket, the **full URL to the Jira ticket must be the first line** of the PR description
  - Example: `https://sonatype.atlassian.net/browse/CLM-36144`
  - This should appear before any other content including summary sections
- **Jira Issue Creation**: The description field cannot be set when creating Jira sub-tasks (and possibly issues). The description must be set with a second API call after creation
- **Jira Description Format**: Jira descriptions need to use ADF (Atlassian Document Format), not markdown. For complex descriptions, use plain text or simple markdown that converts cleanly

### General Principle

Use simple, direct tools for straightforward operations. Reserve MCP tools for operations that benefit from IDE integration or structured data handling.
