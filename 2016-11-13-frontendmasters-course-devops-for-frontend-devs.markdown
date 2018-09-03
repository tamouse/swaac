---
layout: post
title: "FrontendMasters Course: DevOps for Frontend Devs"
date: 2016-11-13 12:52
categories: ["class"]
tags: ["frontendmasters", "devops", "jemyoung"]
source: URL
---

On November 11, 2016, I attended
the [FrontendMasters](https://frontendmasters.com){:target="_blank"}
course "DevOps for Frontend Devs" taught
by [Jem Young](https://jemyoung.com/about/){:target="_blank"} from
Netflix.

It was a great class. Here's the checklist I built for bringing up a
basic droplet on [Digital Ocean](https://digitalocean.com){:target="_blank"}

## create an ssh key pair

You can reuse one you already have, or create a new one. Make sure
it's on DigitalOcean and create the droplet with it.

-   [ ] upload the PUBLIC key you created or are reusing to
    DigitalOcean.

## create a new server

-   [ ] create a droplet on DO
-   [ ] copy and save the new droplet's IP address
    -   [ ] add to /etc/hosts to make it easy
    -   [ ] also create an entry for it in `~/.ssh/config`


{% highlight bash %}
Host <DROPLET NAME>
  User tamara
  IdentityFile ~/.ssh/id_rsa
  AddkeysToAgent yes
  ForwardAgent yes
  HostName <DROPLET IP>
{% endhighlight %}


-   [ ] log into the new droplet

## on the new server, as root

-   [ ] Change root password to something you know (DO set's it to
    something randome and never tells you what it is.)
    -   [ ] `passwd`
-   [ ] `apt-get update` to refresh DPKG indexes
-   [ ] `apt-get install -y build-essential git curl wget emacs zip unzip zlibc zlib1g-dev` My
    tools of choice
-   [ ] `apt-get install -y htop` nice top() replacement

## create users with sudo

-   [ ] add user `tamara`:
    -   [ ] `adduser tamara`
    -   [ ] `usermod -aG sudo tamara`
    -   [ ] `mkdir -p ~tamara/.ssh`
    -   [ ] `cp ~/.ssh/authorized_keys ~tamara/.ssh/`
    -   [ ] `chown -R tamara:tamara ~tamara/.ssh/`

-   [ ] add new user `git`
    -   [ ] `adduser git`
    -   [ ] `usermod -aG sudo git`
    -   [ ] `mkdir -p ~git/.ssh`
    -   [ ] `cp ~/.ssh/authorized_keys ~git/.ssh/`
    -   [ ] `chown -R git:git ~git/.ssh`

## back on the home machine

If you copied the authorized keys file in the above steps, the
following is not needed.

-   [ ] move public key to users
    -   Users: [tamara, git]

            cat ~/.ssh/is_rsa.pub | ssh $USERa@$NEW_SERVER 'mkdir -p .ssh && cat >> .ssh/authorized_keys

## on new server, regular user (from now on)

-   Disable access via `ssh` for `root`
    -   [ ] `sudo vi /etc/ssh/sshd_config`
    -   [ ] Set `PermitRootLogin: no`
    -   [ ] restart: `sudo service sshd restart`

## get a domain name

(optional, but kind of nice for easy referral
from everywhere.)

-   [ ] buy a domain name from some place
-   [ ] for the domain, create 2 "A" records
    -   [ ] "@" point to new server's IP
    -   [ ] "www" point to new server's IP
-   [ ]

## set up the web server

-   [ ] install nginx
-   [ ] install nodejs and npm: following instructions
    on
    [nodesource/distributions](https://github.com/nodesource/distributions#installation-instructions)


{% highlight bash %}
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
{% endhighlight %}


-   [ ] <del>symlink node -> nodejs<del> Not necessary with the above

-   [ ] install ruby
    using
    [Brightbox.Com](https://www.brightbox.com/docs/ruby/ubuntu/#adding-the-repository):


{% highlight bash %}
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.4
sudo gem install bundler rake
sudo gem install rails
{% endhighlight %}


## setting up the application

-   [ ] clone the app
-   [ ] cd into the app dir
-   [ ] `npm install`
-   [ ] `node app.js`
-   [ ] `nohup node app.js &` to make it run forever in the background

## build and deploy an app

-   using Gulp
