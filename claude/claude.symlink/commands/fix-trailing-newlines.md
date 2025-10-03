# Find and fix any missing posix-compliant trailing newlines

---
description: Properly find and fix any missing POSIX compliant trailing newlines
argument-hint: [type]
---

## Steps

1. Run the appropriate bash script based on the parameter `$1`:

   **If `$1` is 'all' (all git-tracked files):**
   ```
   git ls-files -z | xargs -0 perl -i -0777 -pe 's/\n*$/\n/'
   ```

   **If `$1` is 'changed' (files changed from main branch):**
   ```
   git diff --name-only main...HEAD -z | xargs -0 perl -i -0777 -pe 's/\n*$/\n/'
   ```

   For each file that is processed it will print the file name with path, plus:
   - 'ok' if the file already has a trailing newline and was not modified
   - 'fixing' if the file was fixed and had a newline added

2. Ask the user if they want to commit and push the fixed files

3. If yes, use `git add` to stage all the files that were fixed. Then `git commit` with an appropriate message. Then
   `git push`.
