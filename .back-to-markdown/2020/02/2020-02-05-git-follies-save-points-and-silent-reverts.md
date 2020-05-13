---
title: "Git Follies: Setting Save Points, and Performing Silent Reverts"
date: 2020-02-05T08:26:22-0600
categories: [version-control]
tags: [git, branching, reverting]
series: "The Git Follies"
---

This is a little thing I've used when working with git on multi-person projects with a remote repository and continuous integration and testing runs triggered by pushing a commit to the remote repository.

Most people know at least a little bit about branching and merging with git. A lot of folks aren't all that comfortable with doing that, all the same. For these folks, I want to offer a little bit of guideance, and hopefully extend that comfort a little bit nmore in working with git.

## Save Points ##

The first major concept I like to think of as "save points". If you've ever played a video or computer game that has lots of problem solving challenges, bosses to beat, levels to complete, they have the idea of setting a save point, essentially a place to come back into the game at the level you're working on without having to replay all the levels you've already beaten.

### Commits are Save Points ###

Git commits act like save points for your work. If you're going along and decide what you've done just won't work, you can reset to the last commit fairly easily with:

``` shell
git reset --hard
```

This just wipes all the changes in tracked files. It still leaves untracked files laying about though, which can be confusing, so you should run this set of commands:

``` shell
git status
git reset --hard
git status # shows untracked files
```

You can remove the untracked files using `rm` or use the `git clean` command:

``` shell
git status
git reset --hard
git status # shows untracked files
git clean --force
git status
```

And now you should be back at the previous commit, ready to start over.

A **major** caveat: this works *only* if all the work remains local and is not pushed up to the remote. More on this later.

But what if you don't want to get rid of the work, but just want to try another approach?

### Sub-branches are also save points ###

You can build a habit of creating a sub-branch when you embark on your task, and that makes it easier to try several approaches.
