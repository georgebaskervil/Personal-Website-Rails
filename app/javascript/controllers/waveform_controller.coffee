{ Controller } = require "@hotwired/stimulus"

export default class WaveformController extends Controller
  connect: ->
    c = null
    
    document.getElementById("fileInput")?.addEventListener "change", (n) ->
      file = n.target.files?[0]
      if file
        reader = new FileReader()
        reader.onload = (e) ->
          audioContext = new (window.AudioContext or window.webkitAudioContext)
          if e.target?.result
            audioContext.decodeAudioData e.target.result, (buffer) ->
              c = buffer
              alert "Audio file loaded successfully."
            , ->
              alert "Error decoding audio data."
        reader.readAsArrayBuffer file
      else 
        alert "Please upload a .wav file."

    document.getElementById("drawButton")?.addEventListener "click", ->
      startTimeEl = document.getElementById("startTime")
      endTimeEl = document.getElementById("endTime")
      return unless startTimeEl and endTimeEl
      startTime = parseFloat startTimeEl.value
      endTime = parseFloat endTimeEl.value
      if c
        drawWaveform c, startTime, endTime
      else
        alert "Please load an audio file first."

  drawWaveform = (buffer, start, end) ->
    canvas = document.getElementById "canvas"
    return unless canvas
    ctx = canvas.getContext "2d"
    return unless ctx
    
    width = canvas.width
    height = canvas.height
    sampleRate = buffer.sampleRate
    startSample = Math.floor start * sampleRate
    endSample = Math.floor end * sampleRate
    channelData = buffer.getChannelData(0).slice(startSample, endSample)

    ctx.clearRect 0, 0, width, height
    ctx.beginPath()
    ctx.strokeStyle = "#D6D6D6"
    
    samplesPerPixel = Math.ceil channelData.length / width
    midHeight = height / 2
    for x in [0...width]
      chunk = channelData.slice(x * samplesPerPixel, (x + 1) * samplesPerPixel)
      min = Math.min chunk...
      max = Math.max chunk...
      ctx.moveTo x, (1 + min) * midHeight
      ctx.lineTo x, (1 + max) * midHeight

    ctx.stroke()