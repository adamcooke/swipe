# This module allows you to create and use Dialogs within your
# Swipe application with ease.
#
# Dialog's are available within all Swipe applications.
Swipe.Dialog =

  # Open's a new dialog with the given title and template. The dialog will
  # show the default title and the template in the middle of the page.
  # Additional options can be displayed if needed.
  #
  #   title           =>    the title for the dialog
  #   html            =>    the HTML for the dialog box
  #   template        =>    the name of a Swipe template which should be used.
  #   templateOptions =>    a dictionary of options to pass to the Swipe template.
  #   class_name      =>    a class name to add to the dialog
  #   beforeAdd       =>    a callback to execute before the dialog has been displayed
  #   beforeRemove    =>    a callback to execute before the dialog has been removed
  #   afterAdd        =>    a callback to execute after the dialog has been displayed
  #   afterRemove     =>    a callback to execute after the dialog has been removed
  new: (options={})->

    if options.template
      html = Swipe.getTemplate options.template, (options.templateOptions || {})
    else if options.html
      html = options.html
    else
      html = "<p>Undefined HTML!</p>"

    dialogTemplate = $("<div class='swipeDialog'><div class='title'><h2>#{options.title}</h2></div><div class='content'>#{html}</div></div>")
    dialog = dialogTemplate.appendTo($('body'))
    if options.width?
      dialog.css('width', options.width + 'px')
      dialog.css('margin-left', "-#{options.width / 2}px")
    dialog.addClass options.class_name if options.class_name?

    options.beforeAdd.call(dialog, options) if options.beforeAdd?
    dialog.show()

    overlay = addOverlay ->
      options.beforeRemove.call(dialog, options) if options.beforeRemove?
      dialog.remove()
      options.afterRemove.call(dialog, options) if options.afterRemove?
    overlay.addClass 'withDialog'
    options.afterAdd.call(dialog, options) if options.afterAdd?
