---
layout: post
title: "Validation Contexts"
date: 2015-01-20 06:27
categories: ["swaac"]
tags: ["rails", "validation", "links", "justin-weiss", "practicing-rails"]
source: http://www.justinweiss.com/blog/2014/09/15/a-lightweight-way-to-handle-different-validation-situations/
---
By introduction, [Justin Weiss](http://www.justinweiss.com) is a
rather prolific blogger, journaler, and writer about Rails. He has a
book that's coming out,
[Practicing Rails](http://www.justinweiss.com/book) that is the book I
wish I had written, and I am thoroughly indebted to Justin for
writing. The book is *exactly* the way I go about learning how
programming concepts, language features, framework features, and all
that stuff work.

In [this article]({{page.source}}), Justin covers Rails's
[validation contexts](http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-valid-3F), a poorly-documented (to date) feature that
allows different validation tests to be run during model operations.
The article references another article,
<http://blog.arkency.com/2014/04/mastering-rails-validations-contexts/>,
which goes even further into the topic.

## In a nutshell, or, the TL;DR

You can read (and you *should* read) those other articles for more
details. I'm merely going to capture the bottom line here.

In the model, you define validation contexts using the `on:` keyword:

``` ruby
class Post < ActiveRecord::Base
  # ...
  validates_precense_of :body, on: :publish
  # ...
end
```

To use validation contexts, you pass in the context to the `.valid?`
method of the model:

``` ruby
@post.valid?(:publish)
```

The examples indicate this is can be used in the `PostsController` for
example, but Justin's book goes even a bit further in explaining how
they're really useful in testing, and in the Rails console (i.e. REPL
driven development).
