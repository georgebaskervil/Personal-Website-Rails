import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

export default class extends Controller
  connect: ->
    @$el = $(@element)
    @highlightCurrentPage()

  highlightCurrentPage: ->
    currentPath = window.location.pathname
    @$el.find('a').each (index, element) =>
      $element = $(element)
      href = $element.attr('href')
      
      # Remove any existing 'text-accent' class before checking
      $element.removeClass('text-accent')
      
      # Check if the href matches the current path exactly or starts with it followed by a slash
      if @isCurrentPath(href, currentPath)
        $element.addClass('text-accent')

  # Helper method to check if the href matches or starts with the current path
  isCurrentPath: (href, currentPath) ->
    # Normalize paths by removing leading/trailing slashes for exact comparison
    href = href.replace(/^\/|\/$/g, '')
    currentPath = currentPath.replace(/^\/|\/$/g, '')
    
    # Check for exact match or if currentPath starts with href followed by a slash
    href == currentPath || currentPath.startsWith(href + '/')

  disconnect: ->
    # No cleanup needed