import { Controller } from "@hotwired/stimulus";
import * as THREE from "three";
import "emulators"; // Ensure emulators is properly imported

// Connects to data-controller="doom-cube"
export default class extends Controller {
  static targets = ["root", "canvas"];

  connect() {
    // Only set up event listener initially
    document.addEventListener('distractionmode:toggle', this.handleDistractionMode.bind(this));
  }

  handleDistractionMode(event) {
    if (event.detail.enabled && !this.initialized) {
      this.initializeDoomCube();
    }
  }

  initializeDoomCube() {
    this.initialized = true;
    
    // Move all initialization code here
    this.textureCanvas = document.createElement("canvas");
    this.textureCanvas.width = 320;
    this.textureCanvas.height = 200;
    this.ctx = this.textureCanvas.getContext("2d");
    const texture = new THREE.CanvasTexture(this.textureCanvas);

    // Create scene, camera, and renderer using the existing canvas
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, 548 / 308, 0.1, 1000);
    this.renderer = new THREE.WebGLRenderer({ canvas: this.canvasTarget });
    this.renderer.setSize(548, 308);

    // Load background sphere
    const sphereGeometry = new THREE.SphereGeometry(5, 120, 80);
    sphereGeometry.scale(-1, 1, 1);
    const sphereMaterial = new THREE.MeshBasicMaterial({
      map: new THREE.TextureLoader().load("/assets/space.png"),
    });
    const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
    this.scene.add(sphere);

    // Create a rotating cube
    const geometry = new THREE.BoxGeometry(1.45, 1.45, 1.45);
    const material = new THREE.MeshBasicMaterial({ map: texture });
    this.cube = new THREE.Mesh(geometry, material);
    this.scene.add(this.cube);

    // Position the camera
    this.camera.position.z = 2;
    this.camera.updateProjectionMatrix();

    this.animate();
    this.runEmulator(texture);
  }

  animate() {
    requestAnimationFrame(() => this.animate());
    this.cube.rotation.x += 0.01;
    this.cube.rotation.y += 0.01;
    this.renderer.render(this.scene, this.camera);
  }

  async runEmulator(texture) {
    try {
      const bundle = await fetch("/assets/doom_shareware.jsdos");
      const arrayBuffer = await bundle.arrayBuffer();
      const array = new Uint8Array(arrayBuffer);

      this.ci = await emulators.dosWorker(array); // Store ci on this
      const rgba = new Uint8ClampedArray(320 * 200 * 4);

      this.ci.events().onFrame((rgb, _rgba) => {
        for (let next = 0; next < 320 * 200; ++next) {
          rgba[next * 4 + 0] = rgb[next * 3 + 0];
          rgba[next * 4 + 1] = rgb[next * 3 + 1];
          rgba[next * 4 + 2] = rgb[next * 3 + 2];
          rgba[next * 4 + 3] = 255;
        }

        this.ctx?.putImageData(new ImageData(rgba, 320, 200), 0, 0);
        texture.needsUpdate = true;
      });

      globalThis.addEventListener("keydown", (e) => {
        this.ci.sendKeyEvent(e.keyCode, true); // Use this.ci
      });

      globalThis.addEventListener("keyup", (e) => {
        this.ci.sendKeyEvent(e.keyCode, false); // Use this.ci
      });
    } catch (error) {
      console.error("Failed to run emulator:", error);
    }
  }
}
