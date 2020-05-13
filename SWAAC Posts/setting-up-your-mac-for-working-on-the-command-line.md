**WARNING: This is old and likely obsolete.**

Setting up your Mac for working on the command line.
====================================================

-   Time-stamp: \<2020-03-23 05:01:06 tamara\>
-   published date: 2017-07
-   keywords: command line, cli, termoial, mac

Before beginning, I strongly urge you to get Michael Hartl\'s [Learn Enough Command Line to Be Dangerous](https://www.learnenough.com/command-line-tutorial) which is seriously the best introduction to this whole thing.

See also: \[Conventions Used in This Section\]({{ \"/pages/learning/beginner/conventions-used-in-this-section\"}}).

Intro
-----

I\'d love to provide the TL;DR for this, but I can\'t. I don\'t know what\'s on your system already, what level you\'re at, or even a kind voice to listen to your questions and respond.

Using the caommand line effectively means having it configured to your needs. So this page is going to introduce how to configure your command line.

There are two, sometimes three, files involved in this:

-   `.bash_profile`
-   `.profile`
-   `.bashrc`

The rest of this will tell you how to set them up.

You\'ll need to know
--------------------

-   [How to open Terminal on a Mac](%7B%7B%20site.baseurl%20%7D%7D/pages/learning/beginner/how-do-i-get-to-the-command-line-on-a-mac/)
-   Various shell commands:

    -   `cd`
    -   `chmod`
    -   `cp`
    -   `echo`
    -   `ls`

Gathering Current Information
-----------------------------

1.  [Open up the Terminal](%7B%7B%20site.baseurl%20%7D%7D/pages/learning/beginner/how-do-i-get-to-the-command-line-on-a-mac/)

2.  Run the command:

``` {.example}
ls -1 .profile .bash_profile .bashrc
```

The \"-1\" (\"minus-one\") option produces a listing of file names in a single column. It\'s not necessary, but it\'s a little easier to read for short listings.

The `ls` command has *lots* of options which can be learned about using the `man ls` command and reading the manual page.

You could see something like the following:

``` {.example}
ls: .bash_profile: No such file or directory
ls: .bashrc: No such file or directory
ls: .profile: No such file or directory
```

in which case you don\'t have any of those files, which is okay.

You might see something like this:

``` {.example}
ls: .bash_profile: No such file or directory
ls: .profile: No such file or directory
.bashrc
```

in which case you have the `.bashrc` file, but you don\'t have the others, which is also okay.

In fact, *any* combination is okay, there\'ll be a section below on each case.

Here are the combinations:

1.  You don\'t have any of them (default OSX setup)
2.  You have `.profile` but not the other two
3.  You have `.bash_profile` but not the other two
4.  You have `.bashrc` but not the other two
5.  You have `.bash_profile` and `.bashrc`, but not `.profile`
6.  You have `.profile` and `.bashrc`, but not `.bash_profile`
7.  You have all three

If you don\'t have any of the three files
-----------------------------------------

In this section, we\'ll talk about when none of those files exist yet. This is easiest to deal with starting off.

### What are the `.bash_profile` and `.profile` file about?

On Unix- and Linux-based systems, the command line is also referred to as \"The Shell\". By default, Mac\'s use the program \"bash\" as the command line shell.

When you start up Terminal, it launches a \"login shell\" by starting the program `/bin/bash`. This program then looks for two files in your user\'s \[home directory\]\[homedir\]: `.bash_profile` and `.profile`.

It\'s important to note that if `bash` finds `.bash_profile`, it will run that file, otherwise it will run `.profile`. There may come a time when you install a software development command-line tool that creates a `.bash_profile`, and you can find all the things you put in `.profile` are not being set up. Likewise, you might install a software command line tool that only expects things to be initialized in `.profile` and then that tool\'s setting won\'t happen correctly. It\'s confusing, to be sure.

There\'s always more than one way to deal with this, of course. Perhaps the best way is to start with the `.bash_profile` and make all your initialisation happen there.

I prefer to do the following though:

1.  Create a `.bash_profile` in your home directory with the following contents:

``` {.example}
#!/bin/bash
[ -f $HOME/.profile ] && source $HOME/.profile
```

What this does is execute the `.profile` file if it exists. In this way you can have initialisation code put in either file and it will be run. The *major* caveat on this is to make sure if there\'s initialisation code in both `.bash_profile` and `.profile` it does not cause any problems if it gets run twice. Usually this is okay, but it can be a source of errors.

1.  Create the `.profile` file and place the initialisation codes you want to manage there.

### The `.profile` file

As noted, this file contains initialisation codes. Here\'s where you can set environment variables that are used throughout your command line sessions.

One such environment variable is `PATH` -- this is the variable used to find command line programs on your computer. Sometimes you\'ll need to extend this variable when you install a new piece of software.

Jump into your command line now and type:

``` {.example}
$ echo $PATH
```

Incidently, that *first* \"$" on the line above is *not* part of the command; it is there to indicate the command line prompt (which could be much more complicated). It's used here to tell you something you should be typing. What you'll actually type is what follows the space after the "$\", i.e. just \"echo \$PATH\".

On the stock Mac install, you\'ll probably see something like:

``` {.example}
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

(It might be slightly different, or it might have been changed previously.)

Let\'s take the case where you just recently install the \"Sass\" program which pre-processed CSS files in a special format. After you\'ve run the `gem install sass --user-install` command, you may have seen a warning like the following:

``` {.example}
WARNING:  You don't have /Users/noob/.gem/ruby/2.0.0/bin in your PATH, gem executables will not run.
```

While not an error, not addressing this warning is going to be very painful for you.

So let\'s add that indicated directory to our PATH environment variable. We do this in the `.profile` file like so:

``` {.example}
export PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
```

Save and close your `.profile` file, switch back to your command line, and type the following:

``` {.example}
$ source $HOME/.profile
$ echo $PATH
```

Now you should see the following:

``` {.example}
usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/noob/.gem/ruby/2.0.0/bin
```

If you have `.bash_profile`, but none of the others
---------------------------------------------------

If you already have one, the easiest is to add the following line at the bottom of the file:

``` {.example}
[ -f $HOME/.profile ] && source $HOME/.profile
```

then save and close the file.

Then open a new file named `.profile` and enter the following in it:

``` {.example}
\#!/bin/bash
```

Then you can add whatever other initialisation codes you want in `.profile`. Follow the example in the previous section to append something to your `PATH` environment variable.

If you have `.profile`, but none of the others
----------------------------------------------

Create a `.bash_profile` in your home directory with the following contents:

``` {.example}
\#!/bin/bash
[ -f $HOME/.profile ] && source $HOME/.profile
```

That\'s all, really.

If you do NOT have a `.bashrc` file
-----------------------------------

This is the default starting point for a new user.

### What is the `.bashrc` file all about?

The `.bashrc` file in your home directory will be executed whenever an *interactive* shell gets invoked. Calling `bash` from the command line from a is considered an *interactive* shell. It is *not* run, however, when a *login* shell is started, which is what happens when you start up a new Terminal window.

Confusing? Yes. Try the following to see what is happening.

Edit your `.profile` and add the following line to the end:

``` {.example}
echo ".profile ran"
```

Edit `.bashrc` (creating it if necessary) and put the following at the end:

``` {.example}
echo ".bashrc ran"
```

Now open a *new* Terminal window (Command-N) and see what is printed. You should *just* see \".profile ran\" before the prompt:

``` {.example}
.profile ran
$
```

Your command prompt will be different of course.

Now run an interactive bash:

``` {.example}
$ bash
```

You should now see something like:

``` {.example}
.bashrc ran
bash-3.2$
```

You can see that the `.bashrc` file is not run on starting up a new window. (You might also see your command prompt change! We\'ll fix that in a second.)

What we actually *want* usually, is to have the `.bashrc` file run for a login shell as well.

To do that, we need to fix up the `.profile` file with the following line at the end of the file:

``` {.example}
[ -x $HOME/.bashrc ] && source $HOME/.bashrc
```

This will cause the `.bashrc` file to be executed at the end of the `.profile` file\'s executing but only *if* the `.bashrc` file is **executable**.

This gives a little extra control, if we don\'t want `.bashrc` to run at login, we can unset it\'s execution bit. But for now, let\'s set it:

``` {.example}
$ chmod +x $HOME/.bashrc
$ ls -l .bashrc
```

And you should see something like:

``` {.example}
\-rwxr-xr-x  1 noob  staff  32 Aug  7 01:01 .bashrc
```

Which shows it\'s become executable for everyone on the system.

Close the Terminal window and open a new one. Now you should see the following before the first command line prompt:

``` {.example}
.bashrc ran
.profile ran
```

You can remove those two \"echo\" commands from `.profile` and `.bashrc` if you wish, or leave them in as tracers while you\'re working with them.

### Creating the `.bashrc` file

This file initialized *each* interactive shell, including setting some environment variables used by `bash`, aliases, and other settings.

There is a global `/etc/bashrc` file that is a good starting point for your own.

Run the following command:

``` {.example}
$ cp /etc/bashrc $HOME/.bashrc
```

This will **overwrite** the `.bashrc` file you just made, but that\'s okay since there really wasn\'t anything in it.

Give the new file execute permission:

``` {.example}
$ chmod +x $HOME/.bashrc
```

Close the Terminal window and open a new one.

If you have `.bashrc` but neither `.bash_profile` or `.profile`
---------------------------------------------------------------

In this case, you want to add running the `.bashrc` file for *login* shells so those settings are available.

Add the following line to the end of your `.profile`:

``` {.example}
[ -x $HOME/.bashrc ] && source $HOME/.bashrc
```

as in the previous section. You may need to set the execute bit on `.bashrc` as well:

``` {.example}
$ chmod +x .bashrc
```

If you have `.bashrc`, and one or both of `.bash_profile` and `.profile`
------------------------------------------------------------------------

If you only have one of `.bash_profile` or `.profile` see the appropriate section above.

Make sure one of those two files is calling `.bashrc` as in the previous section. If neither do, put the line into `.profile`.
