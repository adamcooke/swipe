Swipe.Store =

  # Retreive a value from the local storage
  get: (key)->
    value = window.localStorage.getItem(key)
    if value && value.charAt(0) == '{' && value.charAt(value.length - 1) == '}'
      JSON.parse(value)
    else
      value

  # Place a value into local storage
  put: (key,value)->
    if typeof value == 'object'
      value = JSON.stringify(value)
    window.localStorage.setItem(key, value)
    value

  # Remove a value from the local storage
  delete: (key)->
    window.localStorage.removeItem(key)
    true
