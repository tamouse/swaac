---
layout: post
title: "Adding Real-Time To A RESTful Rails App - Liam Kaufman"
date: 2013-09-24 23:09
categories: [swaac]
tags: [socket.io, node-js, rails, real-time]
source: http://liamkaufman.com/blog/2013/02/27/adding-real-time-to-a-restful-rails-app/
---
A reposting of <{{page.source}}> by [Liam Kaufman](http://liamkaufman.com/blog/)


> Adding Real-Time to a RESTful Rails App
> =======================================
> 
> Feb 27th, 2013
> 
> After rewriting [Understoodit](http://understoodit.com) several times
> I’ve spent a lot of time thinking about building real-time web
> applications. While I elected to rewrite 100% of Understoodit in Node,
> there are many existing Rails and Sinatra applications that can’t be
> completely rewritten, but could still benefit with the addition of
> real-time updates. The tutorial below starts with a traditional web-app
> written in Backbone and Ruby on Rails (RoR). Of course the modifications
> could easily be applied to any (Backbone|Angular|Ember) and
> (Rails|Sinatra|Django|Pylons) app.
> 
> Between the overview below, and the [code on GitHub](https://github.com/liamks/rails-realtime), you should be able to
> follow along and, in less than 50 lines of code, add real-time updates
> to your Rails app.
> 
> [Adding Real-Time on Github](https://github.com/liamks/rails-realtime)
> 
> Starting Point
> --------------
> 
> In a traditional web app if a user creates a new model other users must
> refresh their page to see that content. Alternatively, you could poll
> the server every 30 second and refetch all the content. With both
> approaches you end up fetching all the content, and in the first case
> the markup as well.
> 
> ![Traditional RESTful Rails app](/images/rails-realtime-rest.png)
> 
> In Figure 1, User 1 creates a new book, but User 2 will not see that new
> book unless they refresh their page.
> 
> Adding Real-Time With Redis And Socket.IO
> -----------------------------------------
> 
> When User 1 creates a new book, we’d like that new book to be pushed to
> User 2 in real-time. I’m going to cover one method that requires only a
> few modifications to your existing app and uses Redis, Node and
> Socket.IO.
> 
> How It Will Work
> ----------------
> 
> ![Traditional RESTful Rails app with Real-Time](/images/rails-realtime-with-rt.png)
> 
> 1.  When User 1 creates a new book, an “after\_create” callback
>     publishes that new book to Redis on the “rt-change” channel.
> 2.  On the Node server, each client subscribing to “rt-change” receives
>     that new book.
> 3.  The new book is pushed to the client using Socket.IO.
> 4.  Within the browser, Socket.IO receives that new book and “publishes”
>     that change to our Backbone.js App.
> 5.  The Backbone.js books collection, listening for changes to books,
>     adds the new book to itself.
> 
> The advantage of this approach is that it only requires tiny
> modifications to a Rails’ model, and if your Node server crashes, your
> application will work as it always has (without real-time). Thus, I’d
> consider this a real-time enhancement that gracefully degrades to a
> conventional Rails RESTful web app.
> 
> Socket.IO Connection
> --------------------
> 
> First, ensure that `socket.io.js` has been added to
> `lib/assets/javascripts`, and referenced in
> app/assets/javascripts/application.js. In the web app create a new
> module, called realtime, that includes the Socket.IO connection code.
> When the application initializes it calls `app.realtime.connect()` to
> setup the Socket.IO connection.
> 

{% highlight javascript %}
     window.app.realtime = {
       connect : function(){
         window.app.socket = io.connect("http://0.0.0.0:5001");
 
         window.app.socket.on("rt-change", function(message){
           // publish the change on the client side, the channel == the resource
           window.app.trigger(message.resource, message);
         });
       }
     }
{% endhighlight %}
 
> Node Server & Pub/Sub
> ---------------------
> 
> In the root of the Rails app create a new folder called ‘realtime’,
> where the Node server will reside. Don’t forget to create a
> `package.json` file and include socket.io, and redis in the
> dependencies. Finally, remember to run `npm install`.
> 

{% highlight javascript %}
var io = require('socket.io').listen(5001),
  redis = require('redis').createClient();

redis.subscribe('rt-change');

io.on('connection', function(socket){
  redis.on('message', function(channel, message){
    socket.emit('rt-change', JSON.parse(message));
  });
});
{% endhighlight %} 

> Rails Models
> ------------
> 
> Assuming you have Redis installed, add redis to your Gemfile. Next,
> create a file called `redis.rb` in your initializers with the following
> content:
> 

{% highlight ruby %}
#make sure redis has been added to your Gemfile
$redis = Redis.new(:host => 'localhost', :port=> 6379)
{% endhighlight %}

> The Rails app now has access to Redis through the `$redis` global
> variable. Below, we publish changes to Redis whenever a model is
> created, updated or destroyed. Changes are published to “rt-change”,
> which our Node.js connections are listening to (see above).
> 

{% highlight ruby %}
class Book < ActiveRecord::Base
  attr_accessible :num_pages, :title
  after_create {|book| book.message 'create' }
  after_update {|book| book.message 'update' }
  after_destroy {|book| book.message 'destroy' }

  def message action
    msg = { resource: 'books',
            action: action,
            id: self.id,
            obj: self }

    $redis.publish 'rt-change', msg.to_json
  end
end
{% endhighlight %}

> Listen For Changes in The Backbone App
> --------------------------------------
> 
> In the Books Collection, we add the code to both listen for ‘books’
> events and the handler to handle those events. For create, we simply add
> the new object (obj) to the collection. For update we update the
> existing model, while for destroy we remove the object from the
> collection.
> 
{% highlight javascript %}
app.collections.Books = Backbone.Collection.extend({
  model : app.models.Book,
  url : '/books',

  initialize: function(){
    app.on('books', this.handle_change, this);
  },

  handle_change : function(message){
    var model;

    switch(message.action){
      case 'create':
        this.add(message.obj);
        break;
      case 'update':
        model = this.get(message.id);
        model.set(message.obj);
        break;
      case 'destroy':
        this.remove(message.obj);
    }
  }
});
{% endhighlight %}

> Caveats
> -------
> 
> In production there are many edge cases to consider. For instance, if
> someone views your app on their mobile phone and then puts the phone in
> their pocket, the screen saver goes on and Socket.IO will disconnect.
> When the user takes the phone out of their pocket, and views the app,
> Socket.IO will reconnect. However, during the period of disconnection
> the data in the client-side app may have become out-of-date. An easy fix
> is just to fetch the data on reconnect. With lots of connections, or
> lots of data, fetching everything becomes problematic and requires a
> more clever method for fetching data (e.g. just fetch the new, or
> changed, data).
> 
> Another issue is if two people are editing the same item, and if person
> 1 clicks save that will replace what person 2 is editing. To solve this
> you can present person 2 with a message saying that the book they are
> editing has been updated by someone else and prevent the version of the
> book they are editing from being replaced. This isn’t an ideal solution,
> but would be fine if the chances of two people editing the same model
> were minimal.
> 
> In the code above there is only one channel ‘rt-change’, meaning every
> connected client will get every real-time change. You may want to scope
> your channels by user (e.g. rt-change/[USERID]). Furthermore, you’d want
> to create one redis client for every Socket.IO connection (currently
> there’s one redis client for all connections). In other words the
> `.createClient()`, and `redis.subscribe('...')`, would have to take
> place within the Socket.IO ‘connection’ callback (after line 6 above).
> 
> Alternatives To The Above
> -------------------------
> 
> ### SockJS
> 
> Socket.IO could be swapped for
> [SockJS](https://github.com/sockjs/sockjs-client), which uses a similar
> API to websockets. I’ve heard from several individuals that it’s
> significantly more stable than the current version of Socket.IO and it’s
> currently [used by Meteor](https://github.com/meteor/meteor/tree/master/packages/stream).
> 
> ### Engine.IO
> 
> Guillermo Rauch, the creator of Socket.IO, has publically stated that
> Socket.IO’s approach of starting with websockets and falling back to
> polling [creates issues](http://www.devthought.com/2012/07/07/the-realtime-engine/). As
> result, he’s been working on Engine.IO, which will power Socket.IO
> version 1.0, and should provide a much more stable experience. I suspect
> Socket.IO, v1.0, will be released in the next few months.
> 
> ### Rails 4.0
> 
> Rails 4.0, [which is due to be released soon](http://weblog.rubyonrails.org/2013/2/25/Rails-4-0-beta1/), will
> include
> [streaming](http://tenderlovemaking.com/2012/07/30/is-it-live.html).
> Using a combination of Rails 4 streaming, and Puma, you could
> potentially remove Node and Socket.IO, and use Rails for real-time. Of
> course, you’d have to take care of some of what Socket.IO does such as
> reconnects and heart-beats.
> 
> ### RabbitMQ/ZeroMQ
> 
> Redis’ Pub/Sub functionality could be replaced by either RabbitMQ or
> ZeroMQ. I ended up using Redis, since I was using it for caching, and it
> has an extremely simple API for pub/sub. While RabbitMQ and ZeroMQ
> appear more complex, they do offer many more features for messaging.
> 
> ### Commercial Options
> 
> If you’re not keen on tinkering with Node, or waiting for Rails 4, there
> are commercial options such as [Pusher](http://pusher.com/) and
> [PubNub](http://www.pubnub.com/), that deal with real-time connections
> for you. While both options can be pricey, especially with many
> concurrent connections, they do save you the hassle of building the
> infrastructure yourself.
> 
> Conclusions
> -----------
> 
> Adding real-time updates to your Ruby on Rails RESTful app has never
> been easier. Over the next few months Rails 4, or Socket.IO v1.0, will
> make the process even more painless. As Google’s services make users
> more accustomed to real-time updates, it becomes even more important to
> provide a similar experience in your webapps.
> 
> [Adding Real-Time on Github](https://github.com/liamks/rails-realtime)
> 
> Posted by Liam Kaufman Feb 27th, 2013
