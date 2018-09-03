---
layout: post
title: "Resetting Emacs colours after working with Guard"
date: 2017-04-29 16:01
categories: ["tools"]
tags: ["emacs", "guard", "tools", "snippet", "gist"]
source: URL
---

This is a petty annoyance, but those add up.

After I've been using [guard](https://github/guard/guard), it leaves
the last status notification on my emacs mode line, so I want to reset
it so I can stop thinking about the project for a while.

I found something like this and wrote it for my needs:

<script src="https://gist.github.com/tamouse/4eaa00af7b415fc48ac03bcb97a4c2ac.js"></script>

I save the script in my `$HOME/bin/` folder and can call it from the
command line to clean up my emacs mode line.
