import { Controller } from "@hotwired/stimulus";
import Hls from "hls.js";

export default class extends Controller {
  connect() {
    if (!this.element) return;

    const videoElement = this.element;
    const source = videoElement.querySelector("source")?.src;

    if (!source) {
      console.error("No source found for video element:", videoElement.id);
      return;
    }

    // Wait for the element to be visible before initializing HLS
    const observer = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (mutation.target.style.display !== "none") {
          this.initializeHLS(videoElement, source);
          observer.disconnect();
        }
      }
    });

    observer.observe(videoElement.closest(".floating-window"), {
      attributes: true,
      attributeFilter: ["style"],
    });
  }

  initializeHLS(videoElement, source) {
    if (Hls.isSupported()) {
      const hls = new Hls({
        debug: false,
        enableWorker: true,
        lowLatencyMode: true,
      });

      hls.loadSource(source);
      hls.attachMedia(videoElement);

      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        videoElement
          .play()
          .catch((error) => console.warn("Auto-play prevented:", error));
      });

      hls.on(Hls.Events.ERROR, (event, data) => {
        if (data.fatal) {
          switch (data.type) {
            case Hls.ErrorTypes.NETWORK_ERROR: {
              console.error("Network error, attempting to recover...");
              hls.startLoad();
              break;
            }
            case Hls.ErrorTypes.MEDIA_ERROR: {
              console.error("Media error, attempting to recover...");
              hls.recoverMediaError();
              break;
            }
            default: {
              console.error("Fatal error, destroying HLS instance:", data);
              hls.destroy();
              break;
            }
          }
        }
      });

      this.hls = hls;
    } else if (videoElement.canPlayType("application/vnd.apple.mpegurl")) {
      videoElement.src = source;
    } else {
      console.error("HLS is not supported in this browser");
    }
  }

  disconnect() {
    if (this.hls) {
      this.hls.destroy();
      this.hls = null;
    }
  }
}
