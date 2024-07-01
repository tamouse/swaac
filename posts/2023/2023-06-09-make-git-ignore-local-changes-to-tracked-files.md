# Make Git Ignore Local Changes to Tracked files

Source: https://practicalgit.com/blog/make-git-ignore-local-changes-to-tracked-files.html

Sometimes you want to change a tracked file so that you can run your project locally on your machine. This is typical of configuration files and templates. But you don’t want to commit these files. One way is to discard these changes every time you are about to commit and redo them every time you pull from master. Another way is to stash them before you commit and reapply them after you pull.

But there is a better way! You can tell Git to ignore changes to this file:

```sh
git update-index --assume-unchanged <file-to-ignore>
```

Now you can go ahead and do whatever you want in that file and it will not show up as a changed file in git.

This will work unless that file is changed on the remote branch. In that case if you do a pull, you will get an error.

When that happens you need to tell Git to start caring about the file again, stash it, pull, apply your stashed changes, and tell Git to start ignoring the file again:

``` sh
# tell Git to stop ignoring this file
$ git update-index --no-assume-unchanged <file-to-ignore>

# stash your local changes to the file
$ git stash <file-to-ignore>

# Pull from remote
$ git pull

# Apply your stashed changes and resolve the possible conflict
$ git stash apply

# Now tell Git to ignore this file again
$ git update-index --assume-unchanged <file-to-ignore>
```

