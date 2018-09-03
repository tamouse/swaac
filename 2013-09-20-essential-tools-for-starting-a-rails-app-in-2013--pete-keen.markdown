---
layout: post
title: "Essential Tools for Starting a Rails App in 2013 | Pete Keen"
date: 2013-09-20 17:54
categories: [swaac]
tags: [rails, tools]
source: http://www.petekeen.net/essential-tools-for-starting-a-rails-app-in-2013
---
A repost of <{{page.source}}>.

## Author: Pete Keen
## Sunday, 15 September 2013

> Over the past few years I've written a number of Rails applications.
> It's become my default "scratch an itch" tool for when I need to build
> an app quickly to do a task. Even though Rails is mostly
> batteries-included, there are a few tools that make writing new
> applications so much easier. This is my list of tools that I use for
> pretty much every new Rails project.
> 
> *Edit: The discussion on [Hacker
> News](https://news.ycombinator.com/item?id=6393242) has some great gems
> that you should consider using as well.*
> 
> ### [Dotenv](https://github.com/bkeepers/dotenv)
> 
> [Dotenv](https://github.com/bkeepers/dotenv) is a simple gem that loads
> environment variables from a file named `.env` in your project root into
> the `ENV` hash within Ruby. Getting configuration from the environment
> is one of the factors in [12 Factor Applications](http://12factor.net),
> and using a `.env` file for development eases the transition to
> deploying on Heroku. Or, if you're crazy like me, deploying on your own
> hardware using a nasty brew of Capistrano and Foreman.
> 
> ### [Devise](https://github.com/plataformatec/devise)
> 
> Most Rails apps are going to need a way to authenticate users. You could
> write something yourself, but there are a lot of subtle security
> concerns that you have to take into account. By using an off the shelf
> product like [Devise](https://github.com/plataformatec/devise) you're
> insulated from having to worry about that. Some people use
> [AuthLogic](https://github.com/binarylogic/authlogic), which is also
> perfectly fine.
> 
> ### [Brakeman](http://brakemanscanner.org)
> 
> There have been quite a few security vulnerabilities over the past year
> or so inside Rails, some of which are due to Rails themselves, but many
> are coding errors or best practices that, over time, have turned out to
> be not the best. [Brakeman](http://brakemanscanner.org) is a security
> scanner that looks at your code base for both categories of error and
> tells you if you're doing something wrong. I run Brakeman over my
> codebase as part of my test suite so I know immediately when I'm doing
> something that isn't quite right.
> 
> ### [Rails Best Practices](https://github.com/railsbp/rails_best_practices)
> 
> In a simlar vein to Brakeman, [Rails Best
> Practices](https://github.com/railsbp/rails_best_practices) is a list of
> best practices that anyone can add to, vote on, and modify. They provide
> a scanner that looks for violations of these best practices and tells
> you about them. I also run this as part of my test suite, not because
> they're necessarily security focused, but hard-won experience has taught
> me that doing (most of) the things that RBP says to do leads to a more
> maintainable codebase. They provide a configuration file that you can
> tweak, in case the scanner starts warning on something that you don't
> think it should.
> 
> ### [Simple Form](https://github.com/plataformatec/simple_form)
> 
> Much of what we do as Rails developers boils down to making simple CRUD
> forms to work with models. Much of this is going to be inside an admin
> interface that users never actually see so we want to get the job done
> as quickly as possible. [Simple
> Form](https://github.com/plataformatec/simple_form) lets you write the
> simplest form declaration possible and bakes in a lot of useful things
> like error and validation handling. It's also compatible with a number
> of CSS frameworks like Zurb Foundation and Bootstrap. I tend to use
> Simple Form in lieu of an admin interface generator like ActiveAdmin,
> mostly because I haven't had much luck getting those to play with Rails
> 4.
> 
> ### [Sidekiq](http://sidekiq.org)
> 
> At some point every Rails application is going to need to do some
> background processing, especially if you're making server-side calls to
> other web services. These should *always* be done outside of a web
> request because Rule Number 1 is [The network is
> unreliable](http://en.wikipedia.org/wiki/Fallacies_of_Distributed_Computing)
> (the PDF in the sources block is a great explanation of the problems of
> distributed computing, btw). I've explored a number of different
> background processing systems for Rails and the best that I've found is
> named [Sidekiq](http://sidekiq.org). It uses less resources per worker
> than any of the rest and it is super easy to manage.
> 
> Share: 
> [**](https://plus.google.com/share?url=http%3A%2F%2Fpkn.me/tools) 
> [**](https://facebook.com/sharer.php?u=http%3A%2F%2Fpkn.me/tools) 
> [**](https://twitter.com/intent/tweet?url=http%3A%2F%2Fpkn.me/tools&text=Essential%20Tools%20for%20Starting%20a%20Rails%20App%20in%202013&via=zrail) 
> [Y](https://news.ycombinator.com/submitlink?u=http%3A%2F%2Fwww.petekeen.net/essential-tools-for-starting-a-rails-app-in-2013&t=Essential%20Tools%20for%20Starting%20a%20Rails%20App%20in%202013) 
> 
> [![](https://d2s7foagexgnc2.cloudfront.net/files/9e8485ea8977967c7fe7/paperbacklandscape-1.png)](/mastering-modern-payments)
> 
> #### [Mastering Modern Payments: Using Stripe with Rails](/mastering-modern-payments)
> 
> Check out my guide on how to properly integrate Stripe with Ruby on
> Rails, covering background processing, audit trails, admin pages and
> more.
> 
> [Learn More and Buy Now](/mastering-modern-payments)
> 
> Other Formats:  [![Download
> PDF](https://d2s7foagexgnc2.cloudfront.net/files/7d44797a6ac52e7fb898/pdf.png)](/essential-tools-for-starting-a-rails-app-in-2013.pdf)
> [![Download Raw
> Markdown](https://d2s7foagexgnc2.cloudfront.net/files/4fb4d0b0a7a0bb33a2e0/markdown.png)](/essential-tools-for-starting-a-rails-app-in-2013.md)
> 
> Tagged: [Programming](/tag/Programming)  [Rails](/tag/Rails) 
> 
> -   © [Pete Keen](/)
> -   [**](https://github.com/peterkeen)
> -   [**](http://www.linkedin.com/in/peterkeen)
> -   [**](http://twitter.com/zrail)
> -   [**](mailto:pete@bugsplat.info)
> -   [**](/index.xml)
> 
