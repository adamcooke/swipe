Swipe =

  # This method will be invoked when the application starts and will
  # handle the application startup. This is what kicks things off and
  # will be started when the DOM has fully loaded.
  init: (options)->

    # Store the optiosn
    this.options = options if options

    # If there's an I18n dictionary
    this.globalHBVars.i18n = Swipe.I18n

    # Run the application's initialization
    this.initializeAppFunc.call(this.App) if this.initializeAppFunc

    # Monitor the hash for changes and send changes to the router for
    # opening as appropriate.
    Swipe.Router.start()

  # This method stores any application wide options.
  options: {}

  # Get a template and return it's raw body as appropriate
  getTemplate: (name, vars)->
    source = $("script#tpl-#{name}").html()
    template = Handlebars.compile(source)
    allVars = jQuery.extend(vars, this.globalHBVars)
    template(allVars)

  # This variable conatins the applications' startup function. It should
  # be configured in the applciation and will be run when the application
  # starts.
  initializeApp: (func)-> this.initializeAppFunc = func

  # Stores global variables which may be needed in the application.
  # In most cases this should store classes which are app specific (views)
  App: {}

  # Stores an array of global Handlebars variables which should be included
  globalHBVars: {}

  # The name of the class where all views are stored
  viewContainer: '#views'

  # Stores the current layout for the application
  currentLayout: null

# Provide global access to the stripe framework as both S and Swipe.
window.S = window.Swipe = Swipe