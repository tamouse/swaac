---
layout: post
title: 'TIL: target="_blank" with no rel="noopener"'
date: 2016-11-26 14:05
categories: ["html"]
tags: ["security"]
source: URL
---

In yesterdays CSS-Tricks
column
[Random Interesting Facts on HTMLSVG usage  CSS-Tricks](https://css-tricks.com/random-interesting-facts-htmlsvg-usage/),
Catalin Rosu explains something I'd never heard before, and it can be
pretty important:

> target=_blank w/ or w/o rel=noopener

> 43,924,869 of the anchors we analyzed are using target="_blank" without a rel="noopener" conjunction. In this case, if rel="noopener" is missing, you are leaving your users open to a phishing attack and it's considered a security vulnerability.

> | Anchor/Link | Count|
> |+-----------+|-----+|
> | [target=_blank] | 43,924,869|
> | [rel=noopener] | 40,756|
> | [target=_blank][rel=noopener] | 35,604|

> MDN:

> > When using target you should consider adding rel="noopener noreferrer" to avoid exploitation of the window.opener API.

> [Ben Halpern](https://dev.to/ben/the-targetblank-vulnerability-by-example) and
> [Mathias Bynens](https://mathiasbynens.github.io/rel-noopener/) also
> wrote some good articles on this matter and the common advice is:
> don’t use target=_blank, unless you have good reasons.

I may need to rethink how I often I use `target="_blank"`. Lately I've
been creating slide presentations using `reveal.js` and I include
links in the slide show; I think it's easier for students if I open up
a new tab rather than interrupting the flow of the slide show.

I think for those, I'll go ahead an add the recommended `rel="noopener
noreferrer"`. But elsewhere, I'll consider curtailing my use of
`target="_blank"`
