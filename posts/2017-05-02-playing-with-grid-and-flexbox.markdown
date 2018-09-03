---
layout: post
title: "Playing with Grid and Flexbox"
date: 2017-05-02 17:00
categories: ["css"]
tags: ["css", "grid", "flexbox"]
---

So last month, March 2017, Grid CSS support dropped for almost all the
major browsers. Grid is a pretty nice system for 2-dimensional layout
while Flexbox remains a good system for 1-dimensional layout. A lot of
folks have been
asking [if Grid replaces Flexbox but it does not][grid-vs-flexbox]. In
fact, they can play really well together.


## GridCSS Holy Grail Layout

The [holy grail] layout is a pretty common one, seen pretty much
everywhere:

- header and footer
- middle content area with left and right sidebars

Creating it in Grid was something I wanted to try to figure out as a
way of learning. My attempt is over on CodePen.io:

<p data-height="265" data-theme-id="0" data-slug-hash="zwwwwZ" data-default-tab="result" data-user="tamouse" data-embed-version="2" data-pen-title="GridCSS holy grail" class="codepen">See the Pen <a href="http://codepen.io/tamouse/pen/zwwwwZ/">GridCSS holy grail</a> by Tamara Temple (<a href="http://codepen.io/tamouse">@tamouse</a>) on <a href="http://codepen.io">CodePen</a>.</p>

I'm still struggling with getting the height to stretch out if the
content does not naturally fill the window.

## Flexbox Dashboard with Grid Section

This was more successful. I wanted a full-height left navigation panel
and a masonry-style right panel that would let various guages and
displays flow nicely.

<p data-height="265" data-theme-id="0" data-slug-hash="EmmXdr" data-default-tab="result" data-user="tamouse" data-embed-version="2" data-pen-title="Flexbox Dashboard with Grid Section" class="codepen">See the Pen <a href="http://codepen.io/tamouse/pen/EmmXdr/">Flexbox Dashboard with Grid Section</a> by Tamara Temple (<a href="http://codepen.io/tamouse">@tamouse</a>) on <a href="http://codepen.io">CodePen</a>.</p>

It's not really responsive, I'd like it if the left panel shrunk down
when the viewport gets narrow enough, but I don't think I can make
that happen on codepen.

## Links

* [GridCSS Holy Grail][codepen1]
* [Flexbox Dashboard][codepen2]

* [Grid vs. Flexbox][grid-vs-flexbox]
* [Rachel Andrew's Start using grid today (video)][rachel-andrew-start-using-grid-today]
* [Getting started with CSS Grid][hackernoon-start-using-grid]
* [One Layout, Multiple Ways][one-layout-multiple-ways]



[codepen1]: http://codepen.io/tamouse/pen/zwwwwZ "GridCSS holy grail"
[codepen2]: http://codepen.io/tamouse/pen/EmmXdr "Flex Dashboard with Grid Section"

[grid-vs-flexbox]: https://css-tricks.com/css-grid-replace-flexbox/ "No. Well, mostly no."
[rachel-andrew-start-using-grid-today]: https://www.youtube.com/watch?v=tjHOLtouElA "Rachel Andrew Presentation: Start Using Grid Today"
[hackernoon-start-using-grid]: https://hackernoon.com/getting-started-with-css-grid-layout-8e00de547daf "Hackernoon: Getting started with Grid Layout"
[one-layout-multiple-ways]: https://css-tricks.com/css-grid-one-layout-multiple-ways/ "One layout, Multiple Ways in CSS Grid"

<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
