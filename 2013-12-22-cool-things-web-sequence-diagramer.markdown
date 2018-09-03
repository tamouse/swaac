---
# BEGIN: redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
redirect_from:
  - /blog/2013/12/22/cool-things-web-sequence-diagramer/
# END:   redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
layout: post
title: "Cool Things: Web Sequence Diagramer"
date: 2013-12-22 18:29
categories: swaac
tags: [programming, tools, cool-things, wikis, gollum, web-sequence-diagrams]
---
I was reading up on [Gollum][gollum], the wiki used by
[Github][github] when I ran across this cool web tool:

[Web Sequence Diagrams][websequencediagrams] 

![Web Sequence Diagrams](/images/websequencediagrams-screenshot.jpg "Web Sequence Diagrams Screenshot") 

A very awesome online tool that lets you create, as if it wasn't
obvious, sequence diagrams online by writing text lines that indicate
the elements of the sequence.

The following textual description:

```
title Authentication Sequence

Alice->Bob: Authentication Request
note right of Bob: Bob thinks about it
Bob->Alice: Authentication Response
```

creates the following diagram:

![](/images/websequencediagrams-screenshot-2.jpg)

As you type into the text area, it automatically changes the
diagram. One of the really cool things is that you can have the
diagram formatted in a number of ways. I personally love the napkin
format shown above.



[gollum]: https://github.com/gollum/gollum/wiki 
[github]: http://github.com 
[websequencediagrams]: http://www.websequencediagrams.com/?lz=dGl0bGUgQXV0aGVudGljYXRpb24gU2VxdWVuY2UKCkFsaWNlLT5Cb2I6ABUQUmVxdWVzdApub3RlIHJpZ2h0IG9mIAAlBUJvYiB0aGlua3MgYWJvdXQgaXQKQm9iLT4ASgUANxNzcG9uc2UK&s=napkin "Web Sequence Diagrammer on the web"

