---
title: "Setting git's default editor"
date: 2020-03-21
category: tools
keywords: git, editor, emacs
---


# Setting git's default editor #

By default, when git needs to fire up an editor to do something such as write a commmit message, it uses whatever is configured as the default editor for the user. (Configuring the user's default editor is an entirely differnt topic.)

There are a couple of ways to change this for `git`:

1. setting one or two environment variables
2. modifying the global git configuration

Of these, I long used the first way, since the environment variables are also recognized by other command line tools (although not all).

Recently I was made aware of method two, modifying the global git configuration.



## Settingh environment variables ##


Git will use two common environment variables, `EDITOR` and `VISUAL`, to determine what editor it should run. Some tools make a distinction between when these are used:

- `EDITOR` is used generally in an environments where there may or may not be a terminal available.
- `VISUAL` is used specifically when there is a terminal available.

Git doesn't really care, you can set one or the other. In the course of my career, I settled on the expediency of setting them both to the same thing and calling it a day.

## Modifying git global config ##

Head over to <https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration> to see the official documentation on modifying the config.

The specific part to set the editor is described here:

> **core.editor**
>
> By default, Git uses whatever you’ve set as your default text editor via one of the shell environment variables VISUAL or EDITOR, or else falls back to the vi editor to create and edit your commit and tag messages. To change that default to something else, you can use the core.editor setting:
>
>     $ git config --global core.editor emacs
>
> Now, no matter what is set as your default shell editor, Git will fire up Emacs to edit messages.

They are already speaking my kind of language. But I want to go just a bit further and use `emacsclient` so as to not call up another instance of the full emacs editor if I can help it. Instead, I set the core.editor value to:

    emacsclient -a emacs

which will run emacsclient to use the currently running instance of emacs, *and*, if there is no currently running instance, start one up.

### A caveat ###

I initially used the command line arguments I normally run emacsclient with: `-c -n`, which say to open a new frame and not to wait for the editing session to finish. Bad move. If the git command is not forced to wait while I modify the commit message, it assumes it wasn't changed and aborts the commit. I also didn't want to have it be spawning new frames since that just gets messy if I forget to close them, which I most often do.

### I hear you, you don't use emacs ###

You aren't a dinosaur like I am, I got you.

You can run VSCode from the command line, or Atom, etc., etc., etc..  I'm not going to teach you how to set that up, *but you should learn how if you don't because it will speed up your work.*

Here are some of the alternative:

- VSCode: `git config -global core.editor "code -w"`
- Atom: `git config --global core.editor "atom -w"`
- Vim: `git config --global core.editor vim`

## Git-mode in Editors ##

Most modern-day editors have a means of running git commands from inside the editor. This is often a far richer environment, closer to a GUI tool, really, than the command line offers. I use `magit` in emacs all the time, but I also use the command line all the time; some operations are better for one than the other. (By the way, `magit` has seriously the very best implementation for doing an interactive rebase, i.e., squashing your commits.)



