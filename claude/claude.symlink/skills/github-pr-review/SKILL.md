---
name: github-pr-review
description: "GitHub pull request review and resolution skill. Systematically reviews PR comments, analyzes code, applies fixes, commits changes, and replies to review threads. Use when reviewing PR comments, resolving PR feedback, addressing code review suggestions, or when user provides PR URLs."
allowed-tools: Read, Grep, Glob, Bash
---

# GitHub PR Review

## Overview

This skill helps systematically review and resolve GitHub pull request comments. It supports two workflows:

1. **Review All Unresolved Comments**: Process all unresolved PR comment threads systematically
2. **Review Single Comment**: Address a specific PR comment by URL

The skill handles the complete review cycle: analyzing feedback, reading code, applying fixes, committing changes, and replying to reviewers.

**IMPORTANT**: After processing each comment/thread, you MUST pause and wait for explicit user approval before continuing to the next thread. Never process multiple threads without user confirmation between each one.

## When to Use This Skill

Activate this skill when:
- User asks to review PR comments or code review feedback
- User provides a GitHub PR URL (with or without comment IDs)
- User mentions "resolve PR comments", "address review feedback", or similar
- User wants to systematically work through PR review threads
- User provides a PR comment URL (e.g., `#discussion_r123456`)

## Prerequisites

- GitHub CLI (`gh`) must be installed and authenticated
- `jq` must be installed for JSON processing
- Current directory must be a git repository
- User must have write access to the repository

## Workflow Selection

### If user provides a basic PR URL (no comment ID):
**Use Workflow 1: Review All Unresolved Comments**

Example: `https://github.com/owner/repo/pull/123`

### If user provides a PR comment URL (with comment ID):
**Use Workflow 2: Review Single Comment**

Example formats:
- `https://github.com/owner/repo/pull/123#discussion_r456789`
- `https://github.com/owner/repo/pull/123/files#r456789`
- `https://github.com/owner/repo/pull/123/changes#r456789`

---

## Workflow 1: Review All Unresolved Comments

This workflow systematically processes all unresolved comment threads on a PR.

### Step 1: Extract PR Information

Extract the owner, repository, and PR number from the user's input.
- Format: `https://github.com/{owner}/{repo}/pull/{pr_number}`

### Step 2: Load All Unresolved PR Comment Thread IDs

Execute the list-comment-ids script:

```bash
bash skills/github-pr-review/scripts/list-comment-ids.sh "https://github.com/{owner}/{repo}/pull/{pr_number}"
```

This returns a JSON array of thread objects:
```json
[
  {
    "id": "PRRT_kwDOPsBd3c5bpKKt",
    "author": "copilot-pull-request-reviewer",
    "url": "https://github.com/owner/repo/pull/123#discussion_r2374635451",
    "preview": "The test branch 'fix-rust-cach..."
  }
]
```

Create a todo/task list with one task per thread ID returned. **Do not skip any thread IDs** - include all of them in the task list.

Format each todo task title to include the thread ID, author, and comment preview:
```
Review and resolve thread {thread_id} from {author}: "{preview}"
```

Post a total count of threads:
```
Total PR comment threads to review: X
```

### Step 3: Process Each Thread

For each thread ID from Step 2, create and complete a task in your todo list. **Process each thread completely before moving to the next one.**

**⚠️ CRITICAL REMINDER**: After completing each thread (step 3.8), you MUST STOP and wait for user approval before starting the next thread. Do not process multiple threads in one response.

#### 3.1 Mark Thread Task as In Progress and Load Thread Details

Execute the get-comment-thread script:

```bash
bash skills/github-pr-review/scripts/get-comment-thread.sh "THREAD_ID_FROM_STEP_2"
```

This returns the complete thread data including all comments and metadata.

#### 3.2 Analyze the Entire Thread Conversation

Process **ALL** comments in the thread response in chronological order:
- Sort comments by `createdAt` timestamp
- Identify the original reviewer concern (typically the first comment)
- Track the conversation flow between reviewer and author
- Determine the current actionable feedback (may not be the last comment)

#### 3.3 Present the Thread Summary to the User

Post a summary of the entire thread conversation including:
- **Original concern**: What the reviewer initially flagged
- **Conversation summary**: Key points from the discussion
- **Current status**: What action is needed based on the latest non-bot feedback
- **Thread link**: Link to the full conversation for reference

#### 3.4 Read and Check the Relevant Code

Based on the thread analysis:
- Identify the specific code location (`path`, `line`, `diffHunk`)
- Read the current state of the code in question
- Consider the entire conversation context when evaluating the feedback
- Think deeply whether to follow the suggestion based on the full discussion

#### 3.5 If the Suggestion is Good and a Fix is Necessary

1. **Fix the Issue**
   - Make the necessary code changes based on the review feedback
   - Ensure the fix addresses the reviewer's concerns

2. **Commit and Push**
   - Stage your changes
   - Create a descriptive commit message
   - Push to the feature branch

#### 3.6 Reply to the Thread

Execute the reply-to-comment script:

```bash
bash skills/github-pr-review/scripts/reply-to-comment.sh "THREAD_ID_FROM_GET_COMMENT_THREAD" "YOUR_REPLY_MESSAGE"
```

**If fixed, use this reply format:**
```
Fixed in commit {commit_sha}. {description_of_fix}

Addressed the original concern about {original_issue} and the follow-up discussion regarding {discussion_points}.

🤖 Generated with Claude Code
```

**ALWAYS** include the commit hash of the fix that was pushed. Do not produce a reply without a git commit hash.

**Example:**
```
Fixed in commit 2b36629. The redundant existence check has been removed since main() already validates the metadata file.

This addresses the original performance concern and the follow-up discussion about validation order.

🤖 Generated with Claude Code
```

**If not fixed**, explain your reasoning considering the full thread context.

#### 3.7 Push the Changes

Push changes so the user can visually see them in the GitHub UI right away.

#### 3.8 **CRITICAL: Pause for User Verification**

**STOP HERE. Do not proceed to the next thread automatically.**

After completing work on this thread, you MUST:

1. **Summarize what was done**:
   - Changes made
   - Commit hash
   - Reply posted
   - Link to the comment thread

2. **Explicitly ask the user for approval** using clear language like:
   - "I've completed work on this thread. Please verify the changes and reply were appropriate before I move to the next thread."
   - "Ready to move to the next comment? Please confirm."
   - "Please review this work before I continue."

3. **Wait for explicit user response** - Do not continue until the user responds with approval (e.g., "yes", "continue", "looks good", etc.)

**Never** process multiple threads in a single response. Always pause after each one.

#### 3.9 Complete the Todo/Task and Continue

Only after receiving user approval:
1. Mark the task as completed for this comment thread
2. Move on to the next thread (returning to step 3.1)

---

## Workflow 2: Review Single Comment

This workflow addresses a specific PR comment identified by URL.

### Step 1: Extract PR Comment Information

Extract the owner, repository, PR number, and comment ID from the user's input.

Supported URL formats:
- `https://github.com/{owner}/{repo}/pull/{pr_number}#discussion_r{comment_id}`
- `https://github.com/{owner}/{repo}/pull/{pr_number}/files#r{comment_id}`
- `https://github.com/{owner}/{repo}/pull/{pr_number}/changes#r{comment_id}`

### Step 2: Load the Specific PR Comment

Execute the get-single-comment script:

```bash
bash skills/github-pr-review/scripts/get-single-comment.sh "https://github.com/{owner}/{repo}/pull/{pr_number}#discussion_r{comment_id}"
```

This returns the complete comment thread data for the specific comment.

### Step 3: Process the Comment

#### 3.1 Analyze the Comment Data

Process the comment response to understand the feedback:
- Identify the reviewer concern from the comment body
- Note the file path, line number, and diff context
- Understand what action is needed based on the feedback

#### 3.2 Present the Comment Summary to the User

Post a summary of the comment including:
- **Comment author**: Who made the comment
- **File and location**: Path and line number being commented on
- **Concern**: What the reviewer flagged
- **Comment body**: The full feedback text
- **Comment link**: Direct URL to the comment for reference

#### 3.3 Read and Check the Relevant Code

Based on the comment analysis:
- Identify the specific code location (path, line, diff context)
- Read the current state of the code in question
- Consider the comment feedback when evaluating the suggestion
- Think deeply whether to follow the suggestion based on the reviewer's concern

#### 3.4 If the Suggestion is Good and a Fix is Necessary

1. **Fix the Issue**
   - Make the necessary code changes based on the review feedback
   - Ensure the fix addresses the reviewer's concerns

2. **Commit and Push**
   - Stage your changes
   - Create a descriptive commit message
   - Push to the feature branch

#### 3.5 Reply to the Comment

Execute the reply-to-comment script using the thread ID from the comment data:

```bash
bash skills/github-pr-review/scripts/reply-to-comment.sh "THREAD_ID_FROM_GET_SINGLE_COMMENT_RESPONSE" "YOUR_REPLY_MESSAGE"
```

**ALWAYS** include the commit hash of the fix if a fix was made.

**If fixed, use this reply format:**
```
Fixed in commit {commit_sha}. {description_of_fix}

Addressed the concern about {original_issue}.

🤖 Generated with Claude Code
```

**Example:**
```
Fixed in commit 2b36629. The redundant existence check has been removed since main() already validates the metadata file.

This addresses the performance concern about duplicate validation.

🤖 Generated with Claude Code
```

#### 3.6 Push the Changes

Push changes so the user can visually see them in the GitHub UI right away.

#### 3.7 **Pause for User Verification**

After completing work on this comment, you MUST:

1. **Provide a summary of what was done**:
   - Changes made to the code
   - Commit hash if applicable
   - Reply that was posted
   - Link to the comment thread

2. **Explicitly ask the user to verify** the work using clear language like:
   - "I've addressed this PR comment. Please verify the changes and reply are appropriate."
   - "Please review the fix and reply before we consider this complete."

3. **Wait for user confirmation** before marking this task as complete

Even for single comments, always pause for user verification before considering the work finished.

---

## Common Patterns

### Analyzing Thread Context

When analyzing comment threads:
1. Read ALL comments in chronological order, not just the latest
2. Identify the root concern vs. follow-up clarifications
3. Check if the concern was already addressed in subsequent commits
4. Consider whether the suggestion aligns with project patterns

### Making Fixes

When implementing fixes:
1. **Always read the code first** - Never propose changes to code you haven't read
2. Read surrounding context, not just the specific line
3. Ensure the fix doesn't introduce new issues
4. Follow existing code patterns and style
5. Test mentally or actually run tests if available

### Committing Changes

Follow these git practices:
1. Stage only the files you modified for this specific fix
2. Write clear, descriptive commit messages
3. Reference the PR comment concern in the commit message
4. Push immediately after committing
5. Never commit directly to main/master branch

### Replying to Comments

Reply guidelines:
1. **Always include the commit hash** if you made changes
2. Be concise but complete in explaining the fix
3. Reference the original concern to show you understood it
4. Use the emoji and signature: `🤖 Generated with Claude Code`
5. If not fixing, provide clear reasoning

---

## Best Practices

1. **ALWAYS PAUSE FOR USER VERIFICATION**: After completing each comment/thread, STOP and explicitly ask the user to verify your work before continuing. Never process multiple threads without user approval between each one.
2. **Read Before Acting**: Always read the current code before suggesting or making changes
3. **Context Matters**: Consider the full thread conversation, not just the latest comment
4. **One Thread at a Time**: Complete each thread fully before moving to the next - do not batch process
5. **Commit Hash Required**: Never reply to a comment about a fix without including the commit hash
6. **Push Early**: Push changes immediately so they're visible in the GitHub UI
7. **Think Critically**: Not all suggestions need to be implemented - use judgment
8. **Respect Patterns**: Follow existing code patterns and project conventions
9. **Clear Communication**: When pausing, provide a clear summary and ask explicit questions

---

## Troubleshooting

### Scripts Not Found
If scripts cannot be found, ensure you're using the full path:
```bash
bash skills/github-pr-review/scripts/SCRIPT_NAME.sh
```

### GitHub Authentication
If `gh` commands fail, check authentication:
```bash
gh auth status
```

### Invalid PR URLs
Ensure URLs match one of these formats:
- Basic PR: `https://github.com/owner/repo/pull/123`
- Comment: `https://github.com/owner/repo/pull/123#discussion_r456789`
- Files view: `https://github.com/owner/repo/pull/123/files#r456789`
- Changes view: `https://github.com/owner/repo/pull/123/changes#r456789`

### No Unresolved Comments
If no threads are returned, all comments may already be resolved. Verify on GitHub.

---

## Script Reference

All scripts are located in `skills/github-pr-review/scripts/`:

- **list-comment-ids.sh**: Get all unresolved PR comment thread IDs
- **get-comment-thread.sh**: Get full thread data by thread ID
- **get-single-comment.sh**: Get single comment thread by comment URL
- **reply-to-comment.sh**: Post a reply to a comment thread

For detailed patterns, examples, and advanced usage, see `reference.md` and `examples.md`.
