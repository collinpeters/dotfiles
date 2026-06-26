# Herdr Sessionizer on Linux — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the two tmux session keybinds (`prefix+C-f` open/resume, `prefix+C-j` switch) to herdr by un-gating the macOS-only sessionizer plugin for Linux and wiring the keybinds.

**Architecture:** Clone the `andrewchng/herdr-sessionizer` plugin to `~/dev/home/herdr-sessionizer`, patch its manifest to allow Linux, and `herdr plugin link` it (replacing the managed install). Configure project roots + a minimal layout, then bind `sessionizer.open` / `sessionizer.worktree-open` and herdr's built-in `workspace_picker`. The dotfiles repo tracks only the config; the plugin lives as its own repo.

**Tech Stack:** herdr 0.7.1, Bun, fzf, TOML config. Plugin is TypeScript driving the `herdr` CLI over its socket API.

## Global Constraints

- Platform: **Linux** (the gate being lifted). herdr **>= 0.7.0** (installed: 0.7.1).
- Requires `bun` and `fzf` on PATH (both present); `bat` optional (absent — previews degrade gracefully).
- **Never commit to `master`/`main`.** Dotfiles work is on branch `herdr-sessionizer-linux`; the plugin clone gets its own branch `linux-support`.
- **Never `git add .`** — stage each file by name.
- `~/.config/herdr` is a symlink to `dotfiles/herdr/xdg_config`; edit files under the dotfiles path.
- herdr server must be running for `herdr plugin`/`workspace`/`server reload-config` calls (it is — there is a live session).
- Interactive fzf pickers and in-app keybinds can only be verified by the **user** inside their herdr session; the agent verifies everything non-interactive (plugin list, plugin tests, logs, config reload).

---

### Task 1: Clone and un-gate the plugin; verify it loads on Linux

**Files:**
- Create (external repo): `~/dev/home/herdr-sessionizer/` (git clone)
- Modify: `~/dev/home/herdr-sessionizer/herdr-plugin.toml:6`

**Interfaces:**
- Produces: a linked, enabled herdr plugin `sessionizer` exposing actions `sessionizer.open` and `sessionizer.worktree-open` (consumed by Task 3 keybinds) and reading config from `~/.config/herdr/plugins/config/sessionizer/config.toml` (written in Task 2).

- [ ] **Step 1: Clone the plugin repo**

```bash
git clone https://github.com/andrewchng/herdr-sessionizer ~/dev/home/herdr-sessionizer
```
Expected: clone succeeds; `~/dev/home/herdr-sessionizer/herdr-plugin.toml` exists.

- [ ] **Step 2: Confirm the current macOS gate**

```bash
grep -n '^platforms' ~/dev/home/herdr-sessionizer/herdr-plugin.toml
```
Expected: `6:platforms = ["macos"]`

- [ ] **Step 3: Create a branch in the clone for the Linux patch**

```bash
git -C ~/dev/home/herdr-sessionizer checkout -b linux-support
```
Expected: `Switched to a new branch 'linux-support'`

- [ ] **Step 4: Patch the manifest to allow Linux**

Edit `~/dev/home/herdr-sessionizer/herdr-plugin.toml` line 6:
```toml
platforms = ["macos", "linux"]
```

- [ ] **Step 5: Install plugin dependencies under Linux Bun**

```bash
cd ~/dev/home/herdr-sessionizer && bun install
```
Expected: install completes without error (deps are pure-JS: `smol-toml`, etc.).

- [ ] **Step 6: Run the plugin's own test suite + typecheck on Linux**

```bash
cd ~/dev/home/herdr-sessionizer && bun run typecheck && bun run test
```
Expected: typecheck clean; tests PASS. (This is the first real signal the code runs under Linux Bun. If a test fails for a genuinely platform-specific reason, capture it — it informs whether Route A holds or we fall back to Route B.)

- [ ] **Step 7: Commit the manifest patch in the clone**

```bash
git -C ~/dev/home/herdr-sessionizer add herdr-plugin.toml
git -C ~/dev/home/herdr-sessionizer commit -m "Allow linux platform"
```

