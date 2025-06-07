import * as Sentry from "@sentry/browser";

if (!import.meta.env.DEV) {
  // Only initialize Sentry when not in development mode
  Sentry.init({
    dsn: "https://3bb363a19fa84e9fb16b7af2e5ef1bf8@glitchtip-k8wwcks4kogokwkgok8k84os.geor.me/1",
  });
}

// Hijack the XMLHttpRequest primitive to replace the wdosbox.js and wdosbox.wasm URLs
// Its a hack, but I can't find a way to control what other libraries are doing
// without going in and modifying them directly
import wdosboxJsUrl from "emulators/dist/wdosbox.js?url";
import wdosboxWasmUrl from "emulators/dist/wdosbox.wasm?url";

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
import "./live_updater";
