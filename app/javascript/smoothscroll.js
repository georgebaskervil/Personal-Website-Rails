document.querySelectorAll('a[href^="#"]').forEach((r) => {
  r.addEventListener("click", function (o) {
    o.preventDefault();
    const e = this.getAttribute("href");
    if (e) {
      const t = document.querySelector(e);
      t && t.scrollIntoView({ behavior: "smooth" });
    }
  });
});
