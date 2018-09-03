---
layout: post
title: "How I Set Up my Local WordPress Development Environment Using Vagrant and Ansible"
date: 2017-02-11 22:17
categories: ["wordpress"]
tags: ["wordpress", "vagrant", "ansible", "local", "sandbox"]
source: https://github.com/tamouse/sandbox.wp.local

---

As part of my volunteering with [GDI Minneapolis][gdimpls], I've been
getting back into WordPress development (child themes, custom themes,
etc.), while TAing, teaching, and helping develop some classes. One of
the key things we want to show students is how to develop their sites
safely and learn the trade of software development in the WordPress
environment.

[gdimpls]: https://gdiminneapolis.com "Girl, Develop it! Minneapolis Chapter"

There are several ways one can do this. There are some really
*excellent* tools out there now that make this a snap for people not
versed in setting things up themselves.

* [Local by Flywheel][flywheellocal]
* [DesktopServer from ServerPress][desktopserver]

[flywheellocal]: https://local.getflywheel.com "Local by Flywheel: Local WordPress development made simple"
[desktopserver]: https://serverpress.com/get-desktopserver/ "Get DesktopServer and save time!"

There are also traditional ways of installing [MAMP] on MacOSx, or using
a [Turnkey Linux WordPress Appliance][tklwp], and so many other ways.

[MAMP]: https://www.mamp.info/en/ "My Apache, MySQL, and PHP"
[tklwp]: https://www.turnkeylinux.org/wordpress "Turnkey Linux WordPress Appliance"

This is how I set up my local environment using two tools I use
heavily in other areas of web development:

* [Vagrant]
* [Ansible]

[Vagrant]: https://www.vagrantup.com/ "Development environments made easy"
[Ansible]: https://www.ansible.com/ "Automation for everyone"


*******

