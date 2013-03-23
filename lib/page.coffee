# This module provides methods which can be associated with the whole page.
# These are not specific to any view or layout. These are usually utility methods
# which the application will use to perform various actions such as setting the
# browser title or displaying confirmation dialogs.
Swipe.Page =
  
  # The default page title for the application
  defaultTitle: null

  # Set the browser's page title
  setTitle: (name)->
    $('head title').text(name + " - " + this.defaultTitle)
  
  # Set the browser title back to the default
  clearTitle: ->
    $('head title').text(this.defaultTitle)
  
  # Display a flash message for a short period of time
  flashMessage: (type, message, length)->
    template = "<section class='flash live #{type}'><p>#{message}</p></section>"
    notice = $(template).appendTo('body').show('fast')
    setTimeout ->
      notice.hide 'slow', ->
        notice.remove()
    , length || 5000
    true

  # Remove all flash messages from the page
  removeAllFlashMessages: ->
    $('section.flash').remove()

  # Display an alert dialog box. You can pass the options below to construct the
  # appropriate box and display it.
  #      title           - the title for the dialog
  #      text            - text which should be displayed (optional)
  #      html            - html to insert in dialog
  #      buttons         - an array of buttons which should be included (cancel will always exist)
  #      className       - a class to assign to the dialog
  alertBox: (options)->
    tpl = Swipe.getTemplate('alert_box', options)
    box = $($.parseHTML(tpl)).prependTo($('body'))
    if options.html
      $(options.html).insertAfter($('h2', box));

    if options.buttons
      $.each options.buttons, (i, button)->
        if button.default
          Mousetrap.bindGlobal 'enter', ->
            button.function(box)
            closeOverlay()

        box.find('ul.buttons li:eq('+(i + 1)+') button').data('click-function', button.function).data('button-id', i + 1);

    box.on 'click', 'ul.buttons li button', ->
      func = $(this).data('click-function')
      closeOverlay()
      func(box) if func

    addOverlay ->
      box.remove()
      Mousetrap.unbind('enter')

  # Display a confirmation dialog with a yes and cancel button
  confirmBox: (title, options, func)->
    if title.title?
      options.text = title.text
      title = title.title

    console.log options

    this.alertBox 
      title: title
      text: options.text
      buttons: [
        {label: options.buttonText || 'Continue', default: true, className: options.className, function: func}
      ]