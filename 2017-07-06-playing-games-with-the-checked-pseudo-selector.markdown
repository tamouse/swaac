---
layout: post
title: "Playing games with the :checked pseudo-selector"
date: 2017-07-06 01:25
categories: ["css"]
tags: ["css", "checked"]
source: https://codepen.io/tamouse/pen/YQjVNb?editors=1100
---

I'm not sure what made me think of this, but I got a wild hair and
thought I'd try it out.

The `:checked` CSS pseudo-selector lets you select a *checked*
checkbox or radio button. The question I wondered, would this be a
cheap-azz way of making a sliding sidebar? And the answer is, yes it
could.

Over at [codepen]({{page.source}}) I left a pen showing just that:

<iframe height='265' scrolling='no' title='what can you do with :checked?' src='//codepen.io/tamouse/embed/YQjVNb/?height=265&theme-id=0&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/tamouse/pen/YQjVNb/'>what can you do with :checked?</a> by Tamara Temple (<a href='https://codepen.io/tamouse'>@tamouse</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

Some of the interesting bits:

* The body is set to `display: flex` and `flex-direction: row`, which
  would normally put the 3 major body parts, `input`, `aside`, and
  `article` horizontally, but...

* The input checkbox is positioned absolute taking it out of the flex
  flow, so only the `aside` and `article` are flexed

* After setting everything up for the "normal" state, with the
  checkbox *un*checked, and the sidebar *hidden*, I added the last CSS
  rule to display the sidebar when the input checkbox is checked.

### normal state


{% highlight scss %}
.sidebar {
  width: 20px;
  background: tomato;
  padding-top: 40px;
  > * {
    display: none;
  }
}
{% endhighlight %}

### checked state

{% highlight scss %}
input.sidebar-toggle:checked ~ .sidebar {
    width: 200px;
  > * {
    display: inherit;
  }
}
{% endhighlight %}

Of course, this could be taken in all sorts of directions, but I
wanted to try this out to see if it works.
