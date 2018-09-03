---
layout: post
title: "TIL: Don't use vendor subdirectory on Heroku"
date: 2018-04-17 21:40
categories: ["webdev"]
tags: ["heroku"]

---

I was helping a friend tonight with a problem they were having getting
a tiny web app to run on heroku.

I spent quite some time trying to figure out the issue.

It turns out that `Heroku` reserves the `vendor/` folder for it's own
use, so you can't delivery files from it. (This is true for PHP
applications, at least. We didn't investigate further).

So, simple rule, don't use the `vendor/` directory in your own app.
