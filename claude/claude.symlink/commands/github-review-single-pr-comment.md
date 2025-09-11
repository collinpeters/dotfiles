<!---
Extracted and augmented from:
https://nakamasato.medium.com/resolve-github-pr-reviews-consistently-and-rapidly-with-custom-claude-code-slash-command-3cdb25e1c2cf
-->

# Review and Resolve A Single GitHub PR Comment

---

description: Review and Resolve A Single GitHub PR Comment
argument-hint: <PR COMMENT URL>

---

This guide explains how to review and resolve a single comment that has been made on a GitHub Pull Request.

## Steps

1. **Extract GitHub owner, repository, and pull request number, and comment ID**,

   Extract the owner, repository, and PR number from $ARGUMENTS if it was not directly specified.
   - These can be found in the 'files' PR comment URL: `https://github.com/{owner}/{repo}/pull/{pr number}/files#r{comment ID}`
   - Or if it is a 'discussions' PR comment URL: `https://github.com/{owner}/{repo}/pull/{pr number}#discussion_r{comment ID}`

2. **Check the specific comment**

   ```bash
   gh api repos/{owner}/{repo}/pulls/comments/{comment_id}
   ```

   Example:

   ```bash
   gh api repos/nakamasato/github-actions-practice/pulls/comments/2196280386
   ```

3. Post the comment text and link back to the user so they can follow along

4. **Read and check the relevant codes**
   - Read the comment and suggestion.
   - Check the relevant codes.
   - Think deeply whether to follow the suggestion or not.

5. If you feel the suggestion is good and a fix is necessary then:
   1. **Fix the issue**
      - Make the necessary code changes based on the review feedback
      - Ensure the fix addresses the reviewer's concerns

   2. **Commit and push**
      - Stage your changes
      - Create a descriptive commit message
      - Push to the feature branch

6. **Reply to the comment**

   Use your signature in the reply as well, since it will be posted on behalf of the user.

   ```bash
   gh api -X POST repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies \
       -f body="Fixed in commit {commit_sha}. {description_of_fix}"
   ```

   If fixed, please reply with commit link:

   Example:

   ```bash
   gh api -X POST repos/nakamasato/github-actions-practice/pulls/2239/comments/2196280386/replies \
       -f body="Fixed in commit 2b36629. The redundant existence check has been removed since main() already validates the metadata file."
   ```

   Otherwise if not fixed, reply to the comment with your thoughts.

## Notes

- The repository owner, repository, and PR number can be found in the PR URL: `https://github.com/{owner}/{repo}/pull/{pr_number}
- Thread IDs are different from comment IDs and must be retrieved via GraphQL
- Only users with write access can resolve review threads
