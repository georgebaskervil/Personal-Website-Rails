import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="distractionmode"
export default class extends Controller {
  static targets = ["window", "video"];

  connect() {
    this.areWindowsVisible = false;
    // Initialize the highest z-index counter
    this.highestZIndex = 1;
    this.currentlyDragging = null;
    this.offsetX = 0;
    this.offsetY = 0;

    // Bind methods
    this.toggleDistractionMode = this.toggleDistractionMode.bind(this);
    this.randomizePosition = this.randomizePosition.bind(this);
    this.onMouseMove = this.onMouseMove.bind(this);
    this.onMouseUp = this.onMouseUp.bind(this);

    // Initialize draggable windows
    for (const floatingWindow of this.element.querySelectorAll(".window98")) {
      const dragHandle = floatingWindow.querySelector(".title-bar");

      dragHandle.addEventListener("mousedown", (e) => {
        this.currentlyDragging = floatingWindow;
        this.offsetX = e.clientX - floatingWindow.getBoundingClientRect().left;
        this.offsetY = e.clientY - floatingWindow.getBoundingClientRect().top;

        // Assign a new z-index within 1-7
        this.highestZIndex = (this.highestZIndex % 7) + 1;
        floatingWindow.style.zIndex = this.highestZIndex;

        // Attach listeners
        document.addEventListener("mousemove", this.onMouseMove);
        document.addEventListener("mouseup", this.onMouseUp);

        // Prevent text selection
        e.preventDefault();
      });
    }

    // Attach listeners once
    document.addEventListener("mousemove", this.onMouseMove);
    document.addEventListener("mouseup", this.onMouseUp);

    // Adjust window positions on resize
    window.addEventListener("resize", this.adjustWindowPositions.bind(this));
  }

  toggleDistractionMode() {
    this.areWindowsVisible = !this.areWindowsVisible;

    for (const w of this.windowTargets) {
      w.style.display = this.areWindowsVisible ? "block" : "none";
      if (this.areWindowsVisible) {
        this.randomizePosition(w);
      }
    }

    for (const video of this.videoTargets) {
      this.areWindowsVisible ? video.play() : video.pause();
    }

    // Add this line to dispatch a custom event
    this.element.dispatchEvent(new CustomEvent('distractionmode:toggle', { 
      detail: { enabled: this.areWindowsVisible },
      bubbles: true 
    }));
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

  onMouseMove(e) {
    if (this.currentlyDragging) {
      let newLeft = e.clientX - this.offsetX;
      let newTop = e.clientY - this.offsetY;

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
    }
  }

  onMouseUp() {
    if (this.currentlyDragging) {
      this.currentlyDragging = null;
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
}
