---
layout: post
title: "Github Tricks: Turn off White Space Diffs"
date: 2018-03-01 10:51
categories: ["github"]
tags: ["github", "tricks", "whitespace", "pull-requests", "code-reviews"]
source: "https://blog.github.com/2011-10-21-github-secrets/"
---

Fighting your way through a code review with a lot of changes simply
due to white space changes?

Github to the rescue!

Append `?w=1` to the end of the `.../files` url to view the diff
*without* white space changes.
