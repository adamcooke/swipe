# Allow forms to be serialized into objects
$.fn.serializeObject = ->
  o = {}
  a = this.serializeArray()
  $.each a, ->
    if o[this.name] != undefined
      if !o[this.name].push
        o[this.name] = [o[this.name]];
      o[this.name].push(this.value || '');
    else
      o[this.name] = this.value || '';
  o

$.unparam = (value)->
  # Object that holds names => values.
  params = {}
  # Get query string pieces (separated by &)
  pieces = value.split('&')
  # Loop through query string pieces and assign params.
  for l, i in pieces
    pair = pieces[i].split('=', 2);
    # Repeated parameters with the same name are overwritten. Parameters
    # with no value get set to boolean true.
    params[decodeURIComponent(pair[0])] = if pair.length == 2 then decodeURIComponent(pair[1].replace(/\+/g, ' ')) else true

  params
