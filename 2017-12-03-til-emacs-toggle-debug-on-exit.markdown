---
layout: post
title: "TIL: emacs toggle-debug-on-exit"
date: 2017-12-03 21:54
categories: ["emacs"]
tags: ["emacs", "debugging"]
---

Today, I learned there's a `toggle-debug-on-exit` emacs function.

To use it:

    M-x toggle-debug-on-exit

then reproduce the problem when trying to exit emacs, and use the
debugger / study the backtrace.

H/T `#emacs` channel on Freenode.
