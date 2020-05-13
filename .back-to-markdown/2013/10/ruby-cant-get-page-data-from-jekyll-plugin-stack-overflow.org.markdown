ruby - Can\'t get page data from Jekyll plugin - Stack Overflow
===============================================================

**WARNING: This is old and likely obsolete.**

-   published date: 2013-10-15 10:54
-   keywords: \[\"answers\", \"issues\", \"jekyll\", \"stackoverflow\", \"swaac\"\]
-   source: <http://stackoverflow.com/questions/10264249/cant-get-page-data-from-jekyll-plugin>
-   comments: true

\#+BEGIN~QUOTE~

-   Can\'t get page data from Jekyll plugin

I\'m trying to write a custom tag plugin for Jekyll that will output a hierarchical navigation tree of all the pages (not posts) on the site. I\'m basically wanting a bunch nested `<ul>`\'s with links (with the page title as the link text) to the pages with the current page noted by a certain CSS class.

I\'m very inexperienced with ruby. I\'m a PHP guy.

I figured I\'d start just by trying to iterate through all the pages and output a one-dimensional list just to make sure I could at least do that. Here\'s what I have so far:

``` {.example}
module Jekyll

  class NavTree < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      output = '<ul>'
      site.pages.each do |page|
        output += '<li><a href="'+page.url+'">'+page.title+'</a></li>'
      end
      output += '<ul>'

      output
    end
  end

end

Liquid::Template.register_tag('nav_tree', Jekyll::NavTree)
```

And I\'m inserting it into my liquid template via `{\% nav_tree %\}`.

The problem is that the `page` variable in the code above doesn\'t have all the data that you\'d expect. `page.title` is undefined and `page.url` is just the basename with a forward slash in front of it (e.g. for `/a/b/c.html`, it\'s just giving me `/c.html`).

What am I doing wrong?

**Side note:** I already tried doing this with pure Liquid markup, and I eventually gave up. I can easily iterate through `site.pages` just fine with Liquid, but I couldn\'t figure out a way to appropriately nest the lists.

asked Apr 22 \'12 at 0:34

\[\[/users/451201/jnrbsn\]\[\]\]

<https://www.gravatar.com/avatar/08557ea48b0f92938bb0c01356ad606e?s=32&d=identicon&r=PG>

[jnrbsn](file:///users/451201/jnrbsn)\
669411

------------------------------------------------------------------------

------------------------------------------------------------------------

I created [an issue on GitHub](https://github.com/mojombo/jekyll/issues/548) to see if anybody there knows the answer. -- [jnrbsn](file:///users/451201/jnrbsn) Apr 30 \'12 at 16:21

------------------------------------------------------------------------

------------------------------------------------------------------------

Did you ever manage to get the nesting working? I\'d love to see the final code if so -- [Brand](file:///users/401096/brand) Aug 21 \'12 at 19:35

------------------------------------------------------------------------

------------------------------------------------------------------------

@Brand Unfortunately, I never got around to finishing it. -- [jnrbsn](file:///users/451201/jnrbsn) Aug 23 \'12 at 23:19

------------------------------------------------------------------------

------------------------------------------------------------------------

I managed to hack the hierachical page tree together. It\'s not pretty but I\'ve posted it here: [gist.github.com/3536551](https://gist.github.com/3536551) in case anyone else stumbles on this question -- [Brand](file:///users/401096/brand) Aug 30 \'12 at 18:24

\*\* 2 Answers

[active](file:///questions/10264249/cant-get-page-data-from-jekyll-plugin?answertab=active#tab-top) [oldest](file:///questions/10264249/cant-get-page-data-from-jekyll-plugin?answertab=oldest#tab-top) [votes](file:///questions/10264249/cant-get-page-data-from-jekyll-plugin?answertab=votes#tab-top)

up vote 3 down vote accepted

Try:

``` {.example}
module Jekyll

  # Add accessor for directory
  class Page
          attr_reader :dir
  end


  class NavTree < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      output = '<ul>'
      site.pages.each do |page|
        output += '<li><a href="'+page.dir+page.url+'">'+(page.data['title'] || page.url) +'</a></li>'
      end
        output += '<ul>'

      output
    end
  end

end

Liquid::Template.register_tag('nav_tree', Jekyll::NavTree)
```

[share](file:///a/10813490)\|[improve this answer](file:///posts/10813490/edit)

[edited Jun 4 \'12 at 9:39](file:///posts/10813490/revisions)

answered May 30 \'12 at 9:26

\[\[/users/1425619/mikael-borg\]\[\]\]

<https://www.gravatar.com/avatar/1e1bf93381c676a431bc932e041b7e02?s=32&d=identicon&r=PG>

[Mikael Borg](file:///users/1425619/mikael-borg)\
464

------------------------------------------------------------------------

------------------------------------------------------------------------

With this code, I get `Liquid error: can't convert nil into String`. -- [jnrbsn](file:///users/451201/jnrbsn) May 30 \'12 at 18:11

------------------------------------------------------------------------

------------------------------------------------------------------------

You probably had a page without a title, so that page.data\[\'title\'\] is nil. Replace w/ e.g. (page.data\[\'title\'\] \|\| page.url) . -- [Mikael Borg](file:///users/1425619/mikael-borg) Jun 4 \'12 at 9:37

  --- --
  1   
  --- --

Sorry for the delayed response. You were correct. I had a page without a title. Your solution works. -- [jnrbsn](file:///users/451201/jnrbsn) Jun 15 \'12 at 4:32

up vote 3 down vote

`page.title` is not always defined (example: `atom.xml`). You have to check if it is defined. Then you can take `page.name` or not process the entry...

``` {.example}
def render(context)
  site = context.registers[:site]
  output = '<ul>'
  site.pages.each do |page|
    unless page.data['title'].nil?
      t = page.data['title']
    else
      t = page.name
    end
    output += "<li><a href="'+page.dir+page.url+'">'+t+'</a></li>"
  end
  output += '<ul>'
  output
end
```

[share](file:///a/10877244)\|[improve this answer](file:///posts/10877244/edit)

answered Jun 4 \'12 at 6:39

\[\[/users/690003/undx\]\[\]\]

<https://www.gravatar.com/avatar/a171009618468e8caa6d327c52e1a000?s=32&d=identicon&r=PG>

[undx](file:///users/690003/undx)\
1363

------------------------------------------------------------------------

------------------------------------------------------------------------

Shorten that unless..end a bit to: `t = page.data['title'] || page.name` -- [tamouse](file:///users/742446/tamouse) 20 mins ago

\#+END~QUOTE~