- [ ] **Step 8: Remove the macOS-gated managed install**

```bash
herdr plugin uninstall sessionizer
```
Expected: uninstall confirmation; the managed dir `~/.config/herdr/plugins/github/sessionizer-*` is removed.

- [ ] **Step 9: Link the patched clone**

```bash
herdr plugin link ~/dev/home/herdr-sessionizer
```
Expected: link confirmation.

- [ ] **Step 10: Verify the plugin is enabled on Linux**

```bash
herdr plugin list
herdr plugin list --plugin sessionizer --json
```
Expected: `sessionizer` listed and enabled; JSON shows the linked `plugin_root` at `~/dev/home/herdr-sessionizer` and `linux` among platforms. If it is filtered out as unsupported, stop — the gate did not take.

- [ ] **Step 11: Confirm no load errors**

```bash
herdr plugin log list --plugin sessionizer --limit 20
```
Expected: no fatal load/parse errors.

---

### Task 2: Configure the plugin (project roots + minimal layout)

**Files:**
- Create: `herdr/xdg_config/plugins/config/sessionizer/config.toml` (= `~/.config/herdr/plugins/config/sessionizer/config.toml` via symlink)

**Interfaces:**
- Consumes: the linked plugin from Task 1.
- Produces: `[projects].roots` used by both `sessionizer.open` and `sessionizer.worktree-open`; the `[tabs.dev]` layout applied to newly created workspaces.

- [ ] **Step 1: Write the plugin config**

Create `herdr/xdg_config/plugins/config/sessionizer/config.toml`:
```toml
[projects]
# Parent folders scanned by the pickers (immediate children only — no depth/glob).
# These are the depth-1 category dirs under ~/dev so actual projects show up,
# plus ~/dev/worktrees so existing worktrees fold into the main picker.
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

- [ ] **Step 2: Verify the config parses**

```bash
herdr plugin log list --plugin sessionizer --limit 5
herdr plugin action list
```
Expected: `action list` shows `sessionizer.open` and `sessionizer.worktree-open`; no config-parse errors logged. (A malformed config surfaces as a "Config must define …" error from `src/config.ts` when an action runs.)

- [ ] **Step 3 (USER-DRIVEN): Smoke-test the project picker in herdr**

In the herdr session, run the action (or wait for the Task 3 keybind):
```
herdr plugin action invoke sessionizer.open
```
Verify:
- fzf picker appears listing existing workspaces + projects under the roots.
- Picking a project creates a workspace, applies the `nvim` layout, and focuses it.
- Re-invoking and picking the **same** project *resumes* (focuses the existing workspace) rather than creating a duplicate.

Report back what happened; the agent will check `herdr plugin log list` afterward.

---

### Task 3: Wire herdr keybinds and worktree directory

**Files:**
- Modify: `herdr/xdg_config/config.toml` (`[keys]` block ~line 63; append new sections at EOF)

**Interfaces:**
- Consumes: plugin actions from Task 1; roots/layout from Task 2.
- Produces: keybinds `prefix+ctrl+f`, `prefix+ctrl+g`, and `workspace_picker = prefix+ctrl+j`; `[worktrees].directory` so new worktrees land in `~/dev/worktrees`.

- [ ] **Step 1: Bind `workspace_picker` in the `[keys]` block**

In `herdr/xdg_config/config.toml`, under `[keys]` (the block that already sets `prefix = "ctrl+a"`), add an active (uncommented) line:
```toml
workspace_picker = "prefix+ctrl+j"
```

- [ ] **Step 2: Append plugin-action binds and the worktree directory**

Append to the end of `herdr/xdg_config/config.toml`:
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

- [ ] **Step 3: Reload herdr config**

```bash
herdr server reload-config
```
Expected: success, no parse error. If `type = "plugin_action"` is rejected by herdr 0.7.1, the reload errors here — capture the message (it determines whether we adjust binding syntax).

- [ ] **Step 4: Confirm keybinds registered without error**

```bash
herdr plugin log list --limit 20
```
Expected: no keybinding parse/conflict errors.

- [ ] **Step 5 (USER-DRIVEN): Exercise the keybinds in herdr**

In the herdr session:
- `prefix+ctrl+f` → project picker (same as Task 2 Step 3).
- `prefix+ctrl+j` → workspace picker over existing workspaces (the `prefix+C-j` analog). Note whether it offers fuzzy/preview comparable to the tmux fzf switcher.
- `prefix+ctrl+g` → worktree flow: pick base repo → branch prompt → new worktree workspace created **under `~/dev/worktrees`**; confirm the path.

Report results.

---

### Task 4: Dotfiles hygiene and commit the config

**Files:**
- Create: `herdr/xdg_config/.gitignore`
- Commit: `herdr/xdg_config/config.toml`, `herdr/xdg_config/plugins/config/sessionizer/config.toml`, `herdr/xdg_config/.gitignore`

**Interfaces:**
- Consumes: all prior tasks.
- Produces: a clean dotfiles working tree tracking only herdr config (not runtime/managed state).

- [ ] **Step 1: Write the herdr `.gitignore`**

Create `herdr/xdg_config/.gitignore`:
```gitignore
# herdr runtime / machine-specific state
*.log
session.json
plugins.json

