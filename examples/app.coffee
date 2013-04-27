# Welcome to our little Swipe example application. Everything here is in
# one file. We recommend splitting things up to ensure it's easier to developer
# larger applications.
#
# I recommend reading this file in conjunction with it's companion 'index.html'
# file which is in this directory.
#
# For this example, we will be creating an address book. Just a way to list
# and view contact details. There is no external servi

# This array will be our data source for the app. However, there's no reason
# your application isn't able to talk to a remote AJAX source if needed.
window.AddressBook = [
  {name: 'Adam Cooke', twitter: 'adamcooke', biog: 'Adam is amazing.'}, 
  {name: 'Dan Quinney', twitter: 'danquinney', biog: 'Dan is amazing.'}, 
  {name: 'Charlie Smurthwaite', twitter: 'catphish', biog: 'Charlie is amazing.'}
]

# Firstly, we will define our main layout and point it our 'layout' template.
# This layout will be present throughout our application. In here, it just 
# provides us with a standard header & footer.
class Swipe.App.DefaultLayout extends Swipe.Layout
  template: -> Swipe.getTemplate 'layout'

# Our address book will include a list of contacts and a page with more
# information about a contact. We will now define these two views which 
# will be used in the app.

# Our list view will point to our 'list' template and provide the template
# with full access to the data source we created earlier.
class Swipe.App.ListView extends Swipe.View
  template: -> Swipe.getTemplate 'list', {contacts: window.AddressBook}
  pageTitle: 'Contacts'

# Our Contact view will point to 'contact' tempate and provide access to a
# 'contact' variable which will contain the contact's properties (name, etc...)
class Swipe.App.ContactView extends Swipe.View
  viewContainer: '#contact'
  template: -> Swipe.getTemplate 'contact', {contact: this.properties}
  
  # Rather than using the built in 'load' method directly from our router, 
  # we are creating a method which allows contacts to be loaded based on
  # their Twitter name. This method accepts the twitter name, looks up
  # the contact from our data source and then proceeds to load the view.
  @loadFromTwitterName = (name)->
    
    # Look up our contact from the data source
    contact = window.AddressBook.filter (c)-> c.twitter == name
    contact = contact[0]
    if contact
      # If a contact was found, proceed to load the new view using an MD5'd
      # twitter name and a prefix. 
      this.load "contact-#{md5(name)}", (completeFunction)->
        # We will set the 'properties' variable to the details of the contact
        # found earlier.
        this.properties = contact
        # Set the page title
        this.setPageTitle contact.name
        # As required, we now complete the loading by calling the passed
        # completeFunction.
        completeFunction.call()
    else
      # If no contact is found, we will display a standard javascript alert box
      # and redirect back to the default route (list page).
      alert 'No contact found!'
      Swipe.Router.goTo 'default'
  
  # This method will set the contact's name to a random colour by updating the
  # DOM as appropriate. This doesn't really serve any practical purpose but we
  # are using it to illustrate lifecycle hooks next.
  #
  # Note the use of 'this.domObject'. Any changes you make to the document must
  # be scoped within this object otherwise you may make changes to a hidden view
  # as well as your visible view.
  setNameToRandomColour: ->
    colours = ['red', 'blue', 'green', 'orange', 'purple', 'yellow']
    $('h3', this.domObject).css('color', colours[Math.floor(Math.random() * colours.length)])
  
  # This next method illustrates how you can hook into the view's lifecycle. 
  # When the contact is first loaded, we are going to set the name of the contact
  # to a random colour.
  this.addBindEvent 'load', -> this.setNameToRandomColour()
  
  # We will now illustrae keyboard shortcuts. We will create a keyboard shortcut
  # that means that whenver you press 't', it will enlarge the contact's name each
  # time it is pressed
  this.addKeyboardShortcut 't', {}, ->
    name = $ 'h3', this.domObject
    currentSize = parseInt(name.css('font-size'))
    return true if currentSize > 60
    name.css 'font-size', currentSize + 2
  
  # We will now demonstrate the ability to bind events to objects inserted 
  # into the page. This will setup a behaviour which means that whenever a 
  # contact's name is clicked on it will display an alert message.
  this.addBehaviour 'click', 'h3', (view)->
    alert "This contact's name is #{view.properties.name}"

# Now, we need to be able to route to our newly defined views from the browser.
# We can always load our list views using the console however this isn't really
# practical. The router will convert the URL hash into a view and load it for you.

# The 'default' route is the route which is called when there is no location hash
# or the location hash is '#' or '#/'. In our case, we will load up the list view.
Swipe.Router.add 'default', '', ->
  Swipe.App.ListView.load('list')

# The 'contact' route will open up a specific contact's view. In this instance,
# we use the ':twitter' token to identify a variable in our URL. These params
# can be accessed as 'this' within the route function (as shown with 'this.twitter'
# below). Note that this route uses the 'loadFromTwitterName' function we made 
# earlier in our Contact View.
Swipe.Router.add 'contact', '/contact/:twitter', ->
  Swipe.App.ListView.load('list')
  Swipe.App.ContactView.loadFromTwitterName(this.twitter)

# We're nealry done now. We now need to say what should happen when the application
# starts in the browser. We will call the 'Swipe.initializeApp' which accepts
# a function to execute on startup. This code will only be executed once in your
# application lifecycle. 
#
# Here, we will simply request that the 'DefaultLayout' is loaded when the DOM
# is ready. Loading a layout will also trigger the router to find and load an
# approprite view based on your current location hash.
Swipe.initializeApp ->
  $(document).ready =>
    Swipe.Page.defaultTitle = 'Twitter Address Book'
    Swipe.App.DefaultLayout.load()

# We're done! Let's start her up and watch our address book spring into life.
# This function must be called otherwise your application won't start and
# everything you've just done will have been in vain.
Swipe.init()
