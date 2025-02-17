import { Controller } from "@hotwired/stimulus"
import { Wllama, LoggerWithoutDebug } from "@wllama/wllama/esm/index.js"
import multiThreadWllama from "@wllama/wllama/esm/multi-thread/wllama.wasm?url"
import singleThreadWllama from "@wllama/wllama/esm/single-thread/wllama.wasm?url"
# import part1 from "~/llms/browserdeepseek-00001-of-00004.gguf"
# import part2 from "~/llms/browserdeepseek-00002-of-00004.gguf"
# import part3 from "~/llms/browserdeepseek-00003-of-00004.gguf"
# import part4 from "~/llms/browserdeepseek-00004-of-00004.gguf"

export default class extends Controller
  @targets = ["userInput", "chatDisplay"]

  connect: ->
    # Toggle this flag to enable or disable Wllama initialization
    @wllamaFeatureEnabled = true

    @messages = [
      { role: "system", content: "You are a helpful assistant." }
    ]
    document.addEventListener "distractionmode:toggle", @handleDistractionMode.bind(@)

  disconnect: ->
    document.removeEventListener "distractionmode:toggle", @handleDistractionMode.bind(@)

  handleDistractionMode: ->
    unless @wllamaFeatureEnabled
      console.log "Wllama feature is disabled."
      return
    @initWllama()

  initWllama: ->
    fullPart1Url = new URL(part1, window.location.origin).href
    fullPart2Url = new URL(part2, window.location.origin).href
    fullPart3Url = new URL(part3, window.location.origin).href
    fullPart4Url = new URL(part4, window.location.origin).href

    @instance = new Wllama(
      {
        "single-thread/wllama.wasm": singleThreadWllama,
        "multi-thread/wllama.wasm": multiThreadWllama
      },
      {
        parallelDownloads: 4,
        logger: LoggerWithoutDebug,
      },
    )
    @instance.loadModelFromUrl(fullPart1Url, fullPart2Url, fullPart3Url, fullPart4Url,
      {
        n_ctx: 1024,
      }
    )

  sendMessage: (ev) ->
    ev.preventDefault()
    userContent = @userInputTarget.value.trim()
    return unless userContent.length > 0

    @messages.push({ role: "user", content: userContent })
    @userInputTarget.value = ""

    @instance.createChatCompletion(@messages,
      nPredict: 500,
      sampling:
        temp: 0.7
        top_p: 0.9
        top_k: 40
    ).then (reply) =>
      @messages.push({ role: "assistant", content: reply })
      @renderChat(reply)

  transformChatMLToHTML = (chatml) ->
    # Example: turn <think> tags into .thinking-message divs, etc.
    chatml
      .replace(/<think>/g, '<div class="thinking-message">')
      .replace(/<\/think>/g, '</div>')
      .replace(/<assistant>/g, '<div class="assistant-message">')
      .replace(/<\/assistant>/g, '</div>')
      .replace(/<user>/g, '<div class="user-message">')
      .replace(/<\/user>/g, '</div>')

  renderChat: (assistantReply) ->
    htmlContent = transformChatMLToHTML(assistantReply)
    @chatDisplayTarget.insertAdjacentHTML("beforeend", htmlContent)