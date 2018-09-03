---
layout: post
title: "Adding Real-Time To Rails With Socket.IO, Node.js and Backbone.js (With Demo) - Liam Kaufman"
date: 2013-09-24 23:18
categories: [swaac]
tags: [socket.io, node-js, backbone-js, rails, real-time]
source: http://liamkaufman.com/blog/2012/02/25/adding_real-time_to_rails_with_socket.IO_nodejs_and_backbonejs_with_demo/
---
A repost of <{{page.source}}> by [Liam Kaufman](http://liamkaufman.com/blog).



> Adding Real-Time to Rails With Socket.IO, Node.js and Backbone.js (With Demo) {.entry-title}
> =============================================================================
> 
> Feb 25th, 2012
> 
> [![](/images/chatty-screen.png)](http://node-chatty.herokuapp.com/chatty)
> 
> UPDATE: see my [new article on adding real-time to your Rails
> application](/blog/2013/02/27/adding-real-time-to-a-restful-rails-app/).
> 
> Despite the [recent distaste for
> Rails](http://gilesbowkett.blogspot.in/2012/02/rails-went-off-rails-why-im-rebuilding.html),
> I still think its a nice framework for developing websites (e.g. devise
> & active record). However, if you want real-time communication Socket.IO
> and Node.js seem to be the best options. If you already have an existing
> Rails application porting the entire application to Node.js is likely
> not on option. Fortunately, it is relatively easy to use Rails to serve
> your client-side Socket.IO web application, while Node.js and Socket.IO
> are used for real-time communication. The primary goal of this article
> is to show one method of integrating a real-time application, that is
> slightly more complex than a todo app, with Rails. Thus, I created
> Chatty, a simple chat room web application that allows a user to see all
> the messages in the chat room, or filter the messages by user.
> [Twitter’s Bootstrap](http://twitter.github.com/bootstrap/index.html)
> was used for the CSS and modal dialogue.
> 
> [Code on Github](https://github.com/liamks/Chatty)
> 
> Rather than explain the code step-by-step, I’ll provide a high level
> overview of:
> 
> -   File organization
> -   JavaScript Templates and EJS
> -   Application Archicture and Publish/Subscribe
> -   Module Architecture
> -   Deploying to Heroku
> 
> File Organization
> -----------------
> 
> The entire client-side Backbone.js application is within
> `app/assets/javascripts`. Using a JavaScript manifest file
> (`backboneApp.js`) all of the application’s JavaScript files are
> specified.
> 
> Manifest file (app/assets/javasripts/bacboneApp.js)
> 
> 
>     //= require jquery
>     //= require bootstrap
>     //= require underscore
>     //= require backbone
>     //= require socket.io
>     //= require app
> 
> The Backbone application is within the `app` folder, which also has a
> manifest file. The manifest files describe all the JavaScript files that
> comprise the application. Within the application’s html file only a
> single line of code is needed to include the manifest file:
> `=javascript_include_tag "backboneApp"` (haml for templating). The
> actual organization of the files is as follows:
> 
> app/assets
> 
> 
>     javascripts
>     ├── app
>     │   ├── index.js
>     │   ├── launch.js.coffee
>     │   ├── main.js.coffee
>     │   ├── modules
>     │   │   ├── index.js
>     │   │   ├── loadModule.js.coffee
>     │   │   ├── messageModule.js.coffee
>     │   │   ├── socketModule.js.coffee
>     │   │   └── userModule.js.coffee
>     │   └── templates
>     │       ├── message.jst.ejs
>     │       ├── modal.jst.ejs
>     │       └── user.jst.ejs
>     ├── application.js
>     ├── backboneApp.js
>     └── backbone_app.js.coffee
> 
> `main.js.coffee` is where the app object is defined, while
> \`launch.js.coffee\` is called last, after all the files have loaded, to
> launch the Backbone.js application. Each module, which might contain
> models, collections and views, are stored within the modules folder. The
> module structure was modelled after [Backbone
> Boilerplate](http://tbranyen.github.com/backbone-boilerplate/).
> 
> JavaScript Templates and EJS
> ----------------------------
> 
> To take full advantage of the asset pipeline it seems as if Sam
> Stephenson’s excellent [EJS
> Gem](https://github.com/sstephenson/ruby-ejs) was the most hassle free
> approach for JavaScript templates. Both the ‘ejs’ and ‘jst’ extensions
> are require for the EJS gem to compile the template, and include it
> within a JavaScript file. Access to the template is done with the global
> `JST` object.
> 
> Application Architecture - Publish/Subscribe
> --------------------------------------------
> 
> Before creating the application I decided to forgo the use of
> asynchronous module definition (AMD) and use a publish/subscribe
> (pub/sub) architecture ([see Addy Osmani’s description of
> Pub/Sub](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#detailedobserver)).
> Specifically, each module is wrapped in an [immediately-invoked function
> expression](http://benalman.com/news/2010/11/immediately-invoked-function-expression/),
> and within each module functions can attach themselves to events
> (subscribe), or trigger events (publish). Using this approach the
> applcation’s only global variable is `app` which contains a copy of
> Backbone’s event object.
> 
> To reiterate none of the modules call methods from other modules, all
> communication occurs with pub/sub. This design pattern was a pleasure to
> use; adding new functionality often required simply subscribing to
> events! I found that my code stayed much cleaner than previous attemps
> with Backbone.js.
> 
> Module Architecture
> -------------------
> 
> The application is comprised of two types of modules, those that contain
> Backbone.js code (messageModule, userModule), and one that contains the
> Socket.IO code (socketModule). If either the messageModule, or the
> userModule, require content from Socket.IO they subscribe to events that
> the socketModule trigger. Likewise, Socket.IO messages sent to the
> server are the result of the socketModule suscribing to events triggered
> by the messageModule and userModule.
> 
> Below is an example module that contains skeleton code for an additional
> Backbone.js module. The ExampleModule class is used to glue all the
> Backbone.js objects together. In this case their is only one, the
> ExampleView, in Chatty’s MessageModule there are two distinct views
> instantiated within its MessageModule object.
> 
> Example Module
> 
> 
>     ExampleModel = Backbone.Model.extend()
> 
>     ExampleCollection = Backbone.Collection.extend
>       model: ExampleModel
> 
>     # View for a single model
>     ExampleView = Backbone.View.extend
>       render: () ->
>         @$el.html app.template 'example', @model.toJSON()
>         @$el
> 
>     # View for a collection of models
>     ExamplesView = Backbone.View.extend
>       initialize: () ->
>         @collection = new ExampleCollection()
>         @collection.on 'add', @addExample, @
>         @eventHandlers()
> 
>       eventHandlers: () ->
>         # Subscribe to the app-wide event 'new-example'. When 
>         # the event is called, the call-back function is provided
>         # with an example model, which is then added to the collection.
>         app.events.on 'new-example', (example) =>
>           @collection.add example
> 
>       addExample: (example) ->
>         exampleView = new ExampleView
>           model: example
>         @$el.append exampleView.render()
> 
>     class ExampleModule
>       constructor: () ->
>         @examplesView = new ExamplesView()
> 
>     new ExampleView()
> 
> Deploying Node.js and Rails App to Heroku
> -----------------------------------------
> 
> ### Deploying the Node.js server
> 
> Heroku requires the following code to create the Socket.IO server and
> listen for connections (note that Heroku doesn’t support websockets):
> 
> Socket.IO server
> 
>     var app = require('http').createServer();
>     var io = require('socket.io');
> 
>     io = io.listen(app);
>     io.configure(function(){
>       io.set("transports", ["xhr-polling"]);
>       io.set("polling duration", 10);
>       io.set("close timeout", 10);
>       io.set("log level", 1);
>     })
> 
>     io.sockets.on('connection', function (socket) {}
>     var port = process.env.PORT || 5001;
>     app.listen(port);
> 
> Unfortunately, Heroku’s documentation only contains fragments of the
> above code. The above code, along with deploying instructions, is posted
> across several pages: [getting started with Node.js on
> Heroku/Cedar](http://devcenter.heroku.com/articles/node-js) and [using
> Socket.IO with Node.js on
> Heroku](http://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku).
> The \`close timeout\` option was added since the default 25 seconds made
> the chat app seem buggy (a user would log out but other users would seem
> them logged in for 25 seconds).
> 
> ### Deploying the Rails app
> 
> Deploying a Rails application is relatively well documented, but I
> thought I’d provide a few additional tips.
> 
> The URL for the production and development Socket.IO server differ. To
> accommodate this the Backbone.js app makes an Ajax request to the Rails
> app and gets the URL of the Socket.IO server along with a unique id for
> the current user. The Rails app can serve a different Socket.IO URL
> depending on whether it is currently in production or development.
> 
> The other thing that might be new for nacent Rail’s developers is the
> inclusion of the `response.headers` code in the show method, this tells
> the browser to cache the Backbone.js app for 25,300 seconds.
> 
> Controller associated with Backbone.js App
> 
> 
>     class BackboneAppController < ApplicationController
>       layout 'backboneApp'
>       respond_to :html, :json
>       def show
>         response.headers['Cache-Control'] = 'public, max-age=25300' if Rails.env.production?
>       end
> 
>       def user_info
>         respond_with({
>             'uuid' => UUIDTools::UUID.random_create.to_s,
>             'socketURL' => self.get_socket_url
>         })
>       end
> 
>       protected
>       def get_socket_url
>         Rails.env.production? ? "http://chatty-server.herokuapp.com/" : "http://0.0.0.0:5001"
>       end
>     end
> 
> In order for Heroku to manage the asset pipeline your application must
> be [deployed to Heroku Cedar’s
> stack](http://devcenter.heroku.com/articles/rails3). Unfortunately the
> Cedar stack doesn’t include Varnish caching, requiring you to enable
> caching via [memcache and the dalli
> gem](http://devcenter.heroku.com/articles/memcache#deploying_to_heroku).
> I found that deploying a new version would not necessarily clear the
> cache and and I had to do it manually (connect to console:
> `heroku run console`):
> 
> Clearing the cache
> 
> 
>     dc = Dalli::Client.new('localhost:11211')
>     dc.flush_all
> 
> Final Thoughts
> --------------
> 
> Relying entirely on pub/sub to communicate between modules worked really
> well in this application, but I wonder if it would scale to a larger
> application? I’d also be curious to know how other developers are
> combining Backbone apps with Rails, I suspect there are a number of ways
> to do it.
> 
> [Code on Github](https://github.com/liamks/Chatty)
> 
> Posted by Liam Kaufman Feb 25th, 2012
> 
