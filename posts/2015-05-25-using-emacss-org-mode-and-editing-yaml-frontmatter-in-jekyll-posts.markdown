---
layout: post
title: "Using Emacs's org-mode and editing YAML frontmatter in Jekyll posts"
date: 2015-05-25 10:20
categories: ["emacs", "org-mode"]
tags: ["jekyll", "yaml", "frontmatter", "babel", "learning"]
source: https://gist.github.com/tamouse/eb8432d916459b180007
---

Poking around a bit yesterday and this morning, I have been looking
for an answer to the question: "How can I edit YAML frontmatter in a
Jekyll post written with Emacs's org-mode?"


Whew!! long question. I asked on the `#emacs` channel on
`irc.freenode.net`, but no one had any answers there. I asked on
`stackoverflow` and Google+ Emacs Community.

For the purposes of asking, I wrote up a [gist]({{ page.source }})
showing succinctly the issues I was having and the final answer I got
on G+.


*******

## The Problem:

I've been through the links on orgmode.com about doing this, but
there's still something missing about it for me.

Jekyll posts and pages begin with YAML frontmatter. This is placed in
the .org file with `#+BEGIN_HTML` / `#+END_HTML` guards.  That limits me
to sub-editing that section (with `C-c '`) in `html-mode`. I can't switch
to `yaml-mode` and back to `html-mode` to edit it as YAML, though, as it
somehow loses context and can't switch out of the sub-edit mode.

Is there some way to do what I wish, i.e. edit the frontmatter in YAML
mode?

File `1-with-html.org-raw` shows what one is "supposed" to do, place the
frontmatter ins the html block, and this renders exactly as I'd prefer
it, but doesn't let me edit the content in `yaml-mode`, only
`html-mode`. This renders out correctly with running `jekyll build`.

File `4-with-yaml.org-raw` shows what was suggested, with a src block
for yaml text, and using the `:results html` flag.  This ends up
causing the block's content to be rendered in markdown as a verbatum
block, i.e., pushed to the right 4 spaces.  That causes problems when
run through jekyll, as it renders the frontmatter as content.

What I need is for that source YAML block to be rendered just as is,
i.e. copied directly without changes at all. The initial suggestion to
add `:result html` did not do as I'd hoped, sadly.

### The org-mode post source, using html blocks

Using the standard `#+BEGIN_HTML` / `#+END_HTML`:

{% gist tamouse/eb8432d916459b180007 1-with-html.org-raw %}

Give the desired output:

{% gist tamouse/eb8432d916459b180007 2-with-html.md-raw %}

and:

{% gist tamouse/eb8432d916459b180007 3-with-html.html-raw %}

### The org-mode post source, using src yaml blocks

Using `#+begin_src yaml` :

{% gist tamouse/eb8432d916459b180007 4-with-yaml.org-raw %}

Permitted me to edit the block in YAML mode, but when it was output,
it gave a verbatum markdown block for the YAML, so it looked like
content rather than front matter:


{% highlight text %}
---
    layout: post
    title: test post
    gallery:
      path: abc123
      images:
        - blah.png
        - bloo.png
    ---

# hello world

*this* is the **reason** for the <span class="underline">season</span>.
{% endhighlight %}

*******

## The Solution:

From user
[Left Right](https://plus.google.com/u/0/113921962847063269060) on the
G+ Emacs community, I got the direction and help I need to make this
work. The final answer was to tell babel how to execute YAML source:


{% highlight lisp %}
(defun org-babel-execute:yaml (body params) body)
{% endhighlight %}

Now I have the output I want.

The org-mode source:

{% gist tamouse/eb8432d916459b180007 4-with-yaml.org-raw %}

Generated the markdown:

{% gist tamouse/eb8432d916459b180007 5-with-yaml.md-raw %}

Which in turn produced the html I want:

{% gist tamouse/eb8432d916459b180007 6-with-yaml.html-raw %}

Finally, looking at the difference of the html generated with both
html and yaml blocks, we see the only difference is the title:

{% gist tamouse/eb8432d916459b180007 zz-diff.out %}



*******

## Conclusion:

1. Add the above elisp code to your `.emacs` file or equivalent.

2. Start your Jekyll blog post with:

```
#+STARTUP: showall indent
#+OPTIONS: toc:nil
#+BEGIN_SRC yaml :exports results :results value html
---
layout: post
title: The Title
---
#+END_SRC
```

You can now edit the frontmatter in `yaml-mode` using `C-c '`.

Then, when you run the markdown export, the frontmatter will be
properly placed.

Yay!


## Future

The *next* thing I need to figure out is how to properly use source
blocks to insert code snippets into a post, and have babel emit the
proper Jekyll code blocks with the right language selected.

Entering in the org file:

{% highlight text %}
#+begin_src ruby
  # Ruby code
  puts "hello, world!"
#+end_src
{% endhighlight %}

and have it produce in the markdown:

{% raw %}
<pre><code>{% highlight ruby %}
# Ruby code
puts "hello, world!"
{% endhighlight %}
</code></pre>
{% endraw %}

Resulting in:

{% highlight ruby %}
# Ruby code
puts "hello, world!"
{% endhighlight %}
