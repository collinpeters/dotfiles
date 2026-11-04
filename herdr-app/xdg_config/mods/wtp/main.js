// ctrl-a ctrl-g: pick a branch of the focused pane's repo (or type a new name),
// then run scripts/herdr-wtp in a terminal dialog: `wtp add` with its .wtp.yml
// hooks (live output, no time limit; wtp gives hooks /dev/null as stdin, so they
// can't prompt), then the worktree's space.
// A remote space's repo is read on its machine (exec's `on`); the dialog terminal
// stays here and runs wtp there (herdr-wtp --on).
// This popup closes before the terminal dialog opens: closing it hands the
// keyboard back to whatever had it, which would otherwise take it from the dialog.
import { exec, hc, appHome, focused, spaces, notify, openOverlay } from "herdr";
import { FuzzyPick } from "./pick.js"; // same file as ../sessionizer/pick.js

const lines = (r) => (r?.stdout ?? "").split("\n").filter(Boolean);

export default class Wtp extends FuzzyPick {
  init(_props, cx) {
    this.setup(cx, { title: "Worktree", placeholder: "Branch to open, or a new branch name…" });
    this.branches = [];
    this.worktrees = new Set();
    this.repo = null;
    this.on = null; // the focused space's machine, null for this computer
    this.message = "Loading branches…";
    cx.spawn(async (cx) => {
      const f = focused();
      this.on = spaces().find((s) => s.id === f?.space)?.machine ?? null;
      const git = (args, cwd) => exec("git", args, { cwd, on: this.on });
      const top = f?.cwd ? await git(["rev-parse", "--show-toplevel"], f.cwd).catch((e) => ({ code: -1, stderr: String(e?.message ?? e) })) : null;
      if (top?.code !== 0) {
        const where = this.on ? ` on ${this.on}` : "";
        this.message = !f?.cwd ? "The focused pane has no folder." : top.code === -1 ? `${top.stderr}${where}` : `Not in a git repo: ${f.cwd}${where}`;
        return cx.notify();
      }
      this.repo = top.stdout.trim();
      this.title = `Worktree: ${this.repo.split("/").pop()}${this.on ? ` (${this.on})` : ""}`;
      const [refs, list] = await Promise.all([
        git(["for-each-ref", "--format=%(refname)", "refs/heads", "refs/remotes"], this.repo),
        git(["worktree", "list", "--porcelain"], this.repo),
      ]);
      // Local branches, then remote ones with origin/ dropped (remote HEADs skipped).
      const names = lines(refs)
        .map((r) => (r.startsWith("refs/heads/") ? r.slice(11) : r.slice(13)))
        .filter((n) => !n.endsWith("/HEAD"))
        .map((n) => n.replace(/^origin\//, ""));
      this.branches = [...new Set(names)].sort();
      // Branches with a linked worktree (the first entry is the main checkout).
      const linked = (list?.stdout ?? "").trim().split("\n\n").slice(1);
      this.worktrees = new Set(linked.map((b) => b.match(/^branch refs\/heads\/(.+)$/m)?.[1]).filter(Boolean));
      this.message = this.branches.length ? null : "No branches";
      cx.notify();
    });
  }

  candidates() {
    return this.branches.map((b) => ({ key: b, label: b, base: b.split("/").pop(), branch: b, tag: this.worktrees.has(b) ? "worktree" : null }));
  }

  extra(q) {
    if (!this.repo || this.branches.includes(q)) return [];
    return [{ key: "+create", label: `Create branch “${q}”`, branch: q, create: true }];
  }

  choose(r, cx) {
    if (!this.repo) return;
    this.message = `Starting wtp for ${r.branch}…`;
    cx.notify();
    cx.spawn(async () => {
      let address = null;
      try {
        const args = ["run", "--bg", "--json", "--rm", "--no-parent", "--no-notify", "--", `${appHome()}/scripts/herdr-wtp`, r.branch, "--repo", this.repo];
        if (r.create) args.push("--new");
        if (this.on) args.push("--on", this.on);
        const res = await hc(args);
        if (res.code !== 0) throw new Error(res.stderr.trim() || `hc run exited ${res.code}`);
        address = JSON.parse(res.stdout).address;
      } catch (e) {
        notify({ title: "wtp", body: String(e?.message ?? e), level: "error" });
      } finally {
        this.close();
      }
      if (address) {
        openOverlay({
          kind: "dialog", width: 0.6, height: 0.8,
          layout: { type: "column", children: [{ type: "block", content: { terminal: address } }] },
        });
      }
    });
  }
}
