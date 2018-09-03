---
layout: post
title: "HowTo: Quick Steps to Install Emacs 24 without X on Ubuntu"
date: 2014-10-03 09:31
categories: [technology]
tags: [emacs, howtos, ubuntu, installation]
---
Following steps from here: [http://ubuntuforums.org/showthread.php?t=1999720](http://ubuntuforums.org/showthread.php?t=1999720)

{% highlight console linenos %}
> # Obtain latest emacs from Savannah: http://ftp.gnu.org/gnu/emacs/
> wget http://ftp.gnu.org/gnu/emacs/emacs-24.3.tar.gz 

> # Install dependencies:
> sudo apt-get install libjpeg-dev libpng-dev libgif-dev \
>   libtiff-dev libncurses-dev -y 

> # Untar the archive:
> tar xvfz emacs-24.3-rc.tar.gz

> cd emacs-24.3

> # Do not include the X-Windows system code (just CLI version)
> ./configure --without-x

> make

> sudo make install
{% endhighlight %}

[Download source](/downloads/install-emacs-24-without-x-on-ubuntu.txt)
