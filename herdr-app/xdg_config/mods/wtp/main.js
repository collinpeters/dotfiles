// ctrl-a ctrl-g: pick a branch of the focused pane's repo (or type a new name),
// then run scripts/herdr-wtp in a terminal dialog: `wtp add` with its .wtp.yml
// hooks (live output, no time limit, answerable prompts), then the worktree's space.
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
    this.message = "Loading branches…";
    cx.spawn(async (cx) => {
      const f = focused();
      const local = spaces().find((s) => s.id === f?.space)?.machine == null;
      const cwd = local ? f?.cwd : null;
      const top = cwd ? await exec("git", ["rev-parse", "--show-toplevel"], { cwd }).catch(() => null) : null;
      if (top?.code !== 0) {
        this.message = cwd ? `Not in a git repo: ${cwd}` : "The focused pane isn't a folder on this computer.";
        return cx.notify();
      }
      this.repo = top.stdout.trim();
      this.title = `Worktree: ${this.repo.split("/").pop()}`;
      const [refs, list] = await Promise.all([
        exec("git", ["for-each-ref", "--format=%(refname)", "refs/heads", "refs/remotes"], { cwd: this.repo }),
        exec("git", ["worktree", "list", "--porcelain"], { cwd: this.repo }),
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
        const args = ["run", "--bg", "--json", "--rm", "--no-parent", "--no-notify", "--cwd", this.repo, "--", `${appHome()}/scripts/herdr-wtp`, r.branch];
        if (r.create) args.push("--new");
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
