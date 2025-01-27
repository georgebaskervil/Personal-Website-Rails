import { Controller } from "@hotwired/stimulus"

export default class extends Controller
  @targets = ["editR", "sliderR", "editG", "sliderG", "editB", "sliderB", "squareBox", "inverseBox"]

  connect: ->
    @updateColor()

  updateFromEdit: (event) ->
    @clampInput(event.target)
    @syncSliders()
    @updateColor()

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

  clampInput: (el) ->
    val = parseInt(el.value, 10)
    if isNaN(val) then val = 0
    if val < 0 then val = 0
    if val > 255 then val = 255
    el.value = val

  updateColor: ->
    r = parseInt(@editRTarget.value)
    g = parseInt(@editGTarget.value)
    b = parseInt(@editBTarget.value)
    color = "rgb(#{r}, #{g}, #{b})"
    invColor = "rgb(#{255-r}, #{255-g}, #{255-b})"
    @squareBoxTarget.style.backgroundColor = color
    @inverseBoxTarget.style.backgroundColor = invColor