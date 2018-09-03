---
layout: post
title: "Specifying target=_blank on an anchor in a markdown document"
date: 2017-04-10 00:46
categories: ["jekyll"]
tags: ["markdown", "kramdown", "syntax", "target", "blank", "jekyll"]
source: "https://kramdown.gettalong.org/syntax.html#span-ials"
---

Just a quick note so I don't lose this:

In Jekyll's default markdown processor, `kramdown`, you can specify an
attribute on a spanning or block element inside braces ("squirly
brackets") like so:


{% highlight markdown %}
{% raw %}{:attr="value"}{% endraw %}
{% endhighlight %}

Thus, to get a link to open in a new tab:

{% highlight markdown %}
{% raw %}[link text](linkpath){:target="_blank" rel="noopenner noreferrer"}{% endraw %}
{% endhighlight %}

Should generate:

{% highlight html %}
<a href="linkpath" target="_blank">link text</a>
{% endhighlight %}

Let's just see what happens:

> [This link]({{page.url}}){:target="_blank" rel="noopenner noreferrer"} should open in a new page.
