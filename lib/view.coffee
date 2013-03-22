class Swipe.View extends Swipe.ViewObject
  
  # Each view has an ID which is used to determine whether or not the
  # view is already present in the "stack" or not. This will be determined
  # automatically or can be passed when initializing the view.
  id: null
  
  # This parameter will store the URL associated with this view. It will be
  # taken automatically from the current URL when the view is *loaded* and
  # replaced into the URL when the view is brought back into focus.
  url: null
  
  # Create a new view container and insert the view's template into it.
  loadIntoDOM: ->
    this.domObject = $("<div id='view-#{this.id}' class='stripeView'></div>").appendTo $(Swipe.viewContainer)
    this.domObject.html this.template()
  
  # When loading a view, all visible views should be hidden.
  onLoad: ->
    this.url = Swipe.Router.currentURL()
    this.constructor.blurAll()
  
  # When a view is unloaded, remove it from the stack's array and invoke the
  # blur method.
  onUnload: ->
    this.blur()
    index = this.constructor.stack.indexOf(this)
    this.constructor.stack.splice(index, 1) if index >= 0

  # This will pull this view into focus. If any other views are shown, they will
  # be blurred (not removed).
  focus: ->
    if this.domObject.is ':hidden'
      this.constructor.blurAll()
      this.domObject.show()
      Swipe.Page.setURL(this.url)
      this.onFocus()
      this.constructor.runBoundEvents 'focus', this
      this.constructor.bindKeyboardShortcuts this
      true
    else
      false

  # This will blur/hide this view. It will no longer be visible but will exist within
  # the DOM and can be re-opened at anytime using focus.
  blur: ->
    if this.domObject.is ':visible'
      this.domObject.hide()
      this.onBlur()
      this.constructor.runBoundEvents 'blur', this
      this.constructor.unbindKeyboardShortcuts this
      
      if Swipe.Router.currentURL() == this.url
        Swipe.Router.goTo('default')
      true
    else
      false

  # Various methods which can be overridden by views to insert into the
  onFocus:    -> true
  onBlur:     -> true
  
  # Update the URL for the current filter, if the filter is visible, update the URL too
  # without invoking any callbacks
  updateURL: (newURL)->
    if this.domObject.is ':visible'
      Swipe.Router.setURL newURL
    this.url = newURL
  
  # This object will load a new class and return the new view after adding it
  # to the stack. All views (regardless of class) are in the same stack.
  @stack = new Array
  
  # Initializes a new view and runs the load method to get thigns started. It 
  # must be passed the ID for the view. It will also run a given function before
  # the load method is executed.
  #
  # If the function passed to this method exists, the method will be passed the view 
  # as well as a function which you must remember to execute when you are finished.
  @load = (id, func)->
    if Swipe.currentLayout && $('body div#views').length
      if Swipe.currentLayout.viewReady
        existingView = @stack.filter (v)-> v.id == id
        if existingView.length
          existingView[0].focus()
          existingView[0]
        else
          view = new this
          view.id = id
          
          completeFunction = ->
            view.load()
            Swipe.View.stack.push view
          
          if func
            func.call(view, completeFunction)
          else
            completeFunction.call()

          view
      else
        setTimeout =>
          @load.call(this, id, func)
        , 200
        console.log 'layout is not ready to accept views. trying again in a moment'
    else
      console.log "no views can be displayed in the given template. not loading view."
      
  # This method will hide all views in the view container
  @blurAll = ->
    $.each this.stack, (i, view)-> view.blur(); true
      
  # This method will unload all views which are loaded
  @unloadAll = ->
    while this.stack.length
      this.stack[0].unload()
      
  