import { Controller } from "@hotwired/stimulus"
import { get, patch } from "@rails/request.js"

export default class extends Controller

  @values =
    key: String

  connect: ->
    @mutationObserver = new MutationObserver(@mutateState.bind(@))
    @mutationObserver.observe @element, { attributes: true }

  disconnect: ->
    @mutationObserver?.disconnect()

  mutateState: (mutationList, observer) ->
    mutationList
      .filter (mutation) -> mutation.attributeName isnt "data-solder-touch"
      .forEach async (mutation) =>
        body = new FormData()
        attributes = {}
        @element
          .getAttributeNames()
          .filter (name) -> name isnt "data-controller"
          .map (name) ->
            attributes[name] = @element.getAttribute(name)

        body.append "key", @keyValue
        body.append "attributes", JSON.stringify(attributes)

        await patch "/solder/ui_state/update",
          body
