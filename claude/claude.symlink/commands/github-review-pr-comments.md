<!---
Extracted and augmented from:
https://nakamasato.medium.com/resolve-github-pr-reviews-consistently-and-rapidly-with-custom-claude-code-slash-command-3cdb25e1c2cf
-->

# Review and Resolve GitHub PR Comments

---

description: Review and Resolve GitHub PR Comments
argument-hint: <PR URL>

---

This guide explains how to systematically review and resolve comments that have been made on a GitHub Pull Request.

It is normal for this command to be invoked multiple times during the review process. You do NOT need to mention that
the command was invoked again, just start with the steps.

## Steps

1. **Extract GitHub owner, repository, and pull request number**

   Extract the owner, repository, and PR number from $ARGUMENTS if it was not directly specified.
   - These can be found in the PR URL: `https://github.com/{owner}/{repo}/pull/{pr_number}`

2. **Load all UNRESOLVED PR comment threads**

   Load each comment thread and create a todo/task list from them. Filter for unresolved threads only. Do not skip any
   unresolved threads, you must include all of them.

   ```bash
   gh api graphql -f owner="{owner}" -f repo="{repo}" -F pr="{pr_number}" -f query='
    query FetchReviewComments($owner: String!, $repo: String!, $pr: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $pr) {
          url
          reviewDecision
          reviewThreads(first: 100) {
            edges {
              node {
                isResolved
                isCollapsed
                comments(first: 100) {
                  totalCount
                  nodes {
                    id
                    databaseId
                    author {
                      login
                    }
                    body
                    url
                    createdAt
                    path
                    line
                    originalLine
                    diffHunk
                  }
                }
              }
            }
          }
        }
      }
    }
   ' | jq '.data.repository.pullRequest.reviewThreads.edges[] | select(.node.isResolved == false) | .node'
   ```

   **Important**: Each JSON node from the jq processing is one unresolved comment thread. Process all comment threads. Note that each thread can contain multiple comments that form a conversation - you need to analyze the entire thread for context.

3. **Loop and for each unresolved thread**

Post a total count of threads returned from above.
Complete all of these steps for each thread BEFORE moving onto the next thread

1. **Analyze the entire thread conversation**

   For each unresolved thread from step 2, process ALL comments in chronological order to understand the full context:
   - Sort comments by `createdAt` timestamp
   - Identify the original reviewer concern (typically the first comment)
   - Track the conversation flow between reviewer and author
   - Determine the current actionable feedback (may not be the last comment)

   You can use the `databaseId` field for additional REST API calls if needed:

   ```bash
   # Use the databaseId from the GraphQL response for REST API calls
   gh api repos/{owner}/{repo}/pulls/comments/{databaseId}
   ```

2. **Present the thread summary to the user**

   Post a summary of the entire thread conversation including:
   - **Original concern**: What the reviewer initially flagged
   - **Conversation summary**: Key points from the discussion
   - **Current status**: What action is needed based on the latest non-bot feedback
   - **Thread link**: Link to the full conversation for reference

3. **Read and check the relevant codes**
   - Based on the thread analysis, identify the specific code location (`path`, `line`, `diffHunk`)
   - Read the current state of the code in question
   - Consider the entire conversation context when evaluating the feedback
   - Think deeply whether to follow the suggestion based on the full discussion

4. If you feel the suggestion is good and a fix is necessary then:
   1. **Fix the issue**
      - Make the necessary code changes based on the review feedback
      - Ensure the fix addresses the reviewer's concerns

   2. **Commit and push**
      - Stage your changes
      - Create a descriptive commit message
      - Push to the feature branch

5. **Reply to the thread**

   Reply to the most appropriate comment in the thread (usually the original review comment).
   Use the `databaseId` from the GraphQL response and include your signature. Always include the commit has of the fix
   if available.

   ```bash
   gh api -X POST repos/{owner}/{repo}/pulls/{pr_number}/comments/{original_comment_databaseId}/replies \
       -f body="Fixed in commit {commit_sha}. {description_of_fix}

Addressed the original concern about {original_issue} and the follow-up discussion regarding {discussion_points}.

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

   If fixed, include commit link and context from the thread discussion:

   Example:

   ```bash
   gh api -X POST repos/nakamasato/github-actions-practice/pulls/2239/comments/2196280386/replies \
       -f body="Fixed in commit 2b36629. The redundant existence check has been removed since main() already validates the metadata file.

This addresses the original performance concern and the follow-up discussion about validation order.

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

   Otherwise if not fixed, explain your reasoning considering the full thread context.

6. Push the changes so the user can visually see in the GitHub UI right away

7. Complete the todo/task for this comment and move on to the next one

## Notes

- The repository owner, repository, and PR number can be found in the PR URL: `https://github.com/{owner}/{repo}/pull/{pr_number}
- Thread IDs are different from comment IDs and must be retrieved via GraphQL
- Only users with write access can resolve review threads
- The thread will be automatically marked as resolved when using the GraphQL mutation
