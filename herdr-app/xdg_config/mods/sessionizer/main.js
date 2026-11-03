// ctrl-a ctrl-f: fuzzy-pick a project or worktree folder, then show its space,
// creating it if needed (port of the old herdr tmux-style sessionizer).
// Folders: ~/dev one or two levels deep, plus worktrees under ~/dev/worktrees.
import { exec, home, spaces, run } from "herdr";
import { FuzzyPick } from "./pick.js";

// Space name for a folder: its last part, dots made underscores (tmux-sessionizer's rule).
const nameOf = (dir) => dir.split("/").pop().replaceAll(".", "_");
const lines = (r) => (r?.stdout ?? "").split("\n").filter(Boolean);

export default class Sessionizer extends FuzzyPick {
  init(_props, cx) {
    this.setup(cx, { title: "Open project", placeholder: "Find a project or worktree…" });
    this.dirs = [];
    this.message = "Loading…";
    cx.spawn(async (cx) => {
      const dev = `${home()}/dev`;
      const [projects, worktrees] = await Promise.all([
        exec("find", [dev, "-mindepth", "1", "-maxdepth", "2", "-type", "d"]).catch(() => null),
        exec("find", [`${dev}/worktrees`, "-maxdepth", "3", "-name", ".git", "-type", "f", "-printf", "%h\n"]).catch(() => null),
      ]);
      this.dirs = [...new Set([...lines(projects), ...lines(worktrees)])].sort();
      this.message = projects ? null : `Couldn't list ${dev}`;
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
