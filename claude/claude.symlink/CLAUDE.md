# CLAUDE.md

## Tool Preferences

Global tool preferences for Claude Code when working in any project.

### Git Operations

- **CRITICAL**: NEVER EVER commit directly to the `main` branch. Work should always be done on a branch.
- When you are asked to create a branch, use the '-b' option as the intent is usually for work to be committed to that
  new branch
- **Prefer**: Direct `git` commands via Bash tool for simple operations
  - `git add`, `git commit`, `git push`, `git pull`, `git status`, `git diff`, `git checkout`, `git branch`, `git merge`
- **NEVER** use `git add .`. **ALWAYS** specify each file that is part of the work being done by name (including new files,
  updated files, and deleted files)

### GitHub Operations

- Prefer the 'gh' GitHub CLI tool over the GitHub MCP
- Always use the '--method' argument when using 'gh api', even for 'GET' operations

### Git Spice (git-spice) Operations

- Use alias `gsp` and not `gs` for `git-spice`. `gs` is used for `git status` on this computer

### File Operations


### Search Operations


### General Principle

