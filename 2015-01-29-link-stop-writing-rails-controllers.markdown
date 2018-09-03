---
layout: link
title: "Stop Writing Rails Controllers"
date: 2015-01-29 21:07
categories: [rails]
tags: [controllers, data-driven-controllers, thin-controllers, links, 'rethinking-rails']
source: http://spin.atomicobject.com/2015/01/26/data-driven-rails-controllers/
author: 
  name: Shawn Anderson
  url: http://spin.atomicobject.com/author/shawn-anderson/
---
Good article, thought provoking. Makes one think about how much code
one must write and how it's possibly better to just use data to
configure things, *a la* `config/routes.rb`. The actual controllers
end up being so thin and repetative, maybe all that needs to happen is
specify some basic information and generate the code.

The implementation presented here is basically a Controller Factory.

# Excerpt:

> ## Data Driven Controllers
> 
> Data Driven Controllers (DDC) lets you declare via data how to
> convert back and forth from HTTP to your application’s domain
> without the need for code. By adhering to a couple of interfaces,
> you can avoid writing most controller code and tests. DDC breaks the
> process of handling a request into three parts.

> ### 1. Convert parameters.
> 
> This step is handled by some sort of context builder. It is mostly
> in charge of gathering parameters, but may need to pluck out
> additional information from the controller. The information is
> collected into a form that the domain code can digest (usually a
> data blob via a Hash or Struct).

> ### 2. Process the domain request / action.
> 
> The domain level service object takes the necessary information and
> processes it (update the database, send emails, external
> services). The service then returns a result that knows nothing
> about HTTP-land. It includes things like status (application, not
> HTTP), objects, errors, etc.

> ### 3. Glue.
> 
> DDC is the glue that holds it all together. It creates a controller
> class that does all the default things for you, but allows you to
> override and fill in the blanks where necessary. When defining your
> glue, you simply tell the action how to get the params from the
> context builder and what service object to send them off to.
