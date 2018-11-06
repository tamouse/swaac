# Specifying target=_blank on an anchor in a markdown document

- published date: 2017-04-10 00:46
- keywords: ["blank", "jekyll", "kramdown", "markdown", "syntax", "target"]
- source: https://kramdown.gettalong.org/syntax.html#span-ials



Just a quick note so I don't lose this:

In Jekyll's default markdown processor, `kramdown`, you can specify an
attribute on a spanning or block element inside braces ("squirly
brackets") like so:


```markdown
{% raw %}{:attr="value"}{% endraw %}
```

Thus, to get a link to open in a new tab:

```markdown
{% raw %}[link text](linkpath){:target="_blank" rel="noopenner noreferrer"}{% endraw %}
```

Should generate:

```html
<a href="linkpath" target="_blank">link text</a>
```

Let's just see what happens:

> [This link]({{page.url}}){:target="_blank" rel="noopenner noreferrer"} should open in a new page.
