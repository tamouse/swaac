The file system holding iCloud files is sort of tucked out of the way. It would be nice if it were mounted under `/Volumes/` like others, but no.

According to this answer at <https://discussions.apple.com/thread/7388762>, you can find it under `$HOME/Library/Mobile\ Documents/com~apple~CloudDocs`.
In case that's not very readable, those are *tildes* at the end (shift-backtick, close to the number 1 key). I'll embiggen it:

# `$HOME/Library/Mobile\ Documents/com~apple~CloudDocs`

What I did, now that I know that's where they live, is create a soft link to that directory in my `$HOME` directory:

     $ link -s $HOME/Library/Mobile\ Documents/com~apple~CloudDocs iCloud

and that let me have easy access without having to remember that long path.

