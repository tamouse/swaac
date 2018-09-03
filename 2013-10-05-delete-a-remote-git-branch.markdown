---
layout: post
title: "Delete a remote git branch"
date: 2013-10-05 08:03
categories: [git]
tags: [remote, branch, remove]
source: http://stackoverflow.com/questions/315911/git-for-beginners-the-definitive-practical-guide/5977604#5977604
---
Perform a push to your remote using : before the name of the branch

    $ git push origin :mybranchname

where `origin` is the name of your remote and `mybranchname` is the
name of the branch about to be deleted.

