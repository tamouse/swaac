---
layout: post
title: "My nginx Virtual Hosting Configuration"
date: 2016-09-25 13:29
categories: ["devops"]
tags: ["nginx", "configuration", "virtualhosts", "web-hosting", "static-site"]

---

I've been running my static sites using [nginx](http://nginx.com) for ages, it seems,
and I came upon a pretty useful nginx configuration that doesn't
require changing much to put up a new static site.

Nginx's configuration documentation requires a fair amount of digging
to put the whole thing together, but there have also been generous
folks who blog about their configuration work, triumphs and
tribulations.

This configuration is by no means unique, special, or anything other
than a thing I cobbled together and that works for my needs.


{% highlight nginx linenos %}
# -*- nginx -*-
# This is a generic virtual host file, it will map vhosts onto
# the appropriate subdirectory

server {

    listen   80; ## listen for ipv4
    listen   [::]:80 default ipv6only=on; ## listen for ipv6

    # the following matches anything in HTTP_HOST, mapping www.$domain to $domain.
    # www.example.com and example.com will map to /var/www/example.com
    # www.wiki.example.com and wiki.example.com will map to /var/www/wiki.example.com
    server_name  ~^(www\.)?(?<domain>.+)$;
    root   /var/www/$domain;
    index  index.html index.htm index.php;

    # Uncomment to use per-domain access log
    #access_log  /var/log/nginx/$domain.access.log;

    location / {
	try_files $uri $uri/ /index.php;
    }

    location @rewrites {
	rewrite ^ /index.php last;
    }

    # This causes too many problems when posting a blog update.
    # # static files
    # location ~* \.(?:ico|css|js|gif|jpe?g|png|te?xt|html?)$ {
    #     expires max;
    #     add_header Pragma public;
    #     add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    # }

    location = /robots.txt { access_log off; log_not_found off; }
    location = /favicon.ico { access_log off; log_not_found off; }

    # deny access to . files and editor backup files
    location ~ /\. { deny  all; }
    location ~ ~$ { deny all; }

    # php files
    location ~ \.php {
	location ~ \..*/.*\.php$ { return 404; }
	include fastcgi_params;
	fastcgi_split_path_info ^(.+\.php)(/.+)$;
	fastcgi_param PATH_INFO $fastcgi_path_info;
	fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	fastcgi_pass unix:/var/run/php5-fpm.sock;
    }

}
{% endhighlight %}

I originally had the static file caching in place, but since I mainly
post blog updates that are static, it was always forcing readers to
refresh my pages in their browsers. I get such small amounts of
traffic that just serving the static pages hasn't really made any
difference to my overall site performance, and everyone always gets
fresh content.

This sets up a structure that recognizes virtual hosts and points them
to a directory that matches that host name. So
"http://swaac.tamouse.org" will look for `/var/www/swaac.tamouse.org`.

On my server, I've also further symlinked `/var/www/swaac.tamouse.org`
to `/home/tamara/Sites/tamouse.org/swaac` which holds the actual
static site files, and is writeable by my user without any need to go
superuser.

Further discussion about how I deploy to these sites using git can be
found at [Using Git to Deploy Static Sites]({% post_url 2016-01-13-using-git-to-deploy-static-sites %})
