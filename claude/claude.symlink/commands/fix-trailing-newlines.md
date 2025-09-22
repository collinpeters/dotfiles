# Find and fix any missing posix-compliant trailing newlines

---

description: Properly find and fix any missing POSIX compliant trailing newlines

---


## Steps

1. Run this bash script which will find and fix all missing posix-compliant trailing newlines.

   ```
   find . -type f -exec sh -c 'for f; do if file -bi -- "$f" | grep -q "^text/"; then if [ -s "$f" ]; then last=$(tail
   -c1 "$f" 2>/dev/null | od -An -t u1 | tr -dc "0-9"); if [ "${last:-0}" -ne 10 ]; then echo "fixing: $f"; printf "\n"
   >> "$f"; else echo "ok:     $f"; fi; else echo "empty:  $f"; fi; fi; done' _ {} +

   ```

   For each file that is found it will print the file name with path, plus:
   - 'ok' if the file already has a trailing newline and was not modified
   - 'fixing' if the file was fixed and had a newline added

2. Ask the user if they want to commit and push the fixed files

3. If yes, use `git add` to stage all the files that were fixed. Then `git commit` with an appropriate message. Then
   `git push`.
