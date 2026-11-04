// ctrl-a ctrl-f: fuzzy-pick a project or worktree folder, then show its space,
// creating it if needed (port of the old herdr tmux-style sessionizer).
// Folders: DEFAULTS below, or per machine from config.local.json beside this
// file (git-ignored). Either key replaces its default list:
//   { "projects":  [{ "dir": "~/src", "depth": 2 }],
//     "worktrees": [{ "dir": "~/src/worktrees", "depth": 3 }] }
// projects: every folder 1..depth levels under dir. worktrees: every folder
// up to depth levels under dir whose .git is a file (a linked worktree).
import * as fs from "fs/promises";
import { appHome, exec, home, spaces, run } from "herdr";
import { FuzzyPick } from "./pick.js";

const DEFAULTS = {
  projects: [{ dir: "~/code", depth: 2 }],
  worktrees: [{ dir: "~/code/worktrees", depth: 3 }],
};

// Space name for a folder: its last part, dots made underscores (tmux-sessionizer's rule).
const nameOf = (dir) => dir.split("/").pop().replaceAll(".", "_");
const lines = (r) => (r?.stdout ?? "").split("\n").filter(Boolean);
const expand = (dir) => (dir === "~" || dir.startsWith("~/") ? home() + dir.slice(1) : dir);

// DEFAULTS merged with config.local.json; a missing file means defaults.
async function loadConfig() {
  let text;
  try {
    text = await fs.readFile(`${appHome()}/mods/sessionizer/config.local.json`, "utf8");
  } catch {
    return { config: DEFAULTS, error: null };
  }
  let local;
  try {
    local = JSON.parse(text);
  } catch (e) {
    return { config: DEFAULTS, error: `Bad config.local.json: ${e.message}` };
  }
  const config = { ...DEFAULTS, ...local };
  const valid = (list) => Array.isArray(list) && list.every((e) => typeof e?.dir === "string" && Number.isInteger(e?.depth));
  if (!valid(config.projects) || !valid(config.worktrees)) {
    return { config: DEFAULTS, error: "Bad config.local.json: projects/worktrees must be [{ dir, depth }]" };
  }
  return { config, error: null };
}

export default class Sessionizer extends FuzzyPick {
  init(_props, cx) {
    this.setup(cx, { title: "Open project", placeholder: "Find a project or worktree…" });
    this.dirs = [];
    this.message = "Loading…";
    cx.spawn(async (cx) => {
      const { config, error } = await loadConfig();
      const listProjects = ({ dir, depth }) =>
        exec("find", [expand(dir), "-mindepth", "1", "-maxdepth", String(depth), "-type", "d"]).catch(() => null);
      const listWorktrees = ({ dir, depth }) =>
        exec("find", [expand(dir), "-maxdepth", String(depth), "-name", ".git", "-type", "f", "-printf", "%h\n"]).catch(() => null);
      const [projects, worktrees] = await Promise.all([
        Promise.all(config.projects.map(listProjects)),
        Promise.all(config.worktrees.map(listWorktrees)),
      ]);
      this.dirs = [...new Set([...projects, ...worktrees].flatMap(lines))].sort();
      // exec resolves even when find fails (missing folder: code 1, no output).
      const failed = config.projects.filter((_, i) => !projects[i] || (projects[i].code !== 0 && !projects[i].stdout)).map((p) => p.dir);
      this.message = error ?? (failed.length ? `Couldn't list ${failed.join(", ")}` : null);
      cx.notify();
    });
  }

  candidates() {
    const h = home();
    const open = new Set(spaces().filter((s) => s.machine == null).map((s) => s.name));
    return this.dirs.map((dir) => ({
      key: dir,
      dir,
      label: dir.startsWith(h) ? `~${dir.slice(h.length)}` : dir,
      base: dir.split("/").pop(),
      tag: open.has(nameOf(dir)) ? "open" : null,
    }));
  }

  choose(r) {
    this.close();
    const name = nameOf(r.dir);
    const space = spaces().find((s) => s.machine == null && s.name === name);
    if (space) run("space.select", { id: space.id });
    else run("space.new", { name, folder: r.dir, machine: "" });
  }
}
