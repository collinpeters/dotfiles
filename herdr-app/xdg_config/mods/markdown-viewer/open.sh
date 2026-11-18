#!/bin/sh
# Opens a Markdown file for the Markdown Router, the default app for .md files: router/ on macOS,
# router/linux.sh on Linux.
# $1: the file; $2: the app that was in front (path or name). On Linux $2 is left out and the
# focused X11 window's program is used (needs xdotool).
# Herdr in front (a cmd/ctrl-click on a path in a terminal): the viewer already showing takes it, else
# a split on the right. Anywhere else (Finder, a file manager, …): the default before the router.
f="$1"; front="$2"
HERDR="$HOME/.local/bin/herdr-app"; DATA="$HOME/.config/herdr-app/data/markdown-viewer"
linux=; [ "$(uname)" = Linux ] && linux=1
elsewhere() {
  id=$(cat "$DATA/fallback" 2>/dev/null)
  [ -z "$linux" ] && exec open -b "${id:-com.apple.TextEdit}" "$f"
  [ -n "$id" ] && exec gtk-launch "$id" "$f"
  exit 1
}
if [ -n "$linux" ] && [ -z "$front" ]; then
  pid=$(xdotool getactivewindow getwindowpid 2>/dev/null)
  [ -n "$pid" ] && front=$(basename "$(readlink "/proc/$pid/exe")")
fi
case "$front" in *Herdr.app*|herdr-app) ;; *) elsewhere ;; esac
[ -x "$HERDR" ] || elsewhere
mkdir -p "$DATA"
esc=$(printf '%s' "$f" | sed 's/\\/\\\\/g; s/"/\\"/g')
id="$$-$(date +%s)"
printf '{"id":"%s","file":"%s"}\n' "$id" "$esc" > "$DATA/request.json"
# A viewer showing in this tab takes it and answers in $DATA/ack.
"$HERDR" do markdown-viewer.show >/dev/null 2>&1
i=0
while [ $i -lt 8 ]; do
  [ "$(cat "$DATA/ack" 2>/dev/null)" = "$id" ] && exit 0
  sleep 0.05; i=$((i+1))
done
"$HERDR" do pane.split --direction right --mod markdown-viewer --props "{\"file\":\"$esc\"}" | grep -q '"error"' && elsewhere
exit 0
