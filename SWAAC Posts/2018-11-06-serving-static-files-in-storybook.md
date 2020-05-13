**WARNING: This is old and likely obsolete.**

\[2018-11-06 Tue 08:40\] TIL: serving static files in storybook
===============================================================

-   last~update~: Time-stamp: \<2020-03-23 05:07:36 tamara\>
-   capture~date~: \[2018-11-06 Tue 08:40\]
-   keywords: storybook, test data, static assets

I wish I\'d known about this before taking all that time to munge the test data the first time. It turns out storybook can serve up static assets by providing the `-s` option on the command line:

``` {.shell-script}
start-storybook -p 9009 -s ./path/to/static/assets -c .storybook/config.js
```

You can have more than one folder as well, separating them by commas

``` {.shell-script}
start-storybook -p 9009 -s ./some/assets,./other/assets,./these/assets/over/here -c .storybook/config.js
```

This makes them available at the root URL

``` {.shell-script}
http://localhost:9009/
```

So if you have assets at `./src/components/AttachmentList/__TEST_DATA__/attachments/`, for example, `shasta/32/original/002.jpg`, then the URL would be:

``` {.shell-script}
http://localhost:9009/shasta/32/original/002.jpg
```

And even more importantly, they can be referred to relatively even without the scheme and host.
