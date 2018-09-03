---
layout: post
date: 2015-06-28 18:34
categories:
- docker
tags:
- docker
- containers
- links
- jessica-frazelle
- desktop
source: https://blog.jessfraz.com/post/docker-containers-on-the-desktop/
---

Jessie Frazelle's blog article,
[Docker Containers on the Desktop](https://blog.jessfraz.com/post/docker-containers-on-the-desktop/),
shows something a bit different than I've seen before.

What if you ran all your fun desktop apps in a docker container?

Why would you want to do that?

Because, as Jessica puts it, using Docker in this way provides a
sandbox around you applicaitons.

> I hate installing things on my host and the files getting
> everywhere. I wanted the ability to delete an app and know it is
> gone fully without some random file hanging around. This gave me
> that. Not only that, I can control how much CPU and Memory the app
> uses. Yes, the cpu/memory hungry chrome is now perfectly contained!

Jessica's collection of docker files here,
[jfrazelledockerfiles](https://github.com/jfrazelle/dockerfiles), is a
super gallery of things you can do with docker, that you may not have
thought of.
