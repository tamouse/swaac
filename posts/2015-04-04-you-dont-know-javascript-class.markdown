---
layout: post
title: "You Don't Know JavaScript Class"
date: 2015-04-04 01:02
categories: ["javascript"]
tags: ["class", "frontend-masters", "kyle-simpson"]
gallery:
  path: javascript/2015-04-04-you-dont-know-javascript-class/
  images:
    - page-01.jpg
    - page-02.jpg
    - page-03.jpg
    - page-04.jpg
    - page-05.jpg
    - page-06.jpg
---
Recently I took a couple classes from
[FrontendMasters](http://www.frontendmasters.com) lead by [Kyle
Simpson](http://getify.me/) on JavaScript Basics to Building, and
JavaScript Types, Coercion, and Sharing.

These are images of the notes I took:

{% for image in page.gallery.images %}
![]({{ image | prepend: page.gallery.path | prepend: site.s3path }})

{% endfor %}
