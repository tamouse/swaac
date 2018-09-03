---
layout: post
title: "Multiple vagrant rails development box setup times"
date: 2015-05-09 21:12
categories: ["vagrant"]
tags: ["rails", "development"]
---
I've recently been looking at the
[Rails.MN Installation](http://http://www.rails.mn/installation/)
setup, and our recommendation to use a Vagrant setup. This seems to
work for most people. [Jason Hsu](https://github.com/jhsu802701) put
together a really nice set of videos to pair along with his Vagrant
setup. I had also been working on a kit to get Ubuntu Trusty
provisioned with Ansible working for some work-related projects.

With the new version of Debian Jessie out, I also wanted to see what
it took to get that up and running.

The results rather suprised me, in the end. While they are all pretty
comparable given download, provisioning, and creating a minimal rails
application, the last combination of using Jessie and Ansible got a
very surprising result in getting the rails app up in under a
minute. The only thing I saw differently was using IO.js instead of
installing the nodejs package from apt-get.

* contents
{:toc}

## Building different vagrant boxes

* Debian Jessie 8 with manual provisioning
* Jason Hsu's Debian Wheezy + RVM <https://github.com/jhsu802701/vagrant_debian_wheezy_rvm>
* Ubuntu 14.04 + Ansible provisioning <https://github.com/tamouse/vagrant-ubu14.04-emacs24-ruby-2.2.0-development>
* Debian Jessie 8 + Ansible provisioning (same as above with some
tweaks for jessie 8: Postgresql 9.4 instead of 9.3)

## Vagrantfiles

All the `Vagrantfiles` were similar, normalizing the following values:

* RAM: 2048MB
* CPUs: 2 cores
* VRAM: 12MB


## Downloading Times

I'm downloading the three source boxes and creating them on my
system.

### Debian Jessie 8

```
$ vagrant box add deb8 https://github.com/holms/vagrant-jessie-box/releases/download/Jessie-v0.1/Debian-jessie-amd64-netboot.box
==> box: Adding box 'deb8' (v0) for provider:
    box: Downloading: https://github.com/holms/vagrant-jessie-box/releases/download/Jessie-v0.1/Debian-jessie-amd64-netboot.box
==> box: Successfully added box 'deb8' (v0) for 'virtualbox'!
```

Elapsed time: approximately 12 minutes.

One thing to note: this box uses the UK Debian mirror. Changing the
`/etc/apt/sources.list` file to use a closer mirror can make a huge
difference in the provisioning times (though not always).

### Jason Hsu Debian Wheezy + RVM

```
$ vagrant box add deb7hsu 'http://downloads.sourceforge.net/project/vagrant-debian-wheezy-rvm/debian-wheezy-rvm-2015_03_07.box?r=&ts=1425788198&use_mirror=master'
==> box: Adding box 'deb7hsu' (v0) for provider:
    box: Downloading: http://downloads.sourceforge.net/project/vagrant-debian-wheezy-rvm/debian-wheezy-rvm-2015_03_07.box?r=&ts=1425788198&use_mirror=master
==> box: Successfully added box 'deb7hsu' (v0) for 'virtualbox'!
```

Elapsed time: approximately 22 minutes.

### Ubuntu Trusty

```
$ vagrant box add ubu1404daily 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
==> box: Adding box 'ubu1404daily' (v0) for provider:
    box: Downloading: https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
==> box: Successfully added box 'ubu1404daily' (v0) for 'virtualbox'!
```

Elapsed time: approximately 16 minutes.

## Provisioning

### Debian Jessie 8

#### Vagrant up

```
real	0m31.201s
user	0m3.744s
sys	0m1.748s
```

#### Manual Provisioning

##### System stuff

```
sudo apt-get update
sudo apt-get install -yqq build-essential
sudo apt-get install -yqq git curl python-psycopg2 postgresql-9.4 postgresql-client libpq-dev sqlite3 libsqlite3-dev libyaml-dev libgdbm-dev libreadline-dev libncurses5-dev libxml2-dev libxslt-dev imagemagick libmagickwand-dev libmagickcore-dev xvfb nodejs
sudo su - postgres -c 'createuser -s vagrant'
createdb vagrant
```

##### RVM, Ruby, Rails, fun

```
/usr/bin/curl -sSL https://rvm.io/mpapis.asc | gpg --import -
/usr/bin/curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
echo 'gem: --no-document' >> /home/vagrant/.gemrc
rvm install 2.2.1
rvm @global do gem install bundler
rvm @global do gem install pry
rvm @global do gem install pry-byebug
rvm @global do gem install rails
```

* started at: 2015-05-09@04:30:12
* ended at: 2015-05-09@05:07:23

Elapsed time: approximately 35 minutes clock time.

This took so long *primarily* because of manual mistakes; typos,
incorrect package names, misfires, and so on.
The commands above represent the final versions *that worked*.
If this was all in a
couple scripts, it would likely have taken less time. Good reason not
to do things manually!

### Jason Hsu Debian Wheezy + RVM

```
vagrant up
real	1m14.191s
user	0m4.777s
sys	0m2.763s
```

This is all that should be needed.

Elapsed time: about 2 minutes.

### Jason Hsu Debian Wheezy + RVM -- REDO

Since I need to make changes in the Postgres setup to make a standard
`rails new` work, I'm redoing this provisioning step to make the
changes manually here.

```
$ time vagrant up
real	1m11.181s
user	0m4.436s
sys	0m2.269s
```

Fxing Postgres permissions, establishing `vagrant` user for Postgres:

```
$ time vagrant ssh
vagrant@vagrant-rvm:~$ sudo -i
root@vagrant-rvm:~# vi /etc/postgresql/9.1/main/pg_hba.conf
root@vagrant-rvm:~# service postgresql restart
[ ok ] Restarting PostgreSQL 9.1 database server: main.
root@vagrant-rvm:~# su - postgres
postgres@vagrant-rvm:~$ createuser -s vagrant
postgres@vagrant-rvm:~$ exit
logout
root@vagrant-rvm:~# exit
logout
vagrant@vagrant-rvm:~$ createdb vagrant
vagrant@vagrant-rvm:~$ psql
psql (9.1.15)
Type "help" for help.
vagrant=# \q
vagrant@vagrant-rvm:~$ exit
logout
Connection to 127.0.0.1 closed.
real	1m13.240s
user	0m1.314s
sys	0m0.397s
```

Elapsed time: appoximately 3 minutes (for both steps).

### Ubuntu Trusty with Ansible

```
vagrant up --provision
real	11m32.594s
user	0m5.733s
sys	0m3.362s
```

```
rvm @global do gem install rails
real	1m27.209s
user	0m29.696s
sys	0m25.426s
```

Also had to do a couple housekeepting things with `nvm`:

```
nvm use iojs
nvm alias default iojs
```

I didn't bother timing those.

Elapsed time: approximately 12 minutes.

### Debian Jessie 8 with Ansible

```
vagrant up --provision
real	9m32.044s
user	0m5.751s
sys	0m3.076s
```

In this case, I added the rails gem installation and nvm housekeeping
to the provisioning package.

Elapsed time: approximately 10 minutes.

## New Rails App

### Debian Jessie 8

```
$ time (rails new myApp -d postgresql --skip-spring --skip-turbolinks && cd myApp && bin/rake db:create && bin/rails g scaffold Post title body:text published:boolean && bin/rake db:migrate)
real	0m56.383s
user	0m14.604s
sys	0m1.540s
```

Elapsed time: approximately 1 minute.

### Jason Hsu Debian Wheezy + RVM

```
rails new myApp -d postgresql --skip-spring --skip-turbolinks
real	1m4.808s
user	0m12.629s
sys	0m2.036s
```

Cannot just run `rake db:create`.

Must now spend time to make simple use of vagrant user in postgresql
automatically.

Required setting `/etc/postgresql/9.1/main/pg_hba.conf` to allow peer
connection on all local users.

Now, these work:

```
rake db:create
rails generate scaffold Post title body:text published:boolean
rake db:migrate
rails server -b 0.0.0.0
```

*However*, could not connect from host machine to VM. Needed to
provide a `private_network` ip address that would work. Utilized the
`resolv` stdlib package and set up local host `/etc/hosts` file.

Connecting to `http://jhsu.local:3000` works as expected now, and can
manipulate posts at `http://jhsu.local:3000/posts` just fine.

Started at: 2015-05-09@05:22:51
Ended at: 2015-05-09@05:47:03

Total elapsed time to make things work: approximately 25 minutes.

However, this is an unfair comparison since most of that 25 minutes
was really spent trying to figure things out to make them work in the
way I'm used to. Once I had that all figured out, I redid the
provisioning and new app steps.

### Jason Hsu Debian Wheezy + RVM -- REDO

After fixing the postgres configuration in the provisioning step,
building the new rails app ran so much faster:

```
$ time (rails new myApp -d postgresql --skip-spring --skip-turbolinks && cd myApp && bin/rake db:create && bin/rails g scaffold Post title body:text published:boolean && bin/rake db:migrate)
real	1m28.536s
user	0m15.681s
sys	0m4.680s
```

Elapsed time: approximately 1.5 minutes

### Ubuntu Trusty with Ansible

```
$ time (rails new myApp -d postgresql --skip-spring --skip-turbolinks && cd myApp && bin/rake db:create && bin/rails g scaffold Post title body:text published:boolean && bin/rake db:migrate)
real	0m54.673s
user	0m15.867s
sys	0m4.743s
```

Elapsed time: approximately 1 minute

### Debian Jessie 8 with Ansible

```
$ time rails new myApp -d postgresql --skip-spring --skip-turbolinks
real	0m37.400s
user	0m11.376s
sys	0m1.204s
```

```
$ time bin/rake db:create
real	0m1.823s
user	0m0.964s
sys	0m0.160s
```

```
$ time bin/rails g scaffold Post title body:text published:boolean
real	0m3.965s
user	0m2.100s
sys	0m0.872s
```

```
$ time bin/rake db:migrate
real	0m3.212s
user	0m1.864s
sys	0m0.592s
```

Wow that was fast.

Trying that again from scratch.

```
$ time (rails new myApp -d postgresql --skip-spring --skip-turbolinks && cd myApp && bin/rake db:create && bin/rails g scaffold Post title body:text published:boolean && bin/rake db:migrate)
real	0m15.154s
user	0m6.088s
sys	0m2.088s
```

Elapsed time: approximately 15 seconds.

**FIFTEEN SECONDS**

# FIFTEEN SECONDS ?!?!?
{:.no_toc}


*******

# Conclusions

From scratch to a running Rails app, times are in approximate minutes:

| package                                   | download | provision | create app | total |
|:------------------------------------------|---------:|----------:|-----------:|------:|
| debian jessie 8 + manual                  |       12 |        35 |          1 |    48 |
| Jason Hsu debian wheezy 7 + rvm           |       22 |         2 |         25 |    49 |
| Jason Hsu debian wheezy 7 + rvm -- REDO   |       22 |         3 |          2 |    27 |
| ubuntu trusty + ansible                   |       16 |        12 |          1 |    29 |
| debian jessie 8 + ansible                 |       12 |        10 |          1 |    23 |
|:------------------------------------------|---------:|----------:|-----------:|------:|
{:.table}


Your mileage will vary, of course, but if you are going the vagrant
route, plan on about a half-hour to be fully up and running with a
development-ready rails kit. Using a pre-built package such as Jason's
is a great idea, provided you also understand the underlying
assumptions that package is making. This is true also of using things
like my starter kit, as well.

# Going Forward

Whatever means you choose to arrive at your development box, you
should take steps to preserve it as well. Repackage the VM and save
the box file somewhere you can retrieve it, with all your personal
customizations and so on. I'll write a future blog post on that.
