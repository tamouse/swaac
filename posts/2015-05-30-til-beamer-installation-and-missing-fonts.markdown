---
layout: post
title: "TIL: Beamer installation and missing TeX fonts"
date: 2015-05-30 06:01
categories: ["org-mode"]
tags:
  - org-mode
  - beamer
  - tex
  - fonts
  - presentations
---
I have recently been playing much with emac's `org-mode` and one of
the neat things is creating a presentation and exporting it to
[beamer], a TeX dialect made for creating presentations.

I seemed to have all the pieces installed, so I thought, so I got to
the step for testing the installation:

> To test your installation, copy the file
> `generic-ornate-15min-45min.en.tex` from the directory
> `beamer/solutions/generic-talks`
> to some place where you usually create presentations. Then run the
> command `pdflatex` several times on the file and check whether the
> resulting pdf file looks correct. If so, you are all set.

Well, I wasn't all set, as it turns out I was missing a few
fonts. After banging around trying to fix this, I used my awesome
superpowers and searched for the error that was getting shown, and it
led me to stackexchange's TeX forum:

<http://tex.stackexchange.com/questions/160176/usepackagescaledhelvet-fails-on-mac-with-basictex>

Here, I learned about installing fonts. I ran the following as root:

    $ sudo tlmgr install collection-fontsrecommended

and then tried the test again:

    $ pdflatex generic-ornate-15min-45min.en

which produces a ton of output as TeX does and the result was a
success!
