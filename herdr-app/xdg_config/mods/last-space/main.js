// Jump back to the previously shown space (old herdr's third774.last-workspace).
// `mod.open last-space` installs a kept, empty overlay window (it reopens on
// every start). That copy re-renders whenever focus changes, remembers the
// space shown before the current one, and handles `last-space.toggle`.
import { View, div } from "gpui-kit";
import { focused, spaces, shared, setShared, nextCommand, run, props, openOverlay, closeOverlay } from "herdr";

const PREV = "last-space.prev";

export default class LastSpace extends View {
  init(_props, cx) {
    if (!props()?.tracker) {
      // Launched by mod.open: install the tracker window, then close this popup.
      openOverlay({ mod: "last-space", props: { tracker: true }, kind: "window", key: "last-space", keep: true, frame: "none" });
      const own = props()?.overlay;
      if (own) closeOverlay(own);
      return;
    }
    this.current = focused()?.space ?? null;
    cx.spawn(async () => {
      for (;;) {
        if ((await nextCommand()) !== "toggle") continue;
        const prev = shared(PREV);
        if (prev && prev !== focused()?.space && spaces().some((s) => s.id === prev)) run("space.select", { id: prev });
      }
    });
  }

  render() {
    const space = focused()?.space ?? null;
    if (props()?.tracker && space && space !== this.current) {
      if (this.current) setShared(PREV, this.current);
      this.current = space;
    }
    return div();
  }
}
