import { Controller } from "@hotwired/stimulus";
import { useHotkeys } from "stimulus-use/hotkeys";
import { visit } from "@hotwired/turbo";

export default class extends Controller {
  static targets = [];

  connect() {
    useHotkeys(this, {
      hotkeys: {
        h: { handler: this.goHome },
        p: { handler: this.goPosts },
        i: { handler: this.goImages },
        c: { handler: this.goContact },
        s: { handler: this.goData },
        b: { handler: this.go88x31 },
        w: { handler: this.goWaveformViewer },
        m: { handler: this.goMiscellaneous },
        l: { handler: this.goLegal },
      },
      filter: (event) => {
        return (
          event.target.tagName !== "INPUT" &&
          event.target.tagName !== "TEXTAREA" &&
          !event.ctrlKey &&
          !event.altKey
        );
      },
    });
  }

  goHome(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/") {
      visit("/");
    }
  }

  goPosts(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/posts") {
      visit("/posts");
    }
  }

  goImages(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/images") {
      visit("/images");
    }
  }

  goContact(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/contact") {
      visit("/contact");
    }
  }

  goData(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/data") {
      visit("/data");
    }
  }

  go88x31(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/eightyeightbythirtyone") {
      visit("/eightyeightbythirtyone");
    }
  }

  goWaveformViewer(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/waveform") {
      visit("/waveform");
    }
  }

  goMiscellaneous(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/miscellaneous") {
      visit("/miscellaneous");
    }
  }

  goLegal(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/legal") {
      visit("/legal");
    }
  }
}
