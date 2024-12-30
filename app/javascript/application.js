import * as Sentry from "@sentry/browser";
Sentry.init({
  dsn: "https://93b4e68242f246df9153c279a5598ba7@glitchtip-cs40w800ggw0gs0k804skcc0.geor.me/6",
  tracesSampleRate: 1,
});

import "@hotwired/turbo-rails";
import "./controllers";