# herdr-managed plugin installs (we link the sessionizer clone from ~/dev instead)
plugins/github/
```

- [ ] **Step 2: Verify only intended files are untracked/modified**

```bash
cd ~/dev/home/dotfiles && git status --short herdr/
```
Expected: shows `herdr/xdg_config/.gitignore`, `herdr/xdg_config/config.toml`, and `herdr/xdg_config/plugins/config/sessionizer/config.toml` as additions/modifications; `*.log`, `session.json`, `plugins.json`, and `plugins/github/` do NOT appear.

- [ ] **Step 3: Stage the three config files by name**

```bash
cd ~/dev/home/dotfiles
git add herdr/xdg_config/.gitignore \
        herdr/xdg_config/config.toml \
        herdr/xdg_config/plugins/config/sessionizer/config.toml
```

- [ ] **Step 4: Commit**

```bash
git commit -m "$(cat <<'EOF'
Add herdr sessionizer config and session keybinds

Configure project roots + minimal nvim layout for the sessionizer plugin,
bind prefix+ctrl+f (open/resume), prefix+ctrl+g (worktree), and
workspace_picker=prefix+ctrl+j (switch), and point new worktrees at
~/dev/worktrees. Ignore herdr runtime/managed state.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
EOF
)"
```
Expected: commit succeeds on branch `herdr-sessionizer-linux`.

- [ ] **Step 5: Final verification summary**

```bash
herdr plugin list
cd ~/dev/home/dotfiles && git log --oneline -3 && git status --short herdr/
```
Expected: sessionizer enabled; spec + config commits present; herdr working tree clean of runtime noise.

---

## Self-Review

**Spec coverage:**
- §2 un-gate via linked clone → Task 1 ✓
- §3 plugin config (roots + minimal nvim layout) → Task 2 ✓
- §4 keybinds (`workspace_picker`, two `[[keys.command]]`) + `[worktrees].directory` → Task 3 ✓
- §5 dotfiles hygiene (`.gitignore`) → Task 4 ✓
- §6 verification (plugin list, picker resume, worktree path, in-app keys) → Task 2 Step 3, Task 3 Step 5, Task 4 Step 5 ✓
- Risks (bun install, plugin_action support, workspace_picker UX) → surfaced at Task 1 Step 6, Task 3 Step 3, Task 3 Step 5 ✓

**Placeholder scan:** No TBD/TODO; every config block and command is concrete.

**Type consistency:** Action ids `sessionizer.open` / `sessionizer.worktree-open`, config keys (`[projects].roots`, `[layout].focus="editor"`, `[tabs.dev.panes].id="editor"`), and paths are consistent across tasks and match the plugin source (`src/config.ts`, `herdr-plugin.toml`).

**Fallback:** If Task 1 Step 6 or Task 3 Step 3 reveal Linux/herdr incompatibility, stop and revisit Route B (native `[[keys.command]]` shell script wrapping `herdr workspace create/focus`) from the spec.
