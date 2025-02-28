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
    
    # Bind methods
    @handleMouseMove = @handleMouseMove.bind(@)
    @animateCursor = @animateCursor.bind(@)
    @handleMouseDown = @handleMouseDown.bind(@)
    @handleMouseUp = @handleMouseUp.bind(@)
    @saveCursorState = @saveCursorState.bind(@)
    @loadCursorState = @loadCursorState.bind(@)
    
    # Track initialization state
    @isInitializing = true
    @circle?.classList.add("initializing")

    # Add event listeners
    globalThis.addEventListener("mousemove", @handleMouseMove)
    globalThis.addEventListener("mousedown", @handleMouseDown)
    globalThis.addEventListener("mouseup", @handleMouseUp)
    document.addEventListener("turbo:before-visit", @saveCursorState)
    document.addEventListener("turbo:load", @loadCursorState)

    # Set default values (will be overridden if state exists in localStorage)
    @isShrinking = false
    @circleX = window.innerWidth / 2
    @circleY = window.innerHeight / 2
    @targetX = @circleX
    @targetY = @circleY
    
    # Load saved state (this will override defaults if available)
    @loadCursorState()
    
    # Start animation loop
    requestAnimationFrame(@animateCursor)

  disconnect: ->
    # Save state before disconnecting
    @saveCursorState()
    
    # Remove event listeners
    globalThis.removeEventListener("mousemove", @handleMouseMove)
    globalThis.removeEventListener("mousedown", @handleMouseDown)
    globalThis.removeEventListener("mouseup", @handleMouseUp)
    document.removeEventListener("turbo:before-visit", @saveCursorState)
    document.removeEventListener("turbo:load", @loadCursorState)

  # Handles mouse movement by updating CSS variables for the circle's position.
  # @param {MouseEvent} event - The mousemove event object.
  handleMouseMove: (event) ->
    prefersReducedMotion = globalThis.matchMedia("(prefers-reduced-motion: reduce)").matches
    if prefersReducedMotion
      @circle?.style.display = "none"
      return
    else
      @circle?.style.display = "block"

    # If this is first movement after initialization, make cursor visible
    if @isInitializing
      @isInitializing = false
      @circle?.classList.remove("initializing")

    x = event.clientX
    y = event.clientY

    # Using consistent variable names (with hyphens)
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
      
      # When cursor reaches target position and was initializing, make it visible
      if @isInitializing and distance <= threshold
        @isInitializing = false
        @circle?.classList.remove("initializing")

    # Using consistent variable names (with hyphens)
    @circle?.style.setProperty("--translate-x", "#{@circleX}px")
    @circle?.style.setProperty("--translate-y", "#{@circleY}px")

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
      
  # Saves cursor state to localStorage when page changes
  saveCursorState: ->
    cursorState = {
      circleX: @circleX
      circleY: @circleY
      targetX: @targetX
      targetY: @targetY
      isShrinking: @isShrinking
    }
    localStorage.setItem('cursorState', JSON.stringify(cursorState))
    
  # Loads cursor state from localStorage
  loadCursorState: ->
    savedState = localStorage.getItem('cursorState')
    if savedState
      state = JSON.parse(savedState)
      @circleX = state.circleX
      @circleY = state.circleY
      @targetX = state.targetX
      @targetY = state.targetY
      @isShrinking = state.isShrinking
      
      # Apply the state to the circle with consistent variable names
      @circle?.style.setProperty("--translate-x", "#{@circleX}px")
      @circle?.style.setProperty("--translate-y", "#{@circleY}px")
      
      # Apply shrinking state if needed
      if @isShrinking
        @circle?.classList.add("shrink")
      else
        @circle?.classList.remove("shrink")