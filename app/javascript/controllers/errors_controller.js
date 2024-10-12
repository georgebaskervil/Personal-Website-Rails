import { Controller } from "@hotwired/stimulus";
import * as Sentry from "@sentry/browser";

// Connects to data-controller="errors"
export default class extends Controller {
  connect() {
    Sentry.init({
      dsn: "https://464a84695ee24afbb22817b94618d577@glitchtip-cs40w800ggw0gs0k804skcc0.geor.me/5",
      tracesSampleRate: 1.0,
    });
  }
}
