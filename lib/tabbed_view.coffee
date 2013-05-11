class Swipe.TabbedView extends Swipe.View

  # This variable should be set for any views which inherit from this class.
  # It defines the text which should be displayed on the tab itself.
  tabText: null

  # A tabbed view will automatically insert tabs into the appropriate part
  # of the document when a view is opened or closed.
  onLoad: ->
    super
    title = this.tabText
    tabLink = $("<li class='tab'><a href='#' class='tab #{this.constructor.name.toLowerCase()} active' data-tab-id='#{this.id}'>#{title}<span>x</span></a></li>")
    $(tabLink).prependTo($('#tabLinks ul'))
    $('a', tabLink).on 'click', =>
      this.focus()
      false

    $('a span', tabLink).on 'click', =>
      this.unload()
      false

  onFocus: ->
    super
    $("#tabLinks ul li a[data-tab-id=#{this.id}]").addClass 'active'

  onBlur: ->
    super
    $("#tabLinks ul li a[data-tab-id=#{this.id}]").removeClass 'active'

  onUnload: ->
    super
    link = $("#tabLinks ul li a[data-tab-id=#{this.id}]").parents('li')
    nextLink = link.next('li.tab')
    nextLink = link.prev('li.tab') unless nextLink.length
    link.remove()
    if nextLink.length
      nextActualLink = $('a', nextLink).data('tab-id')
      Swipe.TabbedView.load(nextActualLink)
