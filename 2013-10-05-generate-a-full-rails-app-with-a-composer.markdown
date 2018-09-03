---
layout: post
title: "Generate a Full Rails App With a Composer"
date: 2013-10-05 08:15
comments: false
categories: [technology]
tags: [rails]
---
Run rails composer to create a new application:

    $ rails new myapp -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb

Caveat: When using PostgreSQL, and it asks if you want to use the name
of the app as the postgres user, say NO.

If you say yes, it will break because it creates the new user BUT
without the permission to create data bases.

Also, if you're going to be running your app's continuous integration
using Travis, they require the test db user to be 'postgres', so you
might just as well create a default user 'postgres' for your dev
environment too and be done with it. (Deploying to production you'll
obviously want some other user/pw.)


Source: http://railsapps.github.io/rails-composer/
