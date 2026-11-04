// A search box over a list, filtered fzf-style. Used by `sessionizer` and `wtp`.
// Mods can't import from each other's folders (symlinks included), so each has
// an identical copy: edit one, then `cp` it over the other. A subclass calls
// setup() in init and implements candidates() (rows: { key, label, base?, tag? }),
// choose(row, cx), and optionally extra(query, rows) for rows after the matches.
import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { theme, props, closeOverlay } from "herdr";

const VISIBLE = 12;
const ROW = 30;

// The query's letters in order, case-insensitive; -1 when they aren't all there.
// Consecutive letters and letters at the start of a word score higher.
export function score(query, text) {
  const q = query.toLowerCase(), s = text.toLowerCase();
  let qi = 0, total = 0, run = 0, last = -2;
  for (let i = 0; i < s.length && qi < q.length; i++) {
    if (s[i] !== q[qi]) continue;
    run = i === last + 1 ? run + 1 : 0;
    total += 1 + run * 2 + (i === 0 || "/-_. ".includes(s[i - 1]) ? 3 : 0);
    last = i;
    qi++;
  }
  return qi === q.length ? total : -1;
}

export class FuzzyPick extends View {
  setup(cx, { title, placeholder }) {
    this.title = title;
    this.message = null;
    this.query = "";
    this.at = 0;
    this.top = 0;
    this.handle = cx.focus_handle();
    this.input = InputState.new({ placeholder });
    this.input.on("change", (_e, cx) => { this.query = this.input.value(); this.at = 0; this.top = 0; cx.notify(); });
    this.input.on("submit", (_e, cx) => { const r = this.rows()[this.at]; if (r) this.choose(r, cx); });
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
  }

  close() {
    const own = props()?.overlay;
    if (own) closeOverlay(own);
  }

  extra() { return []; }

  rows() {
    const q = this.query.trim();
    const all = this.candidates();
    if (!q) return all;
    const hits = [];
    for (const r of all) {
      // A match inside the last part (folder or branch name) beats one spread over the path.
      const b = r.base ? score(q, r.base) : -1;
      const s = Math.max(b >= 0 ? b + 5 : -1, score(q, r.label));
      if (s >= 0) hits.push([s, r]);
    }
    hits.sort((a, b) => b[0] - a[0]);
    const out = hits.map((h) => h[1]);
    return [...out, ...this.extra(q, out)];
  }

  move(by, n) {
    if (!n) return;
    this.at = Math.max(0, Math.min(n - 1, this.at + by));
    if (this.at < this.top) this.top = this.at;
    if (this.at >= this.top + VISIBLE) this.top = this.at - VISIBLE + 1;
  }

  render() {
    const t = theme();
    const rows = this.rows();
    this.at = Math.min(this.at, Math.max(0, rows.length - 1));
    this.top = Math.min(this.top, Math.max(0, rows.length - VISIBLE));
    const shown = rows.slice(this.top, this.top + VISIBLE);
    const row = (r, i) =>
      h_flex()
        .id(`pick-${r.key}`)
        .h(ROW)
        .flex_none()
        .px(10)
        .gap(10)
        .items_center()
        .rounded(7)
        .cursor_pointer()
        .when(i === this.at, (el) => el.bg(t.hover))
        .hover((s) => s.bg(t.hover))
        .on_click((_e, cx) => this.choose(r, cx))
        .child(div().flex_1().truncate().text_color(r.create ? t.accent : t.foreground).child(r.label))
        .when(Boolean(r.tag), (el) => el.child(div().text_size(11).text_color(t.dim).child(r.tag)));
    return v_flex()
      .id("pick")
      .track_focus(this.handle)
      .size_full()
      .p(18)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .on_key_down((e, cx) => {
        const k = e.key, ctrl = e.modifiers.control;
        if (k === "escape") return this.close();
        if (k === "down" || (ctrl && k === "n")) this.move(1, rows.length);
        else if (k === "up" || (ctrl && k === "p")) this.move(-1, rows.length);
        else if (k === "pagedown") this.move(VISIBLE, rows.length);
        else if (k === "pageup") this.move(-VISIBLE, rows.length);
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(h_flex().items_center()
        .child(div().flex_1().truncate().text_size(15).font_semibold().text_color(t.foreground).child(this.title))
        .child(div().text_size(11).text_color(t.dim).child(rows.length ? `${this.at + 1}/${rows.length}` : "")))
      .child(
        h_flex().h(36).flex_none().px(10).gap(8).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
          .child(Input.new(this.input).flex_1().h_full().text_size(12.8).text_color(t.foreground)),
      )
      .child(
        v_flex()
          .id("pick-list")
          .h(VISIBLE * ROW)
          .flex_none()
          .overflow_hidden()
          .on_scroll_wheel((e, cx) => {
            this.move(e.delta.y < 0 ? 1 : -1, rows.length);
            cx.notify();
          })
          .when(!shown.length, (el) => el.child(div().px(10).py(6).text_color(t.dim).child(this.message ?? "No matches")))
          .children(shown.map((r, i) => row(r, this.top + i))),
      );
  }
}
