# Delete a remote git branch

- published date: 2013-10-05 08:03
- keywords: ["branch", "git", "remote", "remove"]
- source: http://stackoverflow.com/questions/315911/git-for-beginners-the-definitive-practical-guide/5977604#5977604


Perform a push to your remote using : before the name of the branch

    $ git push origin :mybranchname

where `origin` is the name of your remote and `mybranchname` is the
name of the branch about to be deleted.

