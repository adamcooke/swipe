# This file contains all handlebar extensions which are used.
Handlebars.registerHelper 'pluralize', (number,single,plural)->
  if number == 1 then single else plural

Handlebars.registerHelper 'timeInWords', (time)->
  new Handlebars.SafeString(window.timeInWords(time))

Handlebars.registerHelper 'avatar', (md5,size)->
  new Handlebars.SafeString(window.avatar(md5, size))

Handlebars.registerHelper 'join', (array,sep)->
  sep = ' ' if !sep
  array.join(sep)

Handlebars.registerHelper 'downcase', (string)->
  (string || '').toLowerCase()

Handlebars.registerHelper 'urlEncode', (string)->
  encodeURIComponent(string || '')

Handlebars.registerHelper 'thousands', (number)->
  formattedNumber(number)

Handlebars.registerHelper 'searchPreview', (text)->
  text = htmlEscape(text)
  text = text.replace(/\{\{\{/g, "<mark>").replace(/\}\}\}/g, '</mark>')
  new Handlebars.SafeString(text)