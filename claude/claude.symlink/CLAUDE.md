# CLAUDE.local.md

## Code Generation Guidelines

**IMPORTANT**: All generated text-based files must end with a trailing newline character. This ensures proper file formatting, better git diffs, and compliance with POSIX standards. When creating or modifying files:

1. **Always verify** that files end with a newline character
2. **Use bash commands** (e.g., `echo "" >> filename`) if the Write tool doesn't preserve trailing newlines
3. **Check with hexdump** (`tail -c 5 filename | xxd`) to verify proper line endings
4. **Apply to all text files** including: .rs, .java, .cpp, .c, .md, .yaml, .json, .sh, .bat, .env, etc.

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

#### Git Worktrees

- **Prefer**: Use `wtp` (Worktree Plus) binary for Git worktree operations
  - `wtp add <branch-name>` - Creates worktree with automatic path generation
  - `wtp cd <branch-name>` - Navigate to existing worktree
  - `wtp list` - List all worktrees
  - `wtp remove <branch-name>` - Remove worktree and optionally branch
- **Configuration**: Use `.wtp.yml` for development environment setup automation
- **Benefits**: Automatic directory organization, zero-setup environments, shell integration

### GitHub Operations

- Prefer the 'gh' GitHub CLI tool over the GitHub MCP
- Always use the '--method' argument when using 'gh api', even for 'GET' operations

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
