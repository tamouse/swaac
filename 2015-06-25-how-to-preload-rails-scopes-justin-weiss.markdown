---
layout: link
title: "Link: How to Preload Rails Scopes - Justin Weiss"
date: 2015-06-25 14:11
categories: ["rails", "links"]
tags: ["rails", "links", "scopes", "associations"]
link:
  href: "http://www.justinweiss.com/blog/2015/06/23/how-to-preload-rails-scopes/"
  title: "Link: How to Preload Rails Scopes - Justin Weiss"
  date: 2015-06-23
  author:
    name: "Justin Weiss"
    url: "http://www.justinweiss.com"
---

Justin does another great job explaining how to preload a rails association scope
by turning it into an association on the same model with a `where`
clause, and then explains how to keep it DRY.

If you're just using scopes, you end up creating an N+1 query when
gathering the association.


{% highlight ruby %}
class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user

  scope :positive, -> { where("rating > 3.0") }
end

class Restaurant < ActiveRecord::Base
  has_many :reviews
  has_many :postitive_reviews, -> { positive }, class_name: "Review"
end

class User < ActiveRecord::Base
  has_many :reviews
  has_many :postitive_reviews, -> { positive }, class_name: "Review"
end
{% endhighlight %}

The scope `positive` can be reused in other scope-type statements,
such as the associatoins above.

Pre-loading (where we started) is like:


{% highlight ruby %}
restaurants = Restaurant.includes(:positive_reviews).first(5)
{% endhighlight %}

This solves the `N+1` problem using just scopes alone.
