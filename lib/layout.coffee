# Layouts allow you to change the page layout. A layout contains a full
# document. Switching layouts will cause the full view stack to be erased
# so you should bear this in mind. Only one layout may be "loaded" at a time.
#
# By default, a layout called "Swipe.App.DefaultLayout" will be loaded.
class Swipe.Layout extends Swipe.ViewObject

  # By default, views can always been inserted into a layout. This can be disabled
  # to delay adding of views until the layout is fully set up.
  viewReady: true

  load: ->
    if super
      Swipe.View.unloadAll()
      Swipe.Router.routeTo(document.location.hash)
    true

  unload: ->
    if super
      Swipe.View.unloadAll()
      this.onUnload()
    true

  loadIntoDOM: ->
    this.domObject = $("<div id='swipeLayout'>#{this.template()}</div>").appendTo 'body'


  # Loads a new template into the DOM
  @load: ->
    Swipe.currentLayout.unload() if Swipe.currentLayout
    Swipe.currentLayout = new this
    Swipe.currentLayout.load()
