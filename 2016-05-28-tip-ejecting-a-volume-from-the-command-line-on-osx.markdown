---
layout: post
title: "Tip: Ejecting a volume from the command line on OSX"
date: 2016-05-28 06:39
categories: ["osx"]
tags: ["tips", "command-line", "eject", "diskutil", "osx"]

---

This turns out to be pretty simple.


{% highlight shell %}
$ diskutil list # find the disk you want to eject
$ diskutil eject /dev/disk2 # eject it
# wait...
{% endhighlight %}

`diskutil eject` by itself will give help on the verb.
