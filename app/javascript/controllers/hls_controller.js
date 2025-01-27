import { Controller } from "@hotwired/stimulus";
import Hls from "hls.js";

export default class extends Controller {
  connect() {
    if (!this.element) return;

    const videoElement = this.element;
    const source = videoElement.dataset.streamUrl; // Get from data attribute

    if (!source) {
      console.error("No stream URL found for video element:", videoElement.id);
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
    // Wait until visible
    if (videoElement.closest(".floating-window").style.display === "none")
      return;

    if (Hls.isSupported()) {
      const hls = new Hls({
        // Enable Web Worker for parallel processing
        enableWorker: true,

        // Enable progressive download for VOD content
        progressive: true,

        // Use the lowest quality level at the start to ensure quick start
        startLevel: -1,

        // Adjust buffer size for low latency streaming
        maxBufferLength: 30, // in seconds
        maxBufferSize: 60 * 1000 * 1000, // 60MB in bytes
        maxBufferHole: 0.1, // in seconds

        // Low latency mode for live streams
        lowLatencyMode: true,

        // Cap level to player size to save bandwidth
        capLevelToPlayerSize: true,

        // Auto start loading on video metadata available
        autoStartLoad: true,

        // Adjust to the network conditions
        abrEwmaFastLive: 3,
        abrEwmaSlowLive: 9,
        abrEwmaFastVoD: 3,
        abrEwmaSlowVoD: 9,

        // Reduce latency by adjusting this setting for live streams
        liveSyncDurationCount: 3,

        // For live streams where low latency is crucial, reduce max latency
        liveMaxLatencyDurationCount: 10,

        // Fragment loading settings to optimize for latency
        fragLoadingTimeOut: 20_000, // Timeout for fragment loading
        fragLoadingMaxRetry: 6,
        fragLoadingRetryDelay: 1000,

        // Manifest loading settings for reliability
        manifestLoadingTimeOut: 30_000,
        manifestLoadingMaxRetry: 1,
        manifestLoadingRetryDelay: 1000,

        // Disable level loading if your stream uses a single quality level
        levelLoadingTimeOut: 20_000,
        levelLoadingMaxRetry: 4,
        levelLoadingRetryDelay: 1000,
      });

      hls.loadSource(source);
      hls.attachMedia(videoElement);

      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        if (videoElement.closest(".floating-window").style.display !== "none") {
          videoElement.play().catch((error) => {
            if (error.name === "NotAllowedError") {
              console.info("Autoplay blocked - waiting for user interaction");
              // Optional: You could add a play button or other UI element here
            } else {
              console.warn("Play request failed:", error);
            }
          });
        }
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
      this.hls = undefined;
    }
  }
}
