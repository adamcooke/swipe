# Swipe - A CoffeeScript App Framework

Swipe is a simple javascript  framework which allows for easy development
of a HTML5 application. You must be using CoffeeScript to develop with Swipe
otherwise your life will be pretty bad.

Before we get started, this is **not** designed to be very complicated and
really should not be compared to other JS frameworks like Ember or Backbone.
It has been developed for use in the development of our own applications 
which follow our own design pattern. If you like it, great - feel free to use
it. If you don't, that's fair enough, there are plenty of other great frameworks
out there for you to look at it.

**If you prefer to jump right in, I would recommend taking a look at the examples
in this repo. The example 'app.coffee' and 'index.html' are well commented and
show how to get up and running quite easily.**

Please also note, we are still working on this and it will be developed constantly
over the next few months and should not be considered stable or feature-locked.

Now, onwards with some theory... 

## Layouts

A layout is an HTML document which includes an area for views to be inserted
within. You should define a default layout class within the Swipe.App namespace
as shown below. 

```coffee
class Swipe.App.DefaultLayout extends Swipe.Layout
  
  # Specify the default template for the layout
  template: -> Swipe.getTemplate('default-layout')
```

When using the `Swipe.getTemplate(name, vars)` method, it will automatically return
an HTML string which can been found by looking for a `<script>` object with the ID
`tpl-#{name}`. All templates will be passed through Handlebars and the vars passed
to the `getTemplate` method will be available.

Layouts will be loaded directly into the `<body>` of the page so your template should
reflect this positioning. An example HTML layout may look like the code below. In
all cases a layout should define an object with the ID `views`. This is where your
views will be stacked.

```html
<header>
  <h1>My Website</h1>
</header>
<div id='views'></div>
<footer>
  <p>&copy; My Website 2013</p>
</footer>
```

When a layout is inserted into the page, it will be wrapped within in a `<div>` object.
This tag will have and ID of `swipeLayout` and only one can be present at a time.

If a new layout is loaded into your application, any existing layout along with it's 
view stack will be removed.

### Loading a layout

In order to load a layout into your page, you need to load it. Loading a layout is
usually one of the first things which happens in the application and occurs in your
main `application.coffee` file.

```coffee
Swipe.initializeApp ()->
  # Load the default layout for the application
  Swipe.App.DefaultLayout.load()
```

If you want to change layout within your application, you can do so by just loading in
your other layout. This will do everything needed to unload any existing layout and load
your new layout.

```coffee
Swipe.App.LoginLayout.load()
```

## Views

A view is a page which is displayed within your layout. They function in a similar 
way to layouts and each view has it's own class.

Unlike layouts, you can insert as many views into your page as you wish. Each view 
has a unique ID which identifies it within your page's view stack.

```coffee
class Swipe.App.TicketView extends Swipe.View

  # Specify the default template for the view
  template: -> Swipe.getTemplate('ticket-view')
  
```

To display a view in your page, you need to load it in a similar way to layouts. 
You will call it's `load` method and pass an ID (as a string) and an, optional, 
function to execute when the tab has been loaded

```coffee
Swipe.App.TicketView.load id, (completeFunction)->
  this.properties             = {}
  this.properties.subject     = "My Example Ticket Subject"
  this.properties.reference   = "AB-123123"
  completeFunction.call()
```

If a view with the provided ID does not exist on your view stack, it will be loaded
otherwise the view will be initialized and inserted onto the stack.

If you pass a function to the `load` method, this will be executed before the view
is added to the stack and displayed to the user. You can use this method to load
data from an external source, if needed. However, it is important to remember to
execute the passed `completeFunction` otherwise the view loading will not complete
and the view will not be inserted into your stack.

## Routing

Swipe includes a routing engine which allows you to convert a URL into a view. For
example, you may wish to route `tickets/AB-123123` to your TicketView and `contact/1`
to a ContactView. Any changes to the URL will cause the router to trigger it's associated
method. 

```coffee
Swipe.Router.add 'ticket', '/ticket/:ref', ->
  Swipe.App.TicketView.loadFromReference this.ref

Swipe.Router.add 'contact', '/contact/:id', ->
  Swipe.App.ContactView.loadFromId this.id
```

You will notice that we have used a `loadFromReference` and `loadFromId` method. These
are not part of the framework and are often configured on the View object to assist
with loading external resources. Essentially, they are just methods which call the
`load` method we talked about earlier.

All views remember the URL they were open with and if a view is brought back into focus,
the URL will be updated automatically.

There are a number of other methods on the router which may be helpful:

```coffee
Swipe.Router.linkTo 'ticket', {ref: 'AB-123123'}    #=> '/ticket/AB-123123'
Swipe.Router.goTo 'ticket', {ref: 'AB-123123'}      #=> executes the matched route
Swipe.Router.currentURL()                           #=> '/contact/1'
```

## The Store

Storing preferences & user data locally is made easy using the `Swipe.Store` object.
This provides an interface to the HTML5 Local Storage API.

```coffee
Swipe.Store.put 'hello', 'world'      #=> 'world'
Swipe.Store.get 'hello'               #=> 'world'
Swipe.Store.delete 'hello'            #=> true
```

## Bundled Utilities

Swipe is bundled with a number of external/3rd party utilities which are useful in
pretty much every application.

* jQuery - required for Swipe operation
* Handlebars - used for tempting
* Moment.js - time library
* Mousetrap - keyboard shortcuts
* MD5 - generating MD5 hashes from strings

## Application Structure

A Swipe application is designed to run from a single HTML page. During the 
development of the application Swipe suggests a directory layout which is 
optimised for ease of use. The following is an example application structure
for a complete app.

```
css
img
js
js/layout
js/vendor
js/views
templates
```

Within your application, there are a number of different suggested files. Which
should exist:

```
js/application.coffee
js/i18n.coffee
js/layout/default.coffee
js/routes.coffee
```

If you use this structure, you should compile it together into a single file before
production use.
