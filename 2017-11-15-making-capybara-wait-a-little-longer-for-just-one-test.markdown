---
layout: post
title: "Making Capybara wait a little longer for just one test"
date: 2017-11-15 08:29
categories: ["testing"]
tags: ["capybara", "testing", "delay", "using_wait_time"]
source: https://www.reddit.com/r/rails/comments/25xrdy/is_there_a_way_to_change_capybaras_wait_time_just/
---

I needed to add some time to a Capybara test that was checking some
AJAX in my code. I didn't want to increase the waiting time overall,
just for this one particular transaction.

Capybara has a `default_wait_time` setting in the configuration, so it
makes sense there's a way to set wait time some other way that's *not*
the default.

I couldn't find anything in the readme, and I didn't know what to
search for in the docs. I entered a general set of search terms in
google, to no particular avail. I finally settled on the rather brute
force desperation "How do I change Capybara's wait time for just one
test?" and got a page at reddit that covered it exactly:
<{{page.source}}>

The top two answers provide the best solutions, I think, as they
expose features available in Capybara that I didn't know existed.


{% highlight ruby %}
Capybara.using_wait_time(n) do
  # .. run your test in this block
  # .. and it will wait n seconds
  # .. for items to appear in the page
end
{% endhighlight %}

<https://www.reddit.com/r/rails/comments/25xrdy/is_there_a_way_to_change_capybaras_wait_time_just/chm1fe1/>

{% highlight ruby %}
expect(page).to have_selector("#my_thing", wait: 5)
  # .. the above will wait 5 seconds for
  # .. `#my_button` item to appear on the page
{% endhighlight %}

<https://www.reddit.com/r/rails/comments/25xrdy/is_there_a_way_to_change_capybaras_wait_time_just/chm383m/>

Pretty dang cool!
