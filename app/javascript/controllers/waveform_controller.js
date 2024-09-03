import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="waveform"
export default class extends Controller {
  connect() {
    let c = null;
    document
      .getElementById("fileInput")
      ?.addEventListener("change", function (n) {
        const a = n.target?.files?.[0];
        if (a) {
          const t = new FileReader();
          (t.onload = function (e) {
            const l = new (window.AudioContext || window.webkitAudioContext)();
            e.target?.result &&
              l.decodeAudioData(
                e.target.result,
                function (s) {
                  (c = s), alert("Audio file loaded successfully.");
                },
                function () {
                  alert("Error decoding audio data.");
                }
              );
          }),
            t.readAsArrayBuffer(a);
        } else alert("Please upload a .wav file.");
      });
    document
      .getElementById("drawButton")
      ?.addEventListener("click", function () {
        const n = document.getElementById("startTime"),
          i = document.getElementById("endTime");
        if (!n || !i) return;
        const a = parseFloat(n.value),
          t = parseFloat(i.value);
        c ? E(c, a, t) : alert("Please load an audio file first.");
      });
    function E(n, i, a) {
      const t = document.getElementById("canvas");
      if (!t) return;
      const e = t.getContext("2d");
      if (!e) return;
      const l = t.width,
        s = t.height,
        d = n.sampleRate,
        g = Math.floor(i * d),
        h = Math.floor(a * d),
        r = n.getChannelData(0).slice(g, h);
      e.clearRect(0, 0, l, s), e.beginPath(), (e.strokeStyle = "#D6D6D6");
      const u = Math.ceil(r.length / l),
        m = s / 2;
      for (let o = 0; o < l; o++) {
        const f = r.slice(o * u, (o + 1) * u),
          w = Math.min(...f),
          p = Math.max(...f);
        e.moveTo(o, (1 + w) * m), e.lineTo(o, (1 + p) * m);
      }
      e.stroke();
    }
  }
}
