---
layout: post
title: "Using Git to Deploy a Static Site"
date: 2016-01-12 20:42
categories: ["deployment"]
tags: ["git", "jekyll", "deployment"]

---
This post explains how I'm deploying my [Jekyll][jekyll] sites using Git.
Jekyll and other static site generators do a wonderful job of building
your site, which can then be copied to wherever you are hosting the
site. If you're not using Github Pages with your jekyll site, you can
deploy it many other places. This little guide will show how I'm
deploying my Jekyll sites to my own server hosted at
[Gandi.net][gandi].

[jekyll]: http://jekyllrb.com "Jekyll -- the blog-aware static site generator"
[gandi]: http://gandi.net "No-bullshit web hosting"

The technique described below is by no means limited to
Jekyll sites. I first began using Git for deployment with old PHP
sites, for example. Simple sites that basically involve copying over
the old site with the new material can use this technique.

**Update 2016-09-25 13:56**: Another aspect to hosting is, of course,
the server configuation. I just wrote up
[My nginx virtual hosting configuration]({% post_url
2016-09-25-my-nginx-virtual-hosting-configuration %}) describing my
`nginx` configuration for static sites.


* contents
{:toc}



## Overview

The basic operation uses your local jekyll site, standard git
commands, a remote repository, and the deployment site.

* **local jekyll site:** This is the site you write your content, layout,
  and formatting on, and is the place you run the `jekyll serve` and
  `jekyll build` commands.

* **standard Git commands:** for deploying, I use the `git add`, `git
  commit` and `git push` commands. That's really all.

* **remote repository:** The remote repository will be used to receive the
  updates from your local site after running the `jekyll build`
  command. After it receives your updates, it will execute what is
  known as a post-receive [hook] to check out the changes to the
  deployment site.

* **deployment site:** this is the place on your server that will receive
  the updated files, and the web server will serve them to clients via
  HTTP, of course.


## Prerequisites

### Local machine

I'm assuming you already have Jekyll installed and know how to use it,
and that you have a static web site you are ready to deploy.

I'm also assuming you have `git` installed and know how to use it.

### Remote machine

You'll need to have a web server, and have it configured so it will
serve your static site from the document root we'll define below.

You'll also need `git` installed.

## Preparing the remote site to receive the updates

We'll set up the remote site first, then set up the local.

Create a directory for your site:

``` bash
remote$ mkdir -p Sites/my_static_site
```

Create a bare repository that can receive the updates:

``` bash
remote$ mkdir -p Repos/my_static_site.git
remote$ cd Repos/my_static_site.git
remote$ git init --bare
```

Now we're going to add the `post-receive` hook to the bare git
repository.

The hook is simply a shell script that runs whenever you push to the
repository. We'll have it checkout into our static site document root
we've created above. Create the file `post-receive` in the `hooks`
directory of the bare repository (`Repos/my_static_site.git` in our
example above).

``` bash
#!/bin/sh
echo "[log] $0"
export GIT_WORK_TREE="/full/path/to/Site/my_static_site"
export BRANCH="master"
while read oldrev newrev refname
do
    echo "[log] oldrev: $oldrev"
    echo "[log] newrev: $newrev"
    echo "[log] refname: $refname"
    echo "[log] deploying to $GIT_WORK_TREE with $BRANCH"
    git checkout -f $BRANCH
done
```

Change the value for `GIT_WORK_TREE` to the full system path where
your document root is. Make sure that the file `post-receive` is world
executable.

## Setting up the local side to push deployments

When you run `jekyll build` it stores the results in the `_site`
subdirectory. In your site, you should have a `.gitignore` file that
contains a line to ignore this directory.

Let's prepare that directory by running `jekyll build` once to create
the full site.

``` bash
$ jekyll build
```

Now that the directory is there, step into it and set up the Git-based
deployment.

``` bash
$ cd _site
_site/$ git init # make this directory into *another* git repo
_site/$ git add .
_site/$ git commit -m 'first time'
```

Now we add the remote repository on our server that we created above
as the origin, and push our first commit:

``` bash
_site/$ git remote add origin you@remote:Repos/my_static_site.git
_site/$ git push origin master
```

In the push output, you should see the lines echoed from the
post-receive hook. If you're remote server's web server is working
properly, you'll see the site at that URL.

## Workflow

Now that your local and remote sites are set up for deployment, your
continuing workflow will look something like this:

* create blog posts, modify your styles, layouts, and so on.
* when ready to publish, run `jekyll build`
* cd into `_site/`
* run `git add . && git commit -m 'commit msg' && git push origin master`

And there you have it.

## Making your life a little easier

When I have repetitive tasks, I'll usually script them. A tiny shell
script that you can run locally to publish might look something like
this. Create a file `publish.sh` with the following content in your
local site directory:

``` bash
#!/bin/sh
jekyll build
cd _site
git add --all --verbose
git commit -m `date "+%Y%m%d%H%M%S"`
git push origin master
cd ..
echo 'Site deployed!'
```

I've set the commit message to the current timestamp, mostly because I
don't much care about the git log content for the published site. You
might, though, so you might want to pass it in as an argument to the
publish script:

``` bash
git commit -m "$1"
```

in place of that line above.

Make sure to exclude the file in your `_config.yml` file:

``` yaml
exclude:
  - publish.sh
```

Set the file executable, and then you can publish by just calling the
script:

``` bash
$ chmod -x ./publish.sh # just once
$ ./publish.sh
```
