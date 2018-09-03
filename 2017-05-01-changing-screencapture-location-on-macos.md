---
layout: post
title: "Changing the Location for Screencaptures on macOS"
date: 2017-05-02 13:28
categories:
  - osx
tags:
  - osx
  - mac
  - screencapture
  - screenshot
  - location
  - defaults
---

Something I had tucked away in notes on a different computer while I
was working on my work computer, so I figured it was time to put up on
the SWaaC blog.

By default on macOS, when you do a screen capture, it saves the
file(s) in your Desktop directory. I'd like to put them someplace else
as I really hate having cluttered up desktops.

The command to use from the Terminal is `defaults` which is used to
set various system parameters that aren't available in Systems
Preferences.

Here's what I did:

{% highlight bash %}
$ mkdir ~/Pictures/Screenshots
$ defaults write com.apple.screencapture location ~/Pictures/Screenshots
$ killall SystemUIServer
{% endhighlight %}

and to test took a screen capture with CMD-SHIFT-3.

I considered saving the screen captures to my Google Drive, but that
might prove to be a problem at some point down the road.

Also, I'm using an app called [Monosnap](https://monosnap.com/welcome)
which is freely available from the App Store for making annotated
screen captures. I'm liking it a lot, it reminds me of Skitch for
Evernote, without the Evernote overhead.
