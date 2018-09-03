---
layout: post
title: "MVC is dead, it's time to MOVE on."
date: 2013-11-27 13:55
comments: true
categories: [swaac]
tags: [programming,design-patterns,mvc,move]
source: http://cirw.in/blog/time-to-move-on.html
---
A reposting of <{{page.source}}> by [Conrad Irwin](http://cirw.in/).



> MVC is dead, it's time to MOVE on.
> ==================================
> 
> [Conrad Irwin](http://cirw.in/ "List of posts") &mdash; June 2012
> 
> MVC is a phenomenal idea. You have models, which are nice self-contained bits of state, views which are nice self-contained bits of UI, and controllers which are nice self-contained bits of â€¦
> 
> What?
> 
> I'm certainly not the first person to notice this, but the problem with MVC as given is that you end up stuffing too much code into your controllers, because you don't know where else to put it.
> 
> To fix this I've been using a new pattern: **MOVE**. **M**odels, **O**perations, **V**iews, and **E**vents.
> 
> Overview
> ========
> 
> [![Architecture of a MOVE app](/images/move.jpg)](/images/move.jpg "Architecture of a MOVE app")
> 
> I'll define the details in a minute, but this diagram shows the basic structure of a MOVE application.
> 
> -   Models encapsulate everything that your application knows.
> -   Operations encapsulate everything that your application does.
> -   Views mediate between your application and the user.
> -   Events are used to join all these components together safely.
> 
> In order to avoid spaghetti code, it's also worth noting that there are recommendations for what objects of each type are allowed to do. I've represented these as arrows on the diagram. For example, views are allowed to listen to events emitted by models, and operations are allowed to change models, but models should not refer to either views or operations.
> 
> Models
> ======
> 
> The archetypal model is a "user" object. It has at the very least an email address, and probably also a name and a phone number.
> 
> In a MOVE application models only wrap knowledge. That means that, in addition to getters and setters, they might contain functions that let you check "is this the user's password?", but they don't contain functions that let you save them to a database or upload them to an external API. That would be the job of an operation.
> 
> Operations
> ==========
> 
> A common operation for applications is logging a user in. It's actually two sub-operations composed together: first get the email address and password from the user, second load the "user" model from the database and check whether the password matches.
> 
> Operations are the doers of the MOVE world. They are responsible for making changes to your models, for showing the right views at the right time, and for responding to events triggered by user interactions. In a well factored application, each sub-operation can be run independently of its parent; which is why in the diagram events flow upwards, and changes are pushed downwards.
> 
> What's exciting about using operations in this way is that your entire application can itself be treated as an operation that starts when the program boots. It spawns as many sub-operations as it needs, where each concurrently existing sub-operation is run in parallel, and exits the program when they are all complete.
> 
> Views
> =====
> 
> The login screen is a view which is responsible for showing a few text boxes to the user. When the user clicks the "login" button the view will yield a "loginAttempt" event which contains the username and password that the user typed.
> 
> Everything the user can see or interact with should be powered by a view. They not only display the state of your application in an understandable way, but also simplify the stream of incoming user interactions into meaningful events. Importantly views don't change models directly, they simply emit events to operations, and wait for changes by listening to events emitted by the models.
> 
> Events
> ======
> 
> The "loginAttempt" event is emitted by the view when the user clicks login. Additionally, when the login operation completes, the "currentUser" model will emit an event to notify your application that it has changed.
> 
> Listening on events is what gives MOVE (and MVC) the inversion of control that you need to allow models to update views without the models being directly aware of which views they are updating. This is a powerful abstraction technique, allowing components to be coupled together without interfering with each other.
> 
> Why now?
> ========
> 
> I don't wish to be misunderstood as implying that MVC is bad; it truly has been an incredibly successful way to structure large applications for the last few decades. Since it was invented however, new programming techniques have become popular. Without closures (or anonymous blocks) event binding can be very tedious; and without deferrables (also known as deferreds or promises) the idea of treating individual operations as objects in their own right doesn't make much sense.
> 
> To re-iterate: MVC is awesome, but it's designed with decades old technologies. MOVE is just a update to make better use of the new tools we have.
> 
> P.S. I'm not the only one beginning to think this way either, if you like the idea of MOVE you should check out [objectify](https://github.com/bitlove/objectify) and [interactions](http://collectiveidea.com/blog/archives/2012/06/28/wheres-your-business-logic/) which try to add some of the benefits of MOVE to existing MVC applications. Please [let me know](https://twitter.com/conradirwin) if you have other links that should be here!
> 
> P.P.S This blog post has been translated into Japanese no fewer than twice: [d.hatena.ne.jp](http://d.hatena.ne.jp/nowokay/20120704#c) and [blog.neo.jp](http://blog.neo.jp/dnblog/index.php?module=Blog&blog=pg&action=CommentPostDo&entry_id=3442), and also into [Russian](http://habrahabr.ru/post/147038/) and [Spanish](http://www.alanchavez.com/mvc-esta-muerto-es-tiempo-de-darle-paso-a-una-alternativa-move/) Thanks!


> I am [@ConradIrwin](http://twitter.com/ConradIrwin), [github:ConradIrwin](https://github.com/ConradIrwin), [me@cirw.in](mailto:me@cirw.in) or [irc.freenode.net/cirwin](irc://irc.freenode.net/#pry).
> 
> This content is available under the [CC-BY-3.0](http://creativecommons.org/licenses/by/3.0/) licence,  
>  there are [RSS](/blog/rss.xml) and [ATOM](/blog/atom.xml) feeds.
> 
> Thank you John Mair, Martin Kleppmann and Ryan King for suggesting improvements to this page.
