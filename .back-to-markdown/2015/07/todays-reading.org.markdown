Today\'s Reading
================

**WARNING: This is old and likely obsolete.**

-   published date: 2015-07-12 11:59
-   keywords: \[\"links\", \"nfs\", \"vagrant\"\]
-   source:
-   links: \[{\"href\"=\>\"<http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines>\", \"text\"=\>\"Comparing Filesystem Performance in Virtual Machines\"}\]

Stuff I\'m reading today, Sun Jul 12 12:00:14 2015:

\[\[<file:%7B%7B%20page.links%5B0%5D.href%7D%7D>\]\[{{ page.links\[0\].text}}\]\] {#page.links0.text}
---------------------------------------------------------------------------------

Continuing in the reading about Docker and Vagrant. This article discusses the various file system characteristics using Vagrant file sync. The bottom line:

> With regards to shared filesystems, VMware has the behavior you want. Loading web pages, running test suites, and compiling software are all very read heavy. VMware shared folder read performance demolishes VirtualBox, while the write performance of VirtualBox shared folders is only marginally better than VMware.

> If you have the option to use NFS, use it. Again, the read performance is far more valuable than the write performance.

> <footer>
>
> {{page.links\[0\].text}}, Mitchell Hashimoto, January 10, 2014.
>
> </footer>
