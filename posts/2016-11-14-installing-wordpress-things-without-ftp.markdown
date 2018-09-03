---
layout: post
title: "Installing WordPress Things Without FTP"
date: 2016-11-14 00:21
categories: ["wordpress"]
tags: ["installation", "plugins", "themes"]
source: https://codex.wordpress.org/Editing_wp-config.php#WordPress_Upgrade_Constants

---


Recently having set up a couple of WordPress sandbox areas, which
would not have any FTP access points for upgrading and installing WP
themes and plugins, I ran across this feature where the WP install can
"reach out" and pull in the items it needs, rather than telling the WP
repository to push the items to the site.

In the [codex]({{page.source}} "WordPress Upgrade Constants"){:target="_blank"}
there is a section on "WordPress Upgrade Constants", and in particular
it describes `FS_METHOD` which turns the nature of installing upgrades
around.

By adding the following line to the `wp-config.php` file, you can
enable this behaviour:


{% highlight php %}
define('FS_METHOD', 'direct');
{% endhighlight %}

Putting that at the end of the file turns on this ability, which was a
revelation for working on these sandbox sites.

This is what the page has to say:

> FS_METHOD forces the filesystem method. It should only be "direct", "ssh2", "ftpext", or "ftpsockets". Generally, you should only change this if you are experiencing update problems. If you change it and it doesn't help, change it back/remove it. Under most circumstances, setting it to 'ftpsockets' will work if the automatically chosen method does not. Note that your selection here has serious security implications. If you are not familiar with them, you should seek help before making a change.

> * (Primary Preference) "direct" forces it to use Direct File I/O requests from within PHP. It is the option chosen by default.
> * (Secondary Preference) "ssh2" is to force the usage of the SSH PHP Extension if installed
> * (3rd Preference) "ftpext" is to force the usage of the FTP PHP Extension for FTP Access, and finally
> * (4th Preference) "ftpsockets" utilises the PHP Sockets Class for FTP Access.

I chose to use `direct` for the sandboxes.

Take the warning about security implications seriously. You don't want
any production servers to be able to update if someone gains access.

I've handled production upgrades by moving the updated software up to
the production machine myself *after* testing the upgrades. There is
*no* FTP (secure or otherwise) on my production installations. BTDT
got burned badly.
