---
layout: link
title: "Link: A new release of Jekyllpress"
date: 2015-03-08 21:14
categories: ["jekyll"]
tags: ["jekyllpress", "jekyll"]
link:
  href: "https://github.com/tamouse/jekyllpress/releases/tag/v1.0.0"
  title: "A new release of Jekyllpress"
  date: "2015/03/08" 
  author:
    name: "Tamara Temple"
    url: "https://github.com/tamouse"
---
I've put out a new release of `Jekyllpress`, my Thor script to help
create new jekyll posts and pages.

## To Install

Command line install:

    $ gem install jekyllpress

## New features

* *--url* switch, lets you specify a url to be placed into the
  template. ERB variable `@url`.

* *--layout* switch, lets you specify a different layout.

* *--template* switch, lets you specify a different document template.

* `@filename` variable that can be used in the ERB part of a template.

## Example used to generate this post:

### Command line

{% highlight bash %}
    $ jekyllpress new_post 'A new release of Jekyllpress' -c jekyll \
    -t jekyllpress jekyll --layout=link --template=new_link.markdown \
    --url=https://github.com/tamouse/jekyllpress/releases/tag/v1.0.0
{% endhighlight %}

### new_link.markdown template

It's just frontmatter.

{% highlight yaml %}
---
layout: link
title: "Link: <%= @title %>"
date: <%= Time.now.strftime("%Y-%m-%d %H:%M") %>
categories: <%= Array(@categories) %>
tags: <%= Array(@tags) %>
link:
  href: "<%= @url %>"
  title: ""
  date: "" 
  author:
    name: ""
    url: ""
attachments:
  - name: ""
    link: ""
    description: ""
---

{% endhighlight %}

### link layout



{% highlight html %}{% raw %}
---
layout: default
---
<main role="main">
  <header class="page-header">
    <h1><a href="{{page.link.href}}">{{ page.link.title }}</a></h1>
    <ul>
      <li>Author: <a href="{{page.link.author.url}}">{{page.link.author.name}}</a></li>
      <li>Article date: {{page.link.date}}</li>
      {% if page.categories %}<li> <ul class="link-list"><li>Categories:</li>{% for cat in page.categories %}<li role="presentation"><a href="{{site.baseurl}}/categories/{{cat}}">{{cat}}</a></li>{% endfor %}</ul></li>{% endif %}
      {% if page.tags %}<li><ul class="link-list"><li>Tags: </li>{% for tag in page.tags %}<li role="presentation"><a href="{{site.baseurl}}/tags/{{tag}}">{{tag}}</a></li> {% endfor %}</ul></li>{% endif %}
    </ul>
  </header>
  <article>
    {{ content }}
  </article>
  <footer>
    <hr>
    {% if page.source %}<p><a href="{{ page.source }}">Source</a></p>{% endif %}
  </footer>
  <aside>
    {% include discuss.html %}
  </aside>
</main>

{% endraw %}{% endhighlight %}

