import { Controller } from "@hotwired/stimulus"

export default class extends Controller
  @targets = ["editR", "sliderR", "editG", "sliderG", "editB", "sliderB", "squareBox", "inverseBox"]

  connect: ->
    @updateColor()

  updateFromEdit: (event) ->
    @clampInput(event.target)
    @syncSlidersAndColor()

  updateFromSlider: ->
    @syncEdits()
    @updateColor()

  syncEdits: ->
    @editRTarget.value = @sliderRTarget.value
    @editGTarget.value = @sliderGTarget.value
    @editBTarget.value = @sliderBTarget.value

  syncSliders: ->
    @sliderRTarget.value = @editRTarget.value
    @sliderGTarget.value = @editGTarget.value
    @sliderBTarget.value = @editBTarget.value

  syncSlidersAndColor: ->
    @syncSliders()
    @updateColor()

  clampInput: (el) ->
    val = parseInt(el.value, 10)
    val = isNaN(val) ? 0 : val
    el.value = Math.min(255, Math.max(0, val))

  updateColor: ->
    r = parseInt(@editRTarget.value) || 0
    g = parseInt(@editGTarget.value) || 0
    b = parseInt(@editBTarget.value) || 0
    color = "rgb(#{r}, #{g}, #{b})"
    invColor = "rgb(#{255 - r}, #{255 - g}, #{255 - b})"
    @squareBoxTarget.style.backgroundColor = color
    @inverseBoxTarget.style.backgroundColor = invColor