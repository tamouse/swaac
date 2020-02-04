---
title: "TIL: putting [ci skip] in the commit message title breaks merge builds"
date: 2020-02-04T13:04:05-0600
categories: [git]
tags: [git, CI, builds, merges, commit-messages, skip]
---

A common way to keep a specific commit from triggering a build on continuous integration services, such as travis and circle (maybe others) is to use `[ci skip]` or `[skip ci]` in the commit message.

If the skip directive is put in the commit message's first line, which is treated as the commit message **title**, it can cause problems for merges down the line.

When the list of commits is included in a merge commit's message body, the skip directive shows up, which causes the merge build to be skipped as well.

## bad commit message:

``` text
[ci skip] fix some typos
```

The directive will show up in the merge commit message body in the list of commits.


## good commit message:

``` text
updated the README

- fixed some typos and broken links

[ci skip]
```

Only the title shows up in the merge commit message body, the skip directive does not.
