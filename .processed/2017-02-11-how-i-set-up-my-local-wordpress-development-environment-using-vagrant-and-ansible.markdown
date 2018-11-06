# How I Set Up my Local WordPress Development Environment Using Vagrant and Ansible

- published date: 2017-02-11 22:17
- keywords: ["ansible", "local", "sandbox", "vagrant", "wordpress"]
- source: https://github.com/tamouse/sandbox.wp.local



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

```ruby linenos
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
```

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
