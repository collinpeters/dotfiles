# GitHub PR Review Skill

A comprehensive Claude Code skill for systematically reviewing and resolving GitHub pull request comments.

## Overview

This skill provides Claude with the ability to:
- List all unresolved PR comment threads
- Analyze code review feedback in context
- Make appropriate code fixes
- Commit changes with descriptive messages
- Reply to review threads with fix details

## Features

- **Two Workflows**:
  - Review all unresolved comments on a PR
  - Review a single specific comment by URL
- **Self-Contained**: All scripts and dependencies included
- **No MCP Server Required**: Uses standalone bash scripts
- **GitHub GraphQL API**: Leverages GitHub's official API via `gh` CLI

## Prerequisites

Before using this skill, ensure you have:

1. **GitHub CLI (`gh`)** - [Installation instructions](https://github.com/cli/cli#installation)
   ```bash
   gh --version
   ```

2. **GitHub Authentication**
   ```bash
   gh auth login
   ```

3. **jq** - JSON processor
   ```bash
   # macOS
   brew install jq

   # Ubuntu/Debian
   sudo apt-get install jq

   # Arch Linux
   sudo pacman -S jq
   ```

## Installation

This skill is already installed in your `.claude/skills/` directory. Claude Code will automatically discover and use it when appropriate.

To verify installation:
```bash
ls -la skills/github-pr-review/
```

## Usage

### Automatic Activation

Claude will automatically activate this skill when you:
- Mention "review PR comments"
- Provide a GitHub PR URL
- Ask to "resolve review feedback"
- Request help with code review

### Manual Invocation

You can also explicitly request PR review help:

```
Review the PR comments at https://github.com/owner/repo/pull/123
```

Or for a specific comment:

```
Address this PR comment: https://github.com/owner/repo/pull/123#discussion_r456789
```

## Workflows

### Workflow 1: Review All Unresolved Comments

When you provide a basic PR URL, Claude will:
1. List all unresolved comment threads
2. Create a todo list for tracking progress
3. For each thread:
   - Analyze the full conversation
   - Read the relevant code
   - Make necessary fixes
   - Commit and push changes
   - Reply to the thread
   - Wait for your approval before continuing

### Workflow 2: Review Single Comment

When you provide a PR comment URL, Claude will:
1. Load the specific comment thread
2. Analyze the feedback
3. Read the relevant code
4. Make necessary fixes
5. Commit and push changes
6. Reply to the thread

## Scripts

All scripts are located in `scripts/`:

- **list-comment-ids.sh** - Get all unresolved PR comment threads
- **get-comment-thread.sh** - Get full thread data by ID
- **get-single-comment.sh** - Get single comment by URL
- **reply-to-comment.sh** - Post a reply to a thread
- **common.sh** - Shared utility functions

### Testing Scripts Manually

You can test the scripts directly:

```bash
# List unresolved comments
bash skills/github-pr-review/scripts/list-comment-ids.sh \
  "https://github.com/owner/repo/pull/123"

# Get specific thread
bash skills/github-pr-review/scripts/get-comment-thread.sh \
  "PRRT_kwDOPsBd3c5bpKKt"

# Get single comment
bash skills/github-pr-review/scripts/get-single-comment.sh \
  "https://github.com/owner/repo/pull/123#discussion_r456789"

# Reply to thread
bash skills/github-pr-review/scripts/reply-to-comment.sh \
  "PRRT_kwDOPsBd3c5bpKKt" \
  "Fixed in commit abc123. Description of fix."
```

## Documentation

- **SKILL.md** - Main skill instructions for Claude
- **reference.md** - Detailed patterns, templates, and best practices
- **examples.md** - Real-world examples with before/after code
- **README.md** - This file

## File Structure

```
skills/github-pr-review/
├── SKILL.md                    # Main skill definition
├── README.md                   # This file
├── reference.md                # Detailed reference guide
├── examples.md                 # Real-world examples
└── scripts/
    ├── common.sh               # Shared utilities
    ├── list-comment-ids.sh     # List threads script
    ├── get-comment-thread.sh   # Get thread details script
    ├── get-single-comment.sh   # Get single comment script
    ├── reply-to-comment.sh     # Reply to thread script
    └── queries/
        ├── list_comment_ids.graphql
        ├── get_comment_thread.graphql
        ├── find_thread_by_comment.graphql
        └── get_all_threads.graphql
```

## Troubleshooting

### "gh: command not found"

Install the GitHub CLI:
```bash
# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh

# See: https://github.com/cli/cli#installation
```

### "authentication required"

Authenticate with GitHub:
```bash
gh auth login
```

### "jq: command not found"

Install jq:
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

### Scripts return empty results

- Verify the PR URL is correct
- Check that the PR has unresolved comments
- Ensure you have read access to the repository

### Permission denied on scripts

Make scripts executable:
```bash
chmod +x skills/github-pr-review/scripts/*.sh
```

## Migration from MCP Server

This skill replaces the previous `gh-pr-review-mcp` MCP server approach with standalone scripts. Benefits:

- ✅ No MCP server configuration needed
- ✅ Self-contained in skill directory
- ✅ Easier to test and debug
- ✅ Simpler to share and version control
- ✅ No additional dependencies beyond `gh` and `jq`

### Removing Old Command

If you have the old command symlink, you can remove it:

```bash
# Remove old command symlink
rm commands/gh-pr-review-mcp

# The original MCP server can remain in /home/collin/dev/home/gh-pr-review-mcp
# as a reference or for other use cases
```

## Contributing

To improve this skill:

1. Edit scripts in `skills/github-pr-review/scripts/`
2. Update SKILL.md for instruction changes
3. Add examples to examples.md
4. Document patterns in reference.md
5. Test thoroughly before committing

## License

This skill is part of your personal dotfiles and inherits your repository's license.

## Related

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub GraphQL API](https://docs.github.com/en/graphql)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills.md)
