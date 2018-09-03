---
layout: post
title: "TIL: Removing all Docker Containers and Images"
date: 2018-06-04 11:51
categories: [docker]
tags: [docker, containers, images, removing]
---

I needed to do a reset on my work machine of the Docker stuff I was
using, so needed to know how to do this.

```bash
$ docker rm $(docker ps -aq)
$ docker rmi $(docker images -q)
```

`docker ps -aq` gives a list of all the container hashes, which is
given the `docker rm` command.

Similarly, `docker images -q` lists all the docker image hashes, which
is given to docker's "remove images" `rmi` command.
