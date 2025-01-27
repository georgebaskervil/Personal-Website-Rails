import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="distractionmode"
export default class extends Controller {
  static targets = ["window", "video"];

  connect() {
    this.areWindowsVisible = false;
    this.highestZIndex = 1;
    this.currentlyDragging = undefined;
    this.offsetX = 0;
    this.offsetY = 0;
    this.lastMouseX = 0;
    this.lastMouseY = 0;
    this.hasShownBefore = false;

    this.toggleDistractionMode = this.toggleDistractionMode.bind(this);
    this.randomizePosition = this.randomizePosition.bind(this);
    this.onMouseMove = this.onMouseMove.bind(this);
    this.onMouseUp = this.onMouseUp.bind(this);

    // Initialize z-indexes for all windows
    for (const [index, window] of this.windowTargets.entries()) {
      window.style.zIndex = index + 1;
      this.highestZIndex = Math.max(this.highestZIndex, index + 1);

      // Add click handler to entire window
      window.addEventListener("mousedown", () => {
        this.bringToFront(window);
      });
    }

    for (const floatingWindow of this.element.querySelectorAll(".window98")) {
      floatingWindow.style.transition =
        "transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), left 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), top 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.3s ease-in-out";
      floatingWindow.style.opacity = "0";
      const dragHandle = floatingWindow.querySelector(".title-bar");

      dragHandle.addEventListener("mousedown", (event) => {
        document.body.classList.add("dragging");
        floatingWindow.classList.add("currently-dragging");
        this.currentlyDragging = floatingWindow;
        this.offsetX =
          event.clientX - floatingWindow.getBoundingClientRect().left;
        this.offsetY =
          event.clientY - floatingWindow.getBoundingClientRect().top;
        this.lastMouseX = event.clientX;
        this.lastMouseY = event.clientY;

        this.bringToFront(floatingWindow);

        document.addEventListener("mousemove", this.onMouseMove);
        document.addEventListener("mouseup", this.onMouseUp);

        event.preventDefault();
      });
    }

    window.addEventListener("resize", this.adjustWindowPositions.bind(this));
  }

  toggleDistractionMode() {
    this.areWindowsVisible = !this.areWindowsVisible;
    const firstShow = !this.hasShownBefore;

    for (const w of this.windowTargets) {
      if (this.areWindowsVisible) {
        w.style.display = "block";
        setTimeout(() => {
          w.style.opacity = "1";
          if (firstShow) {
            this.randomizePosition(w);
          }
        }, 50);
      } else {
        w.style.opacity = "0";
        setTimeout(() => {
          w.style.display = "none";
        }, 300);
      }
    }

    if (this.areWindowsVisible) {
      this.hasShownBefore = true;
    }

    for (const video of this.videoTargets) {
      if (this.areWindowsVisible) {
        video
          .play()
          .catch((error) => console.warn("Play request interrupted:", error));
      } else {
        video.pause();
      }
    }

    this.element.dispatchEvent(
      new CustomEvent("distractionmode:toggle", {
        detail: { enabled: this.areWindowsVisible },
        bubbles: true,
      }),
    );
  }

  randomizePosition(floatingWindow) {
    const windowWidth = floatingWindow.offsetWidth;
    const windowHeight = floatingWindow.offsetHeight;
    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;

    const maxLeft = viewportWidth - windowWidth - 20;
    const maxTop = viewportHeight - windowHeight - 20;

    const randomLeft = Math.max(
      10,
      Math.floor(Math.random() * (maxLeft - 10)) + 10,
    );
    const randomTop = Math.max(
      10,
      Math.floor(Math.random() * (maxTop - 10)) + 10,
    );

    floatingWindow.style.left = `${randomLeft}px`;
    floatingWindow.style.top = `${randomTop}px`;
  }

  onMouseMove(event) {
    if (this.currentlyDragging) {
      let newLeft = event.clientX - this.offsetX;
      let newTop = event.clientY - this.offsetY;

      const deltaX = event.clientX - this.lastMouseX;
      const rotation = deltaX * 0.5;

      const windowWidth = this.currentlyDragging.offsetWidth;
      const windowHeight = this.currentlyDragging.offsetHeight;
      const viewportWidth = window.innerWidth;
      const viewportHeight = window.innerHeight;

      newLeft = Math.max(
        10,
        Math.min(newLeft, viewportWidth - windowWidth - 10),
      );
      newTop = Math.max(
        10,
        Math.min(newTop, viewportHeight - windowHeight - 10),
      );

      this.currentlyDragging.style.left = `${newLeft}px`;
      this.currentlyDragging.style.top = `${newTop}px`;
      this.currentlyDragging.style.transform = `rotate(${rotation}deg)`;

      this.lastMouseX = event.clientX;
      this.lastMouseY = event.clientY;
    }
  }

  onMouseUp() {
    if (this.currentlyDragging) {
      document.body.classList.remove("dragging");
      this.currentlyDragging.classList.remove("currently-dragging");
      this.currentlyDragging.style.transform = "rotate(0deg)";
      this.currentlyDragging = undefined;
    }
    document.removeEventListener("mousemove", this.onMouseMove);
    document.removeEventListener("mouseup", this.onMouseUp);
  }

  adjustWindowPositions() {
    for (const floatingWindow of this.element.querySelectorAll(".window98")) {
      const windowWidth = floatingWindow.offsetWidth;
      const windowHeight = floatingWindow.offsetHeight;
      const viewportWidth = window.innerWidth;
      const viewportHeight = window.innerHeight;

      let currentLeft = Number.parseInt(floatingWindow.style.left, 10);
      let currentTop = Number.parseInt(floatingWindow.style.top, 10);

      const maxLeft = viewportWidth - windowWidth - 10;
      const maxTop = viewportHeight - windowHeight - 10;

      if (currentLeft > maxLeft) {
        floatingWindow.style.left = `${maxLeft}px`;
      }

      if (currentTop > maxTop) {
        floatingWindow.style.top = `${maxTop}px`;
      }
    }
  }

  bringToFront(floatingWindow) {
    this.highestZIndex++;
    floatingWindow.style.zIndex = this.highestZIndex;
  }
}
