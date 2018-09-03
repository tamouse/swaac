---
layout: post
title: "Deploying Rails app using Nginx"
date: 2013-08-29 12:49
categories: [swaac]
tags: [rails, deployment]
source: https://coderwall.com/p/yz8cha
---
A quick how-to on deploying a rails app on a digital ocean droplet using nginx, unicorn, postgres and capistrano.

## Summary

The first part of the tutorial is all about setting up a deployment user and ruby / rails environment
on a digital ocean droplet. This is good stuff, and should be useful regardless of whether you're
doing a rails deploy or some other sort of deployment.

The key thing to look at here are the nginx, unicorn, and postgres configurations. These can be used
on other servers besides digital ocean's, and they make for good reading and understanding
of how these technologies relate.

Using capistrano as the standard tool for deploying rails makes sense, once you have this
whole thing set up. There are things you can probably do to make the capistrano deploy
simpler as well.

Ultimately, actual deployment in a true devops sense would be done using puppet or chef, but
for the initiate, this is a good start.

