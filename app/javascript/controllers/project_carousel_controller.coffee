# filepath: /Users/george/Personal-Website-Rails/app/javascript/controllers/project_carousel_controller.coffee
import { Controller } from "@hotwired/stimulus"

export default class extends Controller
  @targets: [
    "slides"
    "slide" 
    "indicator"
    "prevButton"
    "nextButton"
    "video"
  ]

  @values:
    currentSlide: Number
    totalSlides: Number
    autoAdvanceInterval: Number

  connect: ->
    console.log '[ProjectCarousel] Controller connecting...'
    @currentSlideValue = 0
    @totalSlidesValue = @slideTargets.length
    @autoAdvanceIntervalValue = 8000
    @touchStartX = 0
    @touchEndX = 0
    
    console.log "[ProjectCarousel] Found #{@totalSlidesValue} slides"
    console.log '[ProjectCarousel] Has slides target:', @hasSlidesTarget
    
    return unless @hasSlidesTarget and @slideTargets.length > 0
    
    @initializeCarousel()
    @setupEventListeners()
    @startAutoAdvance()
    console.log '[ProjectCarousel] Controller connected successfully'

  disconnect: ->
    console.log '[ProjectCarousel] Controller disconnecting...'
    @stopAutoAdvance()
    @removeEventListeners()
    console.log '[ProjectCarousel] Controller disconnected'

  initializeCarousel: ->
    console.log '[ProjectCarousel] Initializing carousel'
    @showSlide(0)

  setupEventListeners: ->
    console.log '[ProjectCarousel] Setting up event listeners'
    # Touch events for swipe support
    @slidesTarget.addEventListener 'touchstart', @handleTouchStart.bind(@)
    @slidesTarget.addEventListener 'touchend', @handleTouchEnd.bind(@)
    
    # Keyboard navigation
    document.addEventListener 'keydown', @handleKeydown.bind(@)
    console.log '[ProjectCarousel] Event listeners set up successfully'

  removeEventListeners: ->
    @slidesTarget.removeEventListener 'touchstart', @handleTouchStart.bind(@)
    @slidesTarget.removeEventListener 'touchend', @handleTouchEnd.bind(@)
    document.removeEventListener 'keydown', @handleKeydown.bind(@)

  showSlide: (index) ->
    console.log "[ProjectCarousel] Showing slide #{index} (current: #{@currentSlideValue})"
    
    # Pause all videos first
    @pauseAllVideos()
    
    # Remove active class from all slides and indicators
    for slide in @slideTargets
      slide.classList.remove('active')
    
    for indicator in @indicatorTargets
      indicator.classList.remove('active')
    
    # Add active class to current slide and indicator
    if @slideTargets[index]
      @slideTargets[index].classList.add('active')
      console.log "[ProjectCarousel] Activated slide #{index}"
      
      # Play video if the active slide contains one
      @playActiveSlideVideo(index)
    else
      console.warn "[ProjectCarousel] Slide #{index} not found"
    
    if @indicatorTargets[index]
      @indicatorTargets[index].classList.add('active')
      console.log "[ProjectCarousel] Activated indicator #{index}"
    else
      console.warn "[ProjectCarousel] Indicator #{index} not found"
    
    # Transform the carousel container
    transform = "translateX(-#{index * 100}%)"
    @slidesTarget.style.transform = transform
    console.log "[ProjectCarousel] Applied transform: #{transform}"
    
    @currentSlideValue = index

  # Video control methods
  pauseAllVideos: ->
    if @hasVideoTarget
      for video in @videoTargets
        try
          video.pause() if video.readyState >= 2
        catch error
          console.log "[ProjectCarousel] Could not pause video:", error

  playActiveSlideVideo: (slideIndex) ->
    if @hasVideoTarget
      activeSlide = @slideTargets[slideIndex]
      if activeSlide
        video = activeSlide.querySelector('[data-project-carousel-target="video"]')
        if video
          try
            video.play().catch (error) ->
              console.log "[ProjectCarousel] Could not play video:", error
          catch error
            console.log "[ProjectCarousel] Video play error:", error

  nextSlide: ->
    next = (@currentSlideValue + 1) % @totalSlidesValue
    console.log "[ProjectCarousel] Moving to next slide: #{@currentSlideValue} -> #{next}"
    @showSlide(next)

  previousSlide: ->
    previous = (@currentSlideValue - 1 + @totalSlidesValue) % @totalSlidesValue
    console.log "[ProjectCarousel] Moving to previous slide: #{@currentSlideValue} -> #{previous}"
    @showSlide(previous)

  # Action methods for button clicks
  next: (event) ->
    console.log '[ProjectCarousel] Next button clicked'
    event.preventDefault()
    @nextSlide()

  previous: (event) ->
    console.log '[ProjectCarousel] Previous button clicked'
    event.preventDefault()
    @previousSlide()

  # Action method for indicator clicks
  goToSlide: (event) ->
    event.preventDefault()
    index = parseInt(event.currentTarget.dataset.slide)
    console.log "[ProjectCarousel] Indicator clicked for slide #{index}"
    @showSlide(index) if index >= 0 and index < @totalSlidesValue

  # Touch event handlers
  handleTouchStart: (event) ->
    @touchStartX = event.touches[0].clientX
    console.log "[ProjectCarousel] Touch start at X: #{@touchStartX}"

  handleTouchEnd: (event) ->
    @touchEndX = event.changedTouches[0].clientX
    console.log "[ProjectCarousel] Touch end at X: #{@touchEndX}"
    @handleSwipe()

  handleSwipe: ->
    swipeThreshold = 50
    diff = @touchStartX - @touchEndX
    
    console.log "[ProjectCarousel] Swipe diff: #{diff} (threshold: #{swipeThreshold})"
    
    if Math.abs(diff) > swipeThreshold
      if diff > 0
        console.log '[ProjectCarousel] Swipe left detected - next slide'
        @nextSlide()  # Swipe left - next slide
      else
        console.log '[ProjectCarousel] Swipe right detected - previous slide'
        @previousSlide()  # Swipe right - previous slide
    else
      console.log '[ProjectCarousel] Swipe too small, ignoring'

  # Keyboard navigation
  handleKeydown: (event) ->
    switch event.key
      when 'ArrowLeft'
        console.log '[ProjectCarousel] Left arrow pressed'
        @previousSlide()
      when 'ArrowRight'
        console.log '[ProjectCarousel] Right arrow pressed'
        @nextSlide()

  # Auto-advance functionality
  startAutoAdvance: ->
    console.log "[ProjectCarousel] Starting auto-advance (interval: #{@autoAdvanceIntervalValue}ms)"
    @autoAdvanceTimer = setInterval =>
      console.log '[ProjectCarousel] Auto-advance triggered'
      @nextSlide()
    , @autoAdvanceIntervalValue

  stopAutoAdvance: ->
    if @autoAdvanceTimer
      console.log '[ProjectCarousel] Stopping auto-advance'
      clearInterval(@autoAdvanceTimer)
    else
      console.log '[ProjectCarousel] No auto-advance timer to stop'

  # Pause auto-advance on hover
  pauseAutoAdvance: ->
    console.log '[ProjectCarousel] Pausing auto-advance (mouse enter)'
    @stopAutoAdvance()

  # Resume auto-advance when not hovering
  resumeAutoAdvance: ->
    console.log '[ProjectCarousel] Resuming auto-advance (mouse leave)'
    @startAutoAdvance()

  disconnect: ->
    console.log '[ProjectCarousel] Controller disconnecting...'
    @pauseAllVideos()
    @stopAutoAdvance()
    @removeEventListeners()
    console.log '[ProjectCarousel] Controller disconnected'
