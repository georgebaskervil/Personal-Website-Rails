import { Controller } from "@hotwired/stimulus"

export default class extends Controller

  connect: =>
    @running = false
    @requestId = undefined
    @nekoEl = @element
    @onDistractionToggle = @onDistractionToggle.bind(@)
    document.addEventListener "distractionmode:toggle", @onDistractionToggle
    @nekoEl.classList.add "oneko", "hidden"

  disconnect: =>
    document.removeEventListener "distractionmode:toggle", @onDistractionToggle
    cancelAnimationFrame @requestId if @requestId

  onDistractionToggle: (event) =>
    if event.detail.enabled
      @startNeko()
    else
      @stopNeko()

  startNeko: =>
    return if @running
    isReducedMotion = globalThis.matchMedia("(prefers-reduced-motion: reduce)")?.matches
    return if isReducedMotion
    @running = true
    @nekoEl.classList.remove "hidden"
    @initNeko()
    @loop()

  stopNeko: =>
    @running = false
    @nekoEl.classList.add "hidden"
    cancelAnimationFrame @requestId if @requestId
    @requestId = undefined

  initNeko: =>
    @nekoPosX = 32
    @nekoPosY = 32
    @mousePosX = 0
    @mousePosY = 0
    @frameCount = 0
    @idleTime = 0
    @idleAnimation = null
    @idleAnimationFrame = 0
    @lastFrameTimestamp = undefined
    @nekoSpeed = 10
    @spriteSets =
      idle: [[-3, -3]]
      alert: [[-7, -3]]
      scratchSelf: [[-5, 0], [-6, 0], [-7, 0]]
      scratchWallN: [[0, 0], [0, -1]]
      scratchWallS: [[-7, -1], [-6, -2]]
      scratchWallE: [[-2, -2], [-2, -3]]
      scratchWallW: [[-4, 0], [-4, -1]]
      tired: [[-3, -2]]
      sleeping: [[-2, 0], [-2, -1]]
      N: [[-1, -2], [-1, -3]]
      NE: [[0, -2], [0, -3]]
      E: [[-3, 0], [-3, -1]]
      SE: [[-5, -1], [-5, -2]]
      S: [[-6, -3], [-7, -2]]
      SW: [[-5, -3], [-6, -1]]
      W: [[-4, -2], [-4, -3]]
      NW: [[-1, 0], [-1, -1]]
    @nekoEl.id = "oneko"
    @nekoEl.ariaHidden = true
    Object.assign @nekoEl.style,
      width: "32px"
      height: "32px"
      position: "fixed"
      pointerEvents: "none"
      imageRendering: "pixelated"
      left: "#{@nekoPosX - 16}px"
      top: "#{@nekoPosY - 16}px"
      zIndex: 2147483647
    document.addEventListener "mousemove", (event) =>
      @mousePosX = event.clientX
      @mousePosY = event.clientY

  loop: (timestamp) =>
    return unless @running
    @lastFrameTimestamp = timestamp unless @lastFrameTimestamp
    if timestamp - @lastFrameTimestamp > 100
      @lastFrameTimestamp = timestamp
      @updateNeko()
    @requestId = globalThis.requestAnimationFrame @loop

  updateNeko: =>
    diffX = @nekoPosX - @mousePosX
    diffY = @nekoPosY - @mousePosY
    distance = Math.hypot diffX, diffY
    if distance < @nekoSpeed or distance < 48
      @idle()
      return
    @idleAnimation = null
    @idleAnimationFrame = 0
    if @idleTime > 1
      @setSprite "alert", 0
      @idleTime = Math.min @idleTime, 7
      @idleTime--
      return
    direction = ""
    direction = "N" if diffY / distance > 0.5
    direction += "S" if diffY / distance < -0.5
    direction += "W" if diffX / distance > 0.5
    direction += "E" if diffX / distance < -0.5
    @setSprite direction, @frameCount++
    @nekoPosX -= (diffX / distance) * @nekoSpeed
    @nekoPosY -= (diffY / distance) * @nekoSpeed
    @nekoPosX = Math.min Math.max(16, @nekoPosX), window.innerWidth - 16
    @nekoPosY = Math.min Math.max(16, @nekoPosY), window.innerHeight - 16
    @nekoEl.style.left = "#{@nekoPosX - 16}px"
    @nekoEl.style.top = "#{@nekoPosY - 16}px"

  idle: =>
    @idleTime++
    if @idleTime > 10 and Math.floor(Math.random() * 200) is 0 and not @idleAnimation
      availableAnims = ["sleeping", "scratchSelf"]
      availableAnims.push "scratchWallW" if @nekoPosX < 32
      availableAnims.push "scratchWallN" if @nekoPosY < 32
      availableAnims.push "scratchWallE" if @nekoPosX > window.innerWidth - 32
      availableAnims.push "scratchWallS" if @nekoPosY > window.innerHeight - 32
      @idleAnimation = availableAnims[Math.floor(Math.random() * availableAnims.length)]
    switch @idleAnimation
      when "sleeping"
        if @idleAnimationFrame < 8
          @setSprite "tired", 0
        else
          @setSprite "sleeping", Math.floor(@idleAnimationFrame / 4)
        @resetIdleAnimation() if @idleAnimationFrame > 192
      when "scratchWallN", "scratchWallS", "scratchWallE", "scratchWallW", "scratchSelf"
        @setSprite @idleAnimation, @idleAnimationFrame
        @resetIdleAnimation() if @idleAnimationFrame > 9
      else
        @setSprite "idle", 0
        return
    @idleAnimationFrame++

  setSprite: (name, frameNumber) =>
    sprite = @spriteSets[name][frameNumber % @spriteSets[name].length]
    @nekoEl.style.backgroundPosition = "#{sprite[0] * 32}px #{sprite[1] * 32}px"

  resetIdleAnimation: =>
    @idleAnimation = undefined
    @idleAnimationFrame = 0
