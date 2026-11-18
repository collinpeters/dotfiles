#!/bin/sh
# Linux counterpart of the macOS Markdown Router: a hidden .desktop entry that hands .md files to
# ../open.sh, made the default for Markdown. Needs xdotool (X11) to tell whether Herdr is in front.
#   linux.sh --make-default   make it the default, remembering your usual app
#   linux.sh --restore        give Markdown back to your usual app
set -e
here=$(cd "$(dirname "$0")/.." && pwd)
name=herdr-markdown-router.desktop
apps="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
fallback="$HOME/.config/herdr-app/data/markdown-viewer/fallback"
types="text/markdown text/x-markdown"

current() {
  # GIO's answer is what file managers and the desktop portal use; xdg-mime can disagree with it.
  if command -v gio >/dev/null; then
    LC_ALL=C gio mime text/markdown 2>/dev/null | sed -n 's/^Default application for .*: //p'
  else
    xdg-mime query default text/markdown
  fi
}

case "$1" in
  --make-default)
    mkdir -p "$apps" "$(dirname "$fallback")"
    # No quotes in Exec: xdg-open's generic launcher (i3, sway, …) splits it on spaces and keeps them.
    cat > "$apps/$name" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Markdown Router (Herdr)
Exec=/bin/sh $here/open.sh %f
MimeType=text/markdown;text/x-markdown;
NoDisplay=true
DESKTOP
    was=$(current)
    if [ -n "$was" ] && [ "$was" != "$name" ]; then printf '%s\n' "$was" > "$fallback"; fi
    update-desktop-database "$apps" 2>/dev/null || true
    xdg-mime default "$name" $types
    echo "default for Markdown: $name (before: $(cat "$fallback" 2>/dev/null || echo none))"
    ;;
  --restore)
    was=$(cat "$fallback" 2>/dev/null) || { echo "no saved app"; exit 1; }
    xdg-mime default "$was" $types
    rm -f "$apps/$name"
    update-desktop-database "$apps" 2>/dev/null || true
    echo "default for Markdown: $was"
    ;;
  *) echo "usage: $0 --make-default | --restore"; exit 2 ;;
esac
