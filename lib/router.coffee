Swipe.Router =
  
  # Stores all routes which are available for the application
  routes: new Array
  
  # Adds a new route
  add: (name, match, func)->
    regex = "^#{match}$"
    keys = new Array
    regex = regex.replace /\//g, '\\/'
    regex = regex.replace /\:(\w+)/g, ->
      keys.push(arguments[0].replace(/^\:/, ''))
      '([\\w\\-\\=\\&]+)'
    this.routes.push {name: name, keys: keys, regex: new RegExp(regex), match: match, func: func}
  
  # Perform routing to the given URL
  routeTo: (url)->
    url = url.replace(/^\#/, '')
    console.log "Attempting to route to #{url}"
    $.each this.routes, (ri, route)->
      if matches = url.match(route.regex)
        console.log "Routing to: #{url} (#{route.name || 'unnamed'} route)"
        if route.keys
          params = {}
          $.each route.keys, (ki, param)->
            value = matches[ki+1]
            value = jQuery.unparam(value) if value.indexOf('=') >= 0
            params[param] = value
          route.func.call(params)
        else
          route.func(matches...)
        true
    true
  
  # Generate a URL for a given route and params hash
  linkTo: (name, params)->
    route = this.routes.filter (r)-> r.name == name
    route = route[0]
    if route
      url = route.match
      for key of params
        value = params[key]
        value = jQuery.param(value) if typeof(value) == 'object'
        url = url.replace(":#{key}", value)
      url
    else
      false
  
  # Accepts a path and send the application to it.
  goTo: (name, params)->
    url = this.linkTo(name, params)
    document.location.hash = url
  
  # Return's the current URL
  currentURL: ->
    document.location.hash.replace(/^\#/, '')
  
  # Starting monitoring the application for changes to the URL which should
  # be dispatched to the application
  start: ->
    window.onhashchange = => this.routeTo(window.location.hash)
  
  # Stop monitoring requests
  stop: ->
    window.onhashchange = null
  
  # Sets the URL for a page without invoking any routing
  setURL: (newURL)->
    this.stop
    document.location.hash = newURL
    this.start
    