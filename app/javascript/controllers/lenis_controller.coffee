import { Controller } from "@hotwired/stimulus"
import Lenis from "lenis"

export default class extends Controller
  connect: ->
    @lenis = null
    @setupEventListeners()
    @init()

  disconnect: ->
    @destroy()
    @removeEventListeners()

  init: ->
    try
      @lenis ||= new Lenis
        duration: 1.2
        easing: (t) -> Math.min 1, 1.001 - Math.pow(2, -10 * t)
        touchMultiplier: 2
        infinite: false
        autoRaf: true
    catch error
      console.error "Failed to initialize Lenis:", error

  destroy: ->
    if @lenis?
      @lenis.destroy()
      @lenis = null

  resume: ->
    @lenis?.start()

  destroyIfNeeded: (event) =>
    if @lenis? and (!event or event.target.controller isnt "Turbo.FrameController")
      @destroy()

  handleTurboLoad: =>
    if @lenis?
      @resume()
    else
      @init()

  handleTurboRender: =>
    @init() unless @lenis?

  setupEventListeners: ->
    document.addEventListener "turbo:load", @handleTurboLoad
    document.addEventListener "turbo:before-cache", @destroyIfNeeded
    document.addEventListener "turbo:before-render", @destroyIfNeeded
    document.addEventListener "turbo:render", @handleTurboRender
    window.addEventListener "beforeunload", @destroy

  removeEventListeners: ->
    document.removeEventListener "turbo:load", @handleTurboLoad
    document.removeEventListener "turbo:before-cache", @destroyIfNeeded
    document.removeEventListener "turbo:before-render", @destroyIfNeeded
    document.removeEventListener "turbo:render", @handleTurboRender
    window.removeEventListener "beforeunload", @destroy