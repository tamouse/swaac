---
# BEGIN: redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
redirect_from:
  - /blog/2013/09/14/the-laws-of-software-design/
# END:   redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
layout: post
title: "The Laws of Software Design"
date: 2013-09-14 01:37
categories: [swaac]
tags: [books, design, max-kanat-alexander, code-simplicity]
---
In his book
[_Code&nbsp;Simplicity_](http://www.goodreads.com/book/show/13234063-code-simplicity),
[Max&nbsp;Kanat-Alexander](http://www.goodreads.com/mkanat) lists six laws
of software design in an appendix. These are a pretty good set of
rules!

<!--more-->

*******

It is interesting to me to note how these 6 laws relate to other
platitudes of software design and development, such as "Do the
simplest thing that works", "You ain't gonna need it", The Law of
Demeter (aka Principle of Least Knowledge) and several others. They
are saying the same sorts of things, but perhaps slightly different
perspectives.

There is nothing new here, really, but the collected wisdom from
people who have slogged through software development projects and
survived.

*******

## The Six Laws of Software Design

1. The purpose of software is _to help people_.

2. The Equation of Software Design:

        D = (Vn + Vf) / (Ei + Em)

    where:

    * *D*:  Stands for the desirability of the change.
    * *Vn*: Stands for value now.
    * *Vf*: Stands for future value.
    * *Ei*: Stands for the effort of implementation.
    * *Em*: Stands for the effort of maintenance.

    This is the primary law of software design. As time goes on, this
    equation reduces to: 

        D = Vf / Em 

    Which demonstrates that it is more important to reduce the effort
    of maintenance than it is to reduce the effort of implementation. 

3. **The Law of Change**: The longer your program exists, the more
probable it is that any piece of it will have to change. 

4. **The Law of Defect Probability**: The chance of introducing a
defect into your program is proportional to the size of the changes
you make to it. 

5. **The Law of Simplicity**: The ease of maintenance of any piece of
software is proportional to the simplicity of its individual pieces. 

6. **The Law of Testing**: The degree to which you know how your
software behaves is the degree to which you have accurately tested
it. 
