import { Controller } from "@hotwired/stimulus"
import Plotly from 'plotly.js-dist'

export default class extends Controller
  @targets = [
    "ph", "pth", "ptnh", "plot", "results", "error", "validResults",
    "pht", "pnotht", "phnott", "pnothnott", "pt", "pnott"
  ]

  connect: ->
    @plotInitialized = false
    @plotTarget.classList.add 'loading'
    @updateAll()
    @plotInitialized = true

  inputChanged: ->
    @updateAll()

  updateAll: ->
    ph = parseFloat @phTarget.value
    pth = parseFloat @pthTarget.value
    ptnh = parseFloat @ptnhTarget.value

    pnoth = 1 - ph
    pt = ph * pth + pnoth * ptnh
    pht = (ph * pth) / pt

    return unless @updateResults(ph, pth, ptnh, pht)
    @updatePlot ph, pth, ptnh, pht

  updateResults: (ph, pth, ptnh, pht) ->
    if isNaN(ph) or isNaN(pth) or isNaN(ptnh) or ph < 0 or ph > 1 or pth < 0 or pth > 1 or ptnh < 0 or ptnh > 1
      @errorTarget.style.display = "block"
      @validResultsTarget.style.display = "none"
      return false

    pnoth = 1 - ph
    pt = ph * pth + pnoth * ptnh
    pnot_t = 1 - pt
    pnot_ht = 1 - pht
    ph_not_t = (ph * (1 - pth)) / pnot_t
    pnot_h_not_t = 1 - ph_not_t

    if not isFinite(ph_not_t)
      @errorTarget.style.display = "block"
      @validResultsTarget.style.display = "none"
      return false

    @errorTarget.style.display = "none"
    @validResultsTarget.style.display = "block"

    @phtTarget.textContent = pht.toFixed 3
    @pnothtTarget.textContent = pnot_ht.toFixed 3
    @phnottTarget.textContent = ph_not_t.toFixed 3
    @pnothnottTarget.textContent = pnot_h_not_t.toFixed 3
    @ptTarget.textContent = pt.toFixed 3
    @pnottTarget.textContent = pnot_t.toFixed 3

    true

  updatePlot: (ph, pth, ptnh, pht) ->
    n = 100
    xVals = (i / n for i in [0..(n-1)])
    yVals = (i / n for i in [0..(n-1)])
    zVals = []

    for i in [0..(n-1)]
      row = []
      for j in [0..(n-1)]
        local_ph = xVals[i]
        local_pth = yVals[j]
        row.push 1 / (((1 - local_ph) * (1 - local_pth) / (local_ph * local_pth)) + 1)
      zVals.push row

    data = [
      type: 'surface'
      x: xVals
      y: yVals
      z: zVals
      colorscale: 'Viridis'
      showscale: false
    ,
      type: 'scatter3d'
      x: [ph]
      y: [pth]
      z: [pht]
      mode: 'markers'
      marker: size: 8, color: 'red'
      name: 'Current'
    ]

    layout = Object.assign {}, @getBaseLayout(),
      autosize: true
      scene: Object.assign {},
        @getBaseLayout().scene,
        domain:
          x: [0, 1]
          y: [0, 1]
        camera:
          up: x: 0, y: 0, z: 1
          center: x: 0, y: 0, z: 0
          eye: x: 1.5, y: 1.5, z: 1.5

    config = displayModeBar: false, responsive: true

    if @plotInitialized
      Plotly.react @plotTarget, data, layout, config
    else
      Plotly.newPlot @plotTarget, data, layout, config

    @plotTarget.classList.remove 'loading'

  getBaseLayout: ->
    paper_bgcolor: 'rgba(0,0,0,0)'
    plot_bgcolor: 'rgba(0,0,0,0)'
    font:
      color: '#c0caf5'
      family: '"Space Mono", monospace'
    margin:
      t: 40
      r: 40
      l: 40
      b: 40
    showlegend: false
    scene:
      xaxis:
        title: 'P(H)'
        range: [0, 1]
      yaxis:
        title: 'P(T|H)'
        range: [0, 1]
      zaxis:
        title: 'P(H|T)'
        range: [0, 1]