import { Controller } from "@hotwired/stimulus";
import { useHotkeys } from "stimulus-use/hotkeys";

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
      globalThis.Turbo.visit("/");
    }
  }

  goPosts(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/posts") {
      globalThis.Turbo.visit("/posts");
    }
  }

  goImages(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/images") {
      globalThis.Turbo.visit("/images");
    }
  }

  goContact(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/contact") {
      globalThis.Turbo.visit("/contact");
    }
  }

  goData(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/data") {
      globalThis.Turbo.visit("/data");
    }
  }

  go88x31(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/eightyeightbythirtyone") {
      globalThis.Turbo.visit("/eightyeightbythirtyone");
    }
  }

  goWaveformViewer(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/waveform") {
      globalThis.Turbo.visit("/waveform");
    }
  }

  goMiscellaneous(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/miscellaneous") {
      globalThis.Turbo.visit("/miscellaneous");
    }
  }

  goLegal(event) {
    event.preventDefault();
    if (globalThis.location.pathname !== "/legal") {
      globalThis.Turbo.visit("/legal");
    }
  }
}
