---
layout: post
title: "Fixing the Roll-under for Fixed-Top Layouts"
date: 2017-05-13 11:46
categories: [css]
tags: [css, layouts, fixed-top, hacks, css-hacks]
---


A typical problem encountered when using something
like [Bootstrap's](https://getbootstrap.com) fixed-top navbar is that
clicking on an interior link often causes that link target to scroll
underneath the navbar, hiding it from view.

The fix for this is a bit of a hack, and sometimes you need to adjust
things even further.

## Targeting the link targets

Sounds redundant, but what I mean is how I want to set some CSS to
apply to all the interior link targets.

The way Bootstrap purports to do this (but I haven't seen it on
versions I've been using) is a general selection targetting items with
an `id` attribute.

This works well using a package like [Jekyll](http://jekyllrb.com)
with the [Kramdown]() markdown processor which adds an `id` attribute
to every Markdown heading.

(This is SCSS code which uses the `$navbar-height` variable defined by
bootstrap. In plain old CSS you'd just use the number.)
{% highlight scss %}
*[id]:before {
    display: block;
    content: " ";
    margin-top: -($navbar-height+25); // Set the Appropriate Height
    height: ($navbar-height+25); // Set the Appropriate Height
    visibility: hidden;
}
{% endhighlight %}

So whereever there's a element with the `id` tag now, there's an
invisible CSS `:before` section that pushes the item down. It's
invisibility also means that it won't cover any links or clickable
items that might be just above the heading.

One problem I did run into was using the table of contents generator
in Kramdown:


{% highlight markdown %}
* Content
{:toc}
{% endhighlight %}

This creates a list of interior page links, but also puts an `id`
attribute on each link in the list item, so adding this reversed the
effect of the prior "push down", so that the list bullets aligned with
the list items.

{% highlight scss %}
li *[id]:before {
    display: inherit;
    content: '';
    margin-top: 0;
    height: 0;
    visibility: hidden;
}
{% endhighlight %}
