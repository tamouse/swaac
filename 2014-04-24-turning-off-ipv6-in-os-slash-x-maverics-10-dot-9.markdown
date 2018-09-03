---
# BEGIN: redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
redirect_from:
  - /blog/2014/04/24/turning-off-ipv6-in-os-slash-x-maverics-10-dot-9/
# END:   redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
layout: post
title: "Turning off IPv6 in OS/X Maverics 10.9"
date: 2014-04-24 09:56:56 -0500
categories: swaac
tags: [sysadmin, osx, networking, ipv6]
---
I recently had a problem connecting via wi-fi at a local restaurant. This is how I solved it.

Apple's OS/X 10.9 Maverics seems to have produces many networking problems for people, myself included.

This particular problem arose when I was at a local favourite
restaurant that offered wi-fi connectivity. I haven't encountered this
elsewhere (yet), but I'm cataloging this so if others encounter the
problem, this might be one way to fix it.

## The Problem

Networking could find the wi-fi and it would connect to the WAP, but
it would not connect through to the Internet.

Initially, I thought it might be the WAP/Router/Modem in the
restaurant, but when I tried to connect with my smartphone to the
wi-fi, there was no problem getting through.

## Enter IPv6

When I looked at the connection on my phone, I noticed it had an IPv4
number, while the mac was trying to connect using IPv6.

The symptoms were that the wi-fi would connect, get an IPv6 number,
then in a little bit would fail-over to a non-connected IPv6
number. The IPv4 number coming was the default internal IPv4 number,
showing no connection.

## Turning off IPv6

It used to be easy to turn off IPv6 in future versions of OS/X. I'm
not sure when it disappeared, but you cannot simply turn it off via
the System Preferences Network Pane anymore.

A quick search of the web provided an answer:

    https://discussions.apple.com/message/25125051#25125051

The thing to do is to use command line to turn it off:

    networksetup -setv6off wi-fi

## Turning IPv6 back on

It is probably *not* a good idea to leave IPv6 off for any particular
interface, so turning it back on is another command line:

    networksetup -setv6on wi-fi

