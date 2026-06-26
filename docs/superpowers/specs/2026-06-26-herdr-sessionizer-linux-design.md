# Port tmux session keybinds to herdr (Route A: un-gate sessionizer on Linux)

**Date:** 2026-06-26
**Status:** Approved
**Repos touched:** `~/dev/home/dotfiles` (config) and a new clone `~/dev/home/herdr-sessionizer` (plugin fork)

## Goal

Replace the "multiple shell windows, each running tmux in a worktree" workflow with
[herdr](https://herdr.dev/), preserving two tmux keybinds:

| tmux keybind | Behavior | herdr equivalent |
|---|---|---|
| `prefix+C-f` → `bin/tmux-sessionizer` | fzf over `~/dev` projects + `~/dev/worktrees`, then create-or-resume a session in that dir | sessionizer plugin actions `sessionizer.open` + `sessionizer.worktree-open` |
| `prefix+C-j` → fzf over `tmux list-sessions` + `switch-client` | switch between existing sessions | herdr built-in `workspace_picker` (no plugin) |

`prefix` is already `ctrl+a` in `herdr/xdg_config/config.toml`, matching tmux.

## Background / findings

- The `sessionizer` plugin (andrewchng/herdr-sessionizer, inspired by ThePrimeagen's
  tmux-sessionizer) already implements create-or-resume: it lists existing herdr
  workspaces (resume) plus repos under `[projects].roots` (create).
- The plugin is gated `platforms = ["macos"]` in `herdr-plugin.toml`, and herdr's
  cached `plugins.json` mirrors that. README says "Linux planned; not validated yet."
- The plugin **code** is portable: it uses `node:fs`/`node:os`/`node:path` for scanning
  (`src/discovery.ts`) and drives herdr purely through the `herdr` CLI over the socket API
  (`src/client/herdr.ts`, `src/ops/*`). No macOS-specific syscalls; the only "macOS-ism"
  is a `brew install fzf` string in an error message.
- Tooling present on this Linux box: `bun`, `fzf`, `git`, `nvim`. `bat` is absent
  (optional; only enriches README previews).
- `[projects].roots` is a flat list, scanned **immediate-children only** — no depth or
  glob (`src/config.ts`, `src/discovery.ts::listProjects`). `~/dev` projects live at
  depth 2 (`~/dev/{work,home,playground,...}/<project>`), so roots must enumerate the
  depth-1 category dirs.
- The dedicated worktree picker delegates to `herdr worktree create` **without `--path`**
  (`src/worktree.ts:120`), so new worktrees land in herdr's `[worktrees].directory`
  (default `~/.herdr/worktrees`), not `~/dev/worktrees`, unless that setting is changed.
- `~/.config/herdr` is a symlink to `dotfiles/herdr/xdg_config`, so herdr runtime/managed
  files currently appear untracked in the dotfiles repo.

## Decisions

1. **Un-gate method:** clone the plugin to `~/dev/home/herdr-sessionizer`, patch the
   manifest, and `herdr plugin link` it (replacing the managed install). Chosen over
   in-place patching (cache/clobber risk, untracked) and fork+install (most upfront work
   before Linux is validated). Linking is herdr's documented dev path, forces a fresh
   manifest read, survives updates, and keeps the plugin PR-able upstream.
2. **Worktrees:** "Both" — fold existing worktrees into the main picker by adding
   `~/dev/worktrees` to `roots`, AND bind the dedicated worktree-create picker.
3. **New-workspace layout:** minimal global default (single `nvim` pane). Per-repo
   `<project>/.sessionizer/config.toml` overrides handle richer layouts.
4. **Worktree placement:** set herdr `[worktrees].directory = "~/dev/worktrees"` so the
   dedicated picker honors the existing convention.

## Changes

### A. Plugin clone + un-gate (`~/dev/home/herdr-sessionizer`)

```sh
git clone https://github.com/andrewchng/herdr-sessionizer ~/dev/home/herdr-sessionizer
# herdr-plugin.toml:  platforms = ["macos", "linux"]
cd ~/dev/home/herdr-sessionizer && bun install
herdr plugin uninstall sessionizer
herdr plugin link ~/dev/home/herdr-sessionizer
```

### B. Plugin config — `herdr/xdg_config/plugins/config/sessionizer/config.toml`

```toml
[projects]
roots = ["~/dev/work", "~/dev/home", "~/dev/playground", "~/dev/opt", "~/dev/worktrees"]

[layout]
placement = "overlay"
focus = "editor"

[tabs.dev]
label = "dev"

[[tabs.dev.panes]]
id = "editor"
title = "nvim"
command = "nvim"
```

Roots exclude `~/dev/{backup,chrome-overrides,pgadmin}` as non-projects (adjustable).

### C. herdr config — `herdr/xdg_config/config.toml`

Under `[keys]`:
```toml
workspace_picker = "prefix+ctrl+j"
```

Append:
```toml
[[keys.command]]
key = "prefix+ctrl+f"
type = "plugin_action"
command = "sessionizer.open"
description = "sessionizer: open/resume project"

[[keys.command]]
key = "prefix+ctrl+g"
type = "plugin_action"
command = "sessionizer.worktree-open"
description = "sessionizer: open/create worktree"

[worktrees]
directory = "~/dev/worktrees"
```

`prefix+ctrl+g` avoids herdr's built-in `new_worktree = "prefix+shift+g"`.

### D. Dotfiles hygiene — `herdr/xdg_config/.gitignore`

Ignore herdr runtime/managed state so only `config.toml` and
`plugins/config/sessionizer/config.toml` are tracked:
```
*.log
session.json
plugins.json
plugins/github/
```

## Verification (Linux smoke test — the genuine unknown)

1. `herdr plugin list` shows `sessionizer` enabled on Linux.
2. `herdr plugin action invoke sessionizer.open` → fzf lists workspaces + projects;
   picking a project creates and focuses a workspace running `nvim`.
3. Re-invoke, pick the same project → resumes (focuses existing) rather than duplicating.
4. `sessionizer.worktree-open` → base-repo pick → branch prompt → worktree workspace
   created under `~/dev/worktrees`.
5. In-app: `prefix+ctrl+f`, `prefix+ctrl+g`, `prefix+ctrl+j` all fire. Check
   `herdr plugin log list` for errors.
6. On failure (the "not validated on Linux" risk), debug, or fall back to Route B
   (native `[[keys.command]]` shell script wrapping `herdr workspace create/focus`).

## Risks / open verification

- `bun install` succeeding on Linux (expected: deps are pure-JS).
- `type = "plugin_action"` being a supported binding type in herdr 0.7.1 (per plugin
  README v0.2.0, which targets `min_herdr_version = 0.7.0`).
- Whether `workspace_picker` offers fuzzy + pane preview comparable to the tmux fzf
  switcher (cosmetic; confirm at step 5).
- New-machine bootstrap: the clone + `bun install` + `herdr plugin link` steps are
  machine-specific (recorded here; consider a `just` recipe later).

## Out of scope

- Keeping the tmux config; this adds herdr alongside it.
- Migrating other tmux keybinds (splits, pane navigation) — herdr has its own.
- Upstreaming Linux support as a PR (possible follow-up once validated).
