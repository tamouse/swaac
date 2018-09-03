---
layout: post
title: "DevOps Toolbox: Introduction"
date: 2013-10-08 22:17
categories: [swaac]
tags: [devops,deployment,tools,sysadmin]
source: http://chrislaco.com/devops-toolbox/introduction/
---
A repost of <{{page.source}}>.


> Welcome to the DevOps Toolbox, a step by step guide for the budding devops engineer who wants to enjoy the wonders of modern system configuration and management without having to become the “Server Guy”.
> 
> The goal of this guide to to teach you how to start simple, slowly adding more devops building blocks, and finally ending up with a reusable toolkit for you and your coworkers.
> 
> This guide will take you from a fresh OSX 10.8.2 install all the way through cloud server creation/deployment, including:
> 
> -   Prerequisite Installation (XCode, Homebrew, RVM, Ruby 1.9.3, VirtualBox)
> -   Setup Project Configuration
> -   Vagrant/Veewee Installation
> -   Define/Create Boxes using Vagrant
> -   Provision Machine Instances (locally via VirtualBox)
> -   MultiVM management with Web server talking to a DB server
> -   Configuring Machines using Chef Solo for VirtualBox
> -   Customize Chef Recipes for our Application
> -   Create/Deploy a Simple Rails Application
> -   Migrate Chef Solo to OpsCode/Chef Server
> -   SignUp/Configure RackCloud
> -   Provision cloud servers [re]deploy our application
> 
> While this guide assumes you are on a OSX machine, most of this guide will apply to any Unix/Linux machine with a working compiler, supported Ruby version, and supported version of VirtualBox. While RackCloud is used, the same basic concepts and steps will apply to other cloud providers, like Amazon AWS/EC2.
> 
> **Let’s Get Started!**
> 
> 1.  [Installing Prerequisites](http://chrislaco.com/prerequisites/) – XCode, CommandLineTools, Homebrew, RVM, Ruby, and VirtualBox
> 2.  [Project Setup](http://chrislaco.com/project-setup/) – Create the git repository and directory structure for Vagrant, Chef, etc.
> 3.  [Vagrant/Veewee Installation](http://chrislaco.com/vagrant-veewee-installation/) – Install Vagrant/Vewee to create/control VirtualBox machines
> 4.  [Define/Create a Vagrant Box](http://chrislaco.com/define-create-vagrant-box/) – Define and Create a Vagrant Box for use i VirtualBox
> 5.  [Provisioning Machines with Vagrant](http://chrislaco.com/provisioning-machines-with-vagrant/) – Provision a cluster (Web/DB) of machines using Vagrant
> 6.  [Configuring Machines Using Chef Solo](http://chrislaco.com/configuring-machines-using-chef-solo/) – Configuring our new machine instances using Chef Solo
> 7.  [Customizing Recipes for Our Application](http://chrislaco.com/customizing-recipes-for-our-application/) – Customize the recipes we have to prepare for our application deployment
> 8.  [Create and Deploy a Rails Applications](http://chrislaco.com/create-deploy-rails-application/) – Create a simple Rails application and deploy it to our Vagrant instances
> 9.  [Migrate from Chef Solo to Hosted Chef](http://chrislaco.com/migrate-to-hosted-chef/) – Migrate from using Chef Solo to hosted Chef at OpsCode
> 10. [Migrate Servers to RackCloud](http://chrislaco.com/migrate-to-rackcloud/) – Migrate your servers from VirtualBox to “The Cloud” using Rackspace.
> 
