class Swipe.ViewObject
  
  # This stores the DOM object which contains the view
  domObject: null
  
  # This method should be overriden in the individual view to define the initial
  # template content for the view
  template: -> ""
  
  # Loads the view object into the DOM and runs appropriate events.
  load: ->
    if this.domObject == null
      this.loadIntoDOM()
      this.constructor.bindBehaviours this
      this.onLoad()
      this.constructor.runBoundEvents 'load', this
      this.constructor.bindKeyboardShortcuts this
      true
    else
      false
  
  # Unloads the view object by removing it from the DOM and running any events
  # or callbacks as appropriate/
  unload: ->
    if this.domObject.length
      this.onUnload()
      this.constructor.unbindKeyboardShortcuts this
      this.constructor.runBoundEvents 'unload', this
      this.domObject.remove()
      true
    else
      false
  
  # Find and load data into the DOM as appropriate. By default, we don't do anything as 
  # expect our individual view types to handle this.
  loadIntoDOM: ->
    true
  
  # These methods can be overridden to add items to the load queue on a per layout basis
  onLoad:     -> true
  onUnload:   -> true
  
  # All views have an associated number of methods which can be added to them.
  # These can be added once the 
  @boundEvents = {}
  
  # Adds a new bind event to the given class
  @addBindEvent = (event, func)->
    @boundEvents[this.name]         ||= {}
    @boundEvents[this.name][event]  ||= new Array
    @boundEvents[this.name][event].push func
  
  # Execute some bind events for the given event
  @runBoundEvents = (event, object, otherArgs...)->
    return unless @boundEvents[this.name]
    return unless @boundEvents[this.name][event]
    $.each @boundEvents[this.name][event], (i,func) ->
      func.call(object, otherArgs...)
  
  # All view objects can have keyboard shortcuts which can be associated with their loading
  # and unloading. All keyboard shortcuts will be added when the view is loaded and remove 
  # when it is unloaded.
  @keyboardShortcuts = {}
  
  # Adds a new keyboard shortcut for this type of view
  @addKeyboardShortcut = (shortcut, options, func)->
    @keyboardShortcuts[this.name]   ||= []
    if shortcut? && func?
      @keyboardShortcuts[this.name].push {shortcut: shortcut, options: options, func: func}
  
  # Binds all keyboard shortcuts for the given view object.
  @bindKeyboardShortcuts = (object)->
    return false unless @keyboardShortcuts[this.name]
    $.each @keyboardShortcuts[this.name], (i,sc)->
      if sc.options.global
        Mousetrap.bindGlobal sc.shortcut, ->
          sc.func.call(object)
        , sc.options.type || 'keydown'
      else
        Mousetrap.bind sc.shortcut, ->
          sc.func.call(object)
        , sc.options.type || 'keydown'
  
  # Unbinds all keyboard shortcuts for the given view
  @unbindKeyboardShortcuts = (object)->
    return false unless @keyboardShortcuts[this.name]
    $.each @keyboardShortcuts[this.name], (i,sc)-> Mousetrap.unbind sc.shortcut
  
  # Stores all behaviours for the view
  @behaviours = {}
  
  # Stores a behaviour which should be assigned to the DOM when it's added for
  # this view.
  @addBehaviour = (event, selector, func)->
    @behaviours[this.name] ||= new Array
    @behaviours[this.name].push {event: event, selector: selector, func: func}
  
  # Add the behaviours to a given DOM object
  @bindBehaviours = (object)->
    return unless @behaviours[this.name]
    $.each @behaviours[this.name], (i, b)->
      $(object.domObject).on b.event, b.selector, ->
        b.func.call this, object
      