---
layout: post
title: "TIL: Providing Defaults For EnvVars in Python 3"
date: 2017-01-24 16:14
categories: ["python"]
tags: ["envvars", "defaults", "til", "python", "python3"]

---

**Today I Learned:** that you can set a default for a missing
Environment Variable **and** that an empty string is not the best
default.

I'd been blissfully performing the following sort of passage when
dealing with envvars:


{% highlight python %}
if os.environ.get('FOO'):
    foo_setting = os.envrion['FOO']
else:
    foo_setting = ''
{% endhighlight %}

This is pretty wrong-headed in a few ways, including the fact that
some things expect a setting to be `None` instead to ensure they work
correctly. In particular, we were using this sort of thing to set the
profile name for `boto3`. If the profile name is `None`, it doesn't
try to connect, but if it's the empty string `''` it uses that for the
profile name, which of course will never work.

So the proper construction is:

{% highlight python %}
foo_setting = os.environ.get('FOO', None)
{% endhighlight %}

saving us from an extraneous retrieval and test for a value.

See more information
here:
[dict.get()](https://docs.python.org/3/library/stdtypes.html#dict.get)
in the Standard Type documentation.

I should note that I only got there from finding
this:
[Issue 28242 os.environ.get documentation missing - Python tracker](https://bugs.python.org/issue28242)
via googling for "python3 os.environ get", so it's not exactly obvious
to the newcomer, like me. And this *after* the lead on the team fixed
my oh so broken code. Yay for code reviews!