First off, this is going to be less of a tutorial and more a
description of what I'm doing. I'm definitely not holding this out as
a definitive way to set up your local WordPress development
environment, but *my* way that works for me. If you're brand new to
all this, and don't want to learn all about systems and devops, then I
recommend using one of the first two options above. (I've played a bit
with [Local][flywheellocal], and find it amazingly intuitive and
simple, so that's my latest recommendation.)

Secondly, the sandbox setup is available on GitHub
at
[github.com/tamouse/sandbox.wp.local](https://github.com/tamouse/sandbox.wp.local) so
feel free to fork it, and do what you want with it. I'll happily take
PRs if you find bugs, too.



*******

## Starting Point

My working system:

* Macbook Pro 13"
* 8 GiB RAM
* 4 CPU Cores
* about 50 GiB free disk space (I didn't need anywhere near this, it's
  just what was there when I started.)

## Prerequisites

### Available Software

This is stuff I already had on my system because of other development
I do.

* HomeBrew
* VirtualBox
* Vagrant
* Ansible

## Steps to Get Things Set Up

### Create a project folder and initialize it

I always start my projects the same way:

```
mkdir -p ~/Projects/wordpress-stuff/sandbox.wp.local
cd ~/Projects/wordpress-stuff/sandbox.wp.local
git init
echo 'Local WordPress Development Sandbox running in Vagrant with Ansible Provisioning' | tee README.md > .git/description
hub create -d "$(cat .git/description)"
git add -Av
git commit -m 'initial commit'
git push -u origin master
```

(Truth be told, this is one of my bash functions, so it really looked
like this:

```
new_proj sandbox.wp.local 'Local WordPress Development Sandbox running in Vagrant with Ansible Provisioning' 'initial commit'
```

)

### Run `vagrant init`

I typically use one of the later Ubuntu server variants; mostly I've
been using 'trusty':

```bash
vagrant init 'ubuntu/trusty64'
```

This writes out a default `Vagrantfile` (which is written in Ruby).

### Modify `Vagrantfile` for my needs

I modify the file so it looks like so:

{% highlight ruby linenos %}
BOX_NAME="sandbox.wp.local"
DEFAULT_IP="192.168.33.35"

require "resolv"

def my_ip
  @my_ip ||= Resolv::Hosts.new.getaddress(BOX_NAME) || DEFAULT_IP
rescue
  @my_ip ||= DEFAULT_IP
end
Vagrant.configure(2) do |config|

  config.ssh.forward_agent = true

  config.vm.define :sandbox_wp do |sb|
    sb.vm.box      = "ubuntu/trusty64"
    sb.vm.network  "private_network", ip: my_ip
    sb.vm.network  "forwarded_port", guest: 80, host: 8088
    sb.vm.hostname = BOX_NAME

    sb.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      # vb.gui = true

      # Customize the amount of memory on the VM:
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--vram", "18"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

  config.vm.provision :ansible do |a|
    a.playbook = 'ansible/sandbox.yml'
    # a.verbose  = 'vvvv'
  end
end
{% endhighlight %}

Some explanation about the various settings:

```ruby
BOX_NAME="sandbox.wp.local"
DEFAULT_IP="192.168.33.35"
```

These define two constants that get used later in the `Vagrantfile`. I
edited my machine's `/etc/hosts` file, which maps IP addresses to
hostnames locally. The line I added to `/etc/hosts` looks like so:

```
192.168.33.35	sandbox.wp.local sandbox
```

This lets me type 'http://sandbox/' or 'http://sandbox.wp.local' in
the browser address bar to access the web server that will be running
in the Vagrant Virtual Machine (aka "VM").

(Note: when I used [Local][flywheellocal], it did something similar.)

Then I'm bringing in ruby's `resolv` standard library, which gives the
ability to use that mapping given in the `/etc/hosts` file; the
`DEFAULT_IP` constant provides a fallback in case it can't find
`BOX_NAME` in `/etc/hosts`.

The `my_ip` method defined sets and returns the IP address to be used
for my WordPress sandbox.

With all that handled, vagrant can begin it's configuration. Most
everything from here out can be found in vagrant's documentation, if
you want.

```ruby
  config.ssh.forward_agent = true
```

I set this to true so when I'm logged into the vagrant box, it will
use my ssh keys from my development machine; this is especially
helpful when using git commands that talk to GitHub, etc.

```ruby
    sb.vm.network  "private_network", ip: my_ip
```

Here is where that calculation for figuring out what IP address to use
that matches the name 'sandbox.wp.local' I set up is made.

```ruby
    sb.vm.hostname = BOX_NAME
```

This sets the VM host name, so it will match 'sandbox.wp.local' when
I'm logged in.


```ruby
      vb.customize ["modifyvm", :id, "--memory", "2048"]
```

This reserves 2GiB of RAM for the VM.


```ruby
      vb.customize ["modifyvm", :id, "--vram", "18"]
```

This reserves 18MB of RAM for the video buffer.


```ruby
      vb.customize ["modifyvm", :id, "--cpus", "2"]
```

This allows up to 2 CPU Cores to be used by the VM.


```ruby
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
```

This does some magic to use the host machine's DNS resolver to find
IP address, which pulls in the magic of mapping 'sandbox.wp.local'.


```ruby
  config.vm.provision :ansible do |a|
```

Tells vagrant I'm using Ansible provisioning.

```ruby
    a.playbook = 'ansible/sandbox.yml'
```

Specifies the Ansible 'playbook'


```ruby
    # a.verbose  = 'vvvv'
```

Leaving this commented out, but usually it's uncommented for me to be
able to debug things during provisioning.

### Make a git savepoint

Committing the current changes at this point to create a "save point"
to get back to if I end up mucking things up.

```
git add -Av && git commit -m 'Vagrantfile updated' && git push
```

(And this is also a bash function:

```bash
gacp 'Vagrantfile updated'
```
)

At this point, I decided I would make a branch to work on Ansible
stuff, too:

```bash
git checkout -b ansible-playbook
```

### Create the Anisble Playbook

Ansible playbooks are build as YAML files, which is just a way of
specifying structured data. It's akin to JSON and XML.

I made the ansible playbook in the `ansible` subdirectory, the
structure is:

```
ansible/
  group_vars/
    all.yml
  roles/
    external/
	  .keep
	internal/
	  cleanup/
	    tasks/
		  main.yml
	  common/
	    tasks/
		  install.yml
		  main.yml
	requirements.yml
  sandbox.yml
  sudo_roles.yml
```

### Top level playbook

[`sandbox.yml`](https://github.com/tamouse/sandbox.wp.local/blob/master/ansible/sandbox.yml) is
the top-level playbook that sets the whole provisioning activity
off. It is simple and just contains:

```yaml
---
- include: sudo_roles.yml
```

### Sudo Roles Playbook

[`sudo_roles.yml`](https://github.com/tamouse/sandbox.wp.local/blob/master/ansible/sudo_roles.yml) is
the playbook that runs all the roles that need to be performs as the
superuser. In this project, that's all of them. My playbook goes in
the following order:

- internal/common
- external/calebwoods.brightbox_ruby
- external/geerlingguy.nodejs
- external/geerlingguy.apache
- external/geerlingguy.mysql
- external/geerlingguy.php
- external/darthwade.wordpress
- external/darthwade.wordpress-apache
- internal/cleanup

### Defining External Requirements

In building this up, my starting point was to figure out what
pre-built roles I could use to install the software and
configurations I would need. These filled out
[`roles/requirements.yml`](https://github.com/tamouse/sandbox.wp.local/blob/master/ansible/roles/requirements.yml). I'm using these roles:

- [`geerlingguy.nodejs`](https://galaxy.ansible.com/geerlingguy/nodejs/) - installs the latest stable version of Node.js
- [`geerlingguy.apache`](https://galaxy.ansible.com/geerlingguy/apache/) - the Apache 2.x web server
- [`geerlingguy.mysql`](https://galaxy.ansible.com/geerlingguy/mysql/) - MySQL database management system, 5.x
- [`geerlingguy.php`](https://galaxy.ansible.com/geerlingguy/php/) - PHP language, 5.x
- [`darthwade.wordpress`](https://galaxy.ansible.com/darthwade/wordpress/) - WordPress installation
- [`darthwade.wordpress-apache`](https://galaxy.ansible.com/darthwade/wordpress-apache/) - Apache requirements for WordPress
- [`calebwoods.brightbox_ruby`](https://galaxy.ansible.com/calebwoods/brightbox_ruby/) - Ruby 2.x because I like working in
  Ruby, too

Each of these requires some configuration. The configuration settings
are defined
in
[`group_vars/all.yml`](https://github.com/tamouse/sandbox.wp.local/blob/master/ansible/group_vars/all.yml). I
set things up as follows:

- enable apache `rewrite_mod`
- MySQL root password
- MySQL WordPress database and user `vagrant`
- Ruby version 2.2 and 2.3
- Node.js version 6, npm user `vagrant`
- Various PHP options and modules:

  - `php5`, `php5-cli`, `php5-common`, `php5-curl`, `php5-dev`,
    `php5-gd`, `php5-mysql`
  - memory limit: 128MiB
  - execution time: 90s
  - max file upload size: 256MiB
  - disable apcu

- WordPress Configurations

  - version 4.0
  - install directory `/var/www/sandbox_wp`
  - db user: `vagrant` (match above)
  - db host: `localhost`

  - hostname: `sandbox.wp.local`
  - alias: 'sandbox'
  - admin email: "admin@example.com" (because I'm not sending any
    emails)

### Internal Requirements

These are things I installed and configured myself without relying on
pre-defined roles.

Because the `sudo_roles.yml` file calls `internal/common`,
`roles/internal/common/tasks/main.yml` gets run automatically during
provisioning. It calls
in
[`roles/internal/common/tasks/install.yml`](https://github.com/tamouse/sandbox.wp.local/blob/master/ansible/roles/internal/common/tasks/install.yml) which
I'm using to install necessary software packages.

After updating the APT caches, I installed:

- build-essential
- ntp
- git
- vim
- emacs24
- unzip
- imagemagick
- libmagick-dev
- libxml2
- libxml2-dev

WordPress definitely doesn't need all of these, but my development
tools and workflow generally do, and that's what this is all about.

### Final configuration and cleanup

After installing all the internal and external roles, I still had some
things I wanted to configure and clean up. These went
into
[`roles/internal/cleanup/tasks/main.yml`](https://github.com/tamouse/sandbox.wp.local/blob/master/ansible/roles/internal/cleanup/tasks/main.yml) and
included:

- enabling the VHosts module for Apache2
- disable the default and vhosts sites
- reset user and group ownership of the WordPress site to `www-data`
- use the `direct` method for `FS_METHOD` which lets the WordPress
  installation directly update from the codex without using FTP.

### Another Git Save Point

Yep. This is how I roll.

```bash
gacp 'Ansible Playbook Created'
```

### Gathering the External Requirements

Specifying the external requirements is not enough, I needed to tell
ansible to fetch them.

```bash
ansible-galaxy install -r ansible/roles/requirements.yml --force --ignore-errors
```

### Bringing up the VM and first provisioning

Now I was ready to pull together all the prior stuff and build the
box.

```bash
vagrant up
```

The first time you run `up` vagrant will start running the
provisioning after the box comes up. After this first time, however,
when you run the `up` command, vagrant doesn't try to
reprovision.

So, you know, the first time you try something, you mistype something,
or you forget a configuration value, and so on. I know I did. I don't
recall the specifics, but it doesn't really matter, trial and error,
get things working, figure stuff out, and eventually I ended up with a
clean provisioning.

You don't need to keep running the `up` command, you run the
`provision` command instead while the box stays up. Since the point of
ansible is to provide an "idempotent" (i.e. same result each time
it's run) solution, it will check if it's successfully run a step and
skip over it. So my provisioning actually looked something like:

```bash
vagrant up
# something broke, fix it
vagrant provision
# something broke, fix it
vagrant provision
# something broke, fix it
vagrant provision
# something broke, fix it
vagrant provision
# and so on
vagrant provision
# yay it finally worked!
```

### And another save point, and merge back to master

```
gacp 'Anisble provisioning works! Yay!`
git checkout master # aliased to: gco master
git merge ansible-playbook
gacp 'Merging ansible-playbook to master'
```

Whew!

### Set up WordPress Installation

I was now ready to give the WordPress five-minute installation a go. I
fired up my browser at `http://sandbox.wp.local` and there was the
installation page, just as I'd hoped.

After running through that, playing with appearance, plugins, making a
couple posts and pages, I was feeling good.

I tried installing some themes and plugins from the WordPress codex,
and they installed nicely. Updated the WordPress installation itself,
and everything was great.

## Creating a development environment

This is really the whole point of this exercise: I wanted a sandbox
that would let me develop child and custom themes, plugins, other
custom things as I wanted, using my local machine to edit things, and
apply my favourite tools including Sass, gulp, ruby, and so on.

With the WordPress install running in `/var/www/sandbox_wp` under
`www-data`, I still needed a way to be able to edit files locally and
have them show up under the WordPress site.

The `wp-content` folder is used for a few things, but most important
to this task, I wanted to be able to have themes and plugins available
for local editing.

Logging into the VM, I created a folder `/vagrant/dev`, which would
show up on the local machine in the project root as just `dev/`.

```bash
mkdir /vagrant/dev
```

Then I recursively copied the contents of
`/var/www/sandbox_wp/wp-content/themes` and
`/var/www/sandbox_wp/wp-content/plugins` to `/vagrant/dev/`, which
created two folders `/vagrant/dev/themes` and `/vagrant/dev/plugins`.

```bash
cp -r /var/www/sandbox_wp/wp-content/themes /vagrant/dev
cp -r /var/www/sandbox_wp/wp-content/plugins /vagrant/dev
```

### Creating a little demo custom theme

To test things out, I created a custom theme under `dev/` on the local
machine, and filled with some bare-bones content:

```bash
mkdir -p dev/themes/demo
```

The
[demo content](https://github.com/tamouse/sandbox.wp.local/tree/master/dev/themes/demo) was
pretty complicated to set up, and I'm not going into it here. Easier
would have been just making a child theme to try stuff out.

### Telling WordPress about the Custom Theme

Back over on the VM, I needed to tell the WordPress installation about
this new custom theme:

```bash
cd /var/www/sandbox_wp/wp-content/themes
sudo ln -s /vagrant/dev/themes/demo .
```

Popping back over to the browser, and pulling up the Appearances ->
Themes menu, lo and behold, the custom theme now showed up.

## The development workflow

I now could edit files comfortably in my local editor of choice,
saving files, and view the results by refreshing the browser pointing
at the WordPress site running in the VM.

## Final Thoughts

I created this set up initially during [WordCamp MSP 2016][wcmsp2016]
for the fundamentals day so I could have a local hacking spot without
trying to roll up a remote server or build up a local server that I
may not want to keep around.

(This is why the demo custom theme is as complex as it is.)

One of the excellent things about using Vagrant and Ansible is the
ease of which you can spin something up again if you want to. However,
for future WordPress development work, I will probably be going
with [Local][flywheellocal] because it is *such* a slick product, and
that's what I'm recommending to my WordPress students.

[wcmsp2016]: https://2016.minneapolis.wordcamp.org/ "WordCamp MSP 2016"
