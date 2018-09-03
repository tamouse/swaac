---
layout: post
title: 'Git Merge "dry run"'
date: 2018-02-28 10:30
categories: ["git"]
tags: ["git", "merge", "dry-run", "tools"]
---


There's no specific thing called a "dry run merge" with git, but it's
simple enough to simulate.

In the sample below, `BRANCH` is being merged **into** `TARGET`.

```bash
git checkout $TARGET
git merge --no-commit --no-ff $BRANCH
git diff --cached
git merge --abort
```

You can look for any potential merge conflicts after the first command
as well and see what you might be up against.

Note you need *both* the `--no-commit` *AND* `--no-ff` flags to
prevent the merge from occurring if it's possible for a fast-forward
merge to occur (likely).
