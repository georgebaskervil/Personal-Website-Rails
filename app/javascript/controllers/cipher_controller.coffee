import { Controller } from "@hotwired/stimulus"

export default class extends Controller
  @targets = ["input", "output", "mode", "modeDisplay", "cipherGrid"]
  @values = { currentMode: String }

  connect: ->
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @reverseGrid = null  # Cache for the reverse cipher grid
    @setupGrid()
    @currentMode = "decrypt"
    @updateModeDisplay()
    @addCellListeners()

  setupGrid: ->
    @cipherGrid = {}
    @alphabet.split('').forEach (letter) =>
      @cipherGrid[letter] = '*'
    @updateGrid()

  _shuffle: (array) ->
    for i in [array.length - 1..1]
      j = Math.floor(Math.random() * (i + 1))
      [array[i], array[j]] = [array[j], array[i]]
    array

  addCellListeners: ->
    @cipherGridTarget.querySelectorAll('.cipher-cell').forEach (cell) =>
      cell.addEventListener 'click', (e) => @handleCellClick(e)

  handleCellClick: (event) ->
    letter = event.currentTarget.dataset.letter
    newMapping = prompt("Enter substitution for #{letter} (or * to clear):")
    if newMapping?.length == 1 && newMapping.match(/[A-Z\*]/i)
      if @isValidMapping(letter, newMapping.toUpperCase())
        @cipherGrid[letter] = newMapping.toUpperCase()
        @processText()
        @updateGrid()

  isValidMapping: (letter, mapping) ->
    return true if mapping == '*'
    return false if mapping == letter
    !Object.values(@cipherGrid).includes(mapping)

  updateGrid: ->
    # Invalidate the cached reverse grid each time the cipher grid is modified.
    @reverseGrid = null
    @cipherGridTarget.querySelectorAll('.cipher-cell').forEach (cell) =>
      letter = cell.dataset.letter
      mapping = @cipherGrid[letter]
      cell.innerHTML = letter + (if mapping != '*' then " → " + mapping else "")
      cell.classList.toggle('mapped', mapping != '*')

  toggleMode: ->
    @currentMode = if @currentMode == "encrypt" then "decrypt" else "encrypt"
    @updateModeDisplay()
    @processText()

  updateModeDisplay: ->
    @modeDisplayTarget.textContent = @currentMode

  processText: ->
    return unless @inputTarget.value
    input = @inputTarget.value.toUpperCase()
    @outputTarget.innerHTML = if @currentMode == "encrypt"
      @encrypt(input)
    else
      @decrypt(input)

  encrypt: (text) ->
    result = ''
    for char in text
      if @cipherGrid[char] and @cipherGrid[char] isnt '*'
        result += @cipherGrid[char]
      else
        result += char
    result

  decrypt: (text) ->
    # Cache the reverse lookup mapping for efficiency.
    if not @reverseGrid?
      @reverseGrid = {}
      for [plain, cipher] in Object.entries(@cipherGrid)
        if cipher isnt '*'
          @reverseGrid[cipher] = plain

    result = ''
    for char in text
      if @reverseGrid[char]
        result += @reverseGrid[char]
      else
        result += char
    result

  randomize: ->
    available = @alphabet.split('')
    @alphabet.split('').forEach (letter) =>
      if available.length > 0
        idx = Math.floor(Math.random() * available.length)
        @cipherGrid[letter] = available.splice(idx, 1)[0]
    @updateGrid()
    @processText()

  clear: ->
    @setupGrid()
    @processText()