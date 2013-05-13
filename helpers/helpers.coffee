# Add an overlay to the page
window.addOverlay = (closeAction) ->
  overlay = $('<div class="overlay"></div>').appendTo('body').mousedown(closeOverlay)
  overlay.data('close-action', closeAction);

# Closes the upper most overlay
window.closeOverlay = ->
  overlay = $('div.overlay:last')
  if warning = overlay.data('closure-warning')
    unless confirm(warning)
      return false
  closeAction = overlay.data('close-action')
  closeAction() if closeAction
  overlay.remove()
  
# Escape a given string so that it can be safely displayed
htmlEntitySafeMap = {"&": "&amp;", "<": "&lt;", ">": "&gt;", '"': '&quot;', "'": '&#39;', "/": '&#x2F;'}
window.htmlEscape = (string) ->
  string.replace /[&<>"']/g, (t)->
    htmlEntitySafeMap[t]

# Construct a URL by adding appropriate items
window.constructUrl = ->
  parts = $.makeArray(arguments)
  parts = parts.map (param)->
    if typeof(param) == 'object'
      param = $.param(param)
      if param.length then param else null
    else
      param
  parts.filter(Boolean).join('/')

# Return an appropriate time string
window.timeInWords = (time)->
  outputString = ''
  momentObj = moment(time)
  if momentObj.isBefore(moment().subtract('days', 2))
    outputString += 'on '
    outputString += momentObj.format('Do MMM')
    outputString += ' at '
    outputString += momentObj.format('h:mma')
  else
    outputString = momentObj.fromNow()
  "<time datetime='#{time}'>#{outputString}</time>"

# Pop a thousand seperator into a number string
window.formattedNumber = (number)->
  number.toFixed().split("").reverse().join("").replace(/(...)(?=.)/g, '$1,').split("").reverse().join("")

# Returns an avatar tag for the given URL and size.
window.avatar = (url, size) ->
  if url && url.length
    "<span style='background-size:#{size}px;width:#{size}px;height:#{size}px;background-image:url(" + url.replace('{{size}}', size * 2) + ")' class='avatar'></span>"
  else
    ""

window.tryUntil = (testFunction, func)->
  if testFunction() == true
    func()
  else
    setTimeout ->
      tryUntil testFunction, func
    , 500
