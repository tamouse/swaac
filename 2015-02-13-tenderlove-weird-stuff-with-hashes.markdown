---
layout: link
title: "Tenderlove: Weird stuff with Hashes"
date: 2015-02-13 21:55
categories: [ruby]
tags: [hash, dup, freeze, performance]
source: http://tenderlovemaking.com/2015/02/11/weird-stuff-with-hashes.html
---
A great post from @tenderlove on some interesting performance aspects
of using strings for keys in hashes:

[Weird stuff with hashes]({{ page.source }})

tl;dr:

* Hashes dup string keys and then freeze them
* Creating a lot of hashes with string keys can become a big
performance hit
* Freeze the string key so Hash won't dup it and reduce object
allocations and hence calls to the GC


  
