// Disabled for now because the GlitchTip instance is down

// import * as Sentry from "@sentry/browser";
// Sentry.init({
//   dsn: "https://93b4e68242f246df9153c279a5598ba7@glitchtip-cs40w800ggw0gs0k804skcc0.geor.me/6",
//   tracesSampleRate: 1,
// });

// Hijack the XMLHttpRequest primitive to replace the wdosbox.js and wdosbox.wasm URLs
// Ik it's a hack, but I can't find a way to control what other libraries are doing
// without going in and modifying them directly

import wdosboxJsUrl from "~/libs/wdosbox.js?url";
import wdosboxWasmUrl from "~/libs/wdosbox.wasm?url";

(function () {
  const originalOpen = XMLHttpRequest.prototype.open;
  XMLHttpRequest.prototype.open = function (method, url, ...rest) {
    if (url.includes("wdosbox.js")) url = wdosboxJsUrl;
    if (url.includes("wdosbox.wasm")) url = wdosboxWasmUrl;
    return originalOpen.call(this, method, url, ...rest);
  };

  const originalFetch = globalThis.fetch;
  globalThis.fetch = async function (resource, ...rest) {
    if (typeof resource === "string") {
      if (resource.includes("wdosbox.js")) resource = wdosboxJsUrl;
      if (resource.includes("wdosbox.wasm")) resource = wdosboxWasmUrl;
    }
    return originalFetch(resource, ...rest);
  };
})();

import "@hotwired/turbo-rails";
import "./controllers";
