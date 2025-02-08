import { Controller } from "@hotwired/stimulus"

# Utility function for linear interpolation.
# @param {number} start - Starting value.
# @param {number} end - Ending value.
# @param {number} amt - Interpolation factor between 0 and 1.
# @returns {number} - Interpolated value.
lerp = (start, end, amt) ->
  (1 - amt) * start + amt * end

export default class extends Controller
  connect: ->
    @circle = @element.querySelector(".custom-cursor-circle")
    @circleX = window.innerWidth / 2
    @circleY = window.innerHeight / 2
    @targetX = @circleX
    @targetY = @circleY

    @handleMouseMove = @handleMouseMove.bind(@)
    @animateCursor = @animateCursor.bind(@)
    @handleMouseDown = @handleMouseDown.bind(@)
    @handleMouseUp = @handleMouseUp.bind(@)

    globalThis.addEventListener("mousemove", @handleMouseMove)
    globalThis.addEventListener("mousedown", @handleMouseDown)
    globalThis.addEventListener("mouseup", @handleMouseUp)

    @isShrinking = false
    requestAnimationFrame(@animateCursor)

  disconnect: ->
    globalThis.removeEventListener("mousemove", @handleMouseMove)
    globalThis.removeEventListener("mousedown", @handleMouseDown)
    globalThis.removeEventListener("mouseup", @handleMouseUp)

  # Handles mouse movement by updating CSS variables for the circle's position.
  # @param {MouseEvent} event - The mousemove event object.
  handleMouseMove: (event) ->
    prefersReducedMotion = globalThis.matchMedia("(prefers-reduced-motion: reduce)").matches
    if prefersReducedMotion
      @circle?.style.display = "none"
      return
    else
      @circle?.style.display = "block"

    x = event.clientX
    y = event.clientY

    @circle?.style.setProperty("--translate-x", "#{x}px")
    @circle?.style.setProperty("--translate-y", "#{y}px")

    @targetX = x
    @targetY = y

  # Animates the circle to follow the target position with easing.
  animateCursor: ->
    deltaX = @targetX - @circleX
    deltaY = @targetY - @circleY
    distance = Math.hypot(deltaX, deltaY)
    threshold = 0.1

    if distance > threshold
      easingAmount = 0.2
      @circleX = lerp(@circleX, @targetX, easingAmount)
      @circleY = lerp(@circleY, @targetY, easingAmount)
    else
      @circleX = @targetX
      @circleY = @targetY

    @circle?.style.setProperty("--translateX", "#{@circleX}px")
    @circle?.style.setProperty("--translateY", "#{@circleY}px")

    requestAnimationFrame(@animateCursor)

  # Handles mouse down events by adding the shrink class to the circle.
  handleMouseDown: (event) ->
    if event.button is 0 and @circle and not @isShrinking
      @isShrinking = true
      @circle.classList.add("shrink")

  # Handles mouse up events by removing the shrink class from the circle.
  handleMouseUp: (event) ->
    if event.button is 0 and @circle and @isShrinking
      @circle.classList.remove("shrink")
      @isShrinking = false