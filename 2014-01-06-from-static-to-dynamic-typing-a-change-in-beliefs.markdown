---
# BEGIN: redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
redirect_from:
  - /blog/2014/01/06/from-static-to-dynamic-typing-a-change-in-beliefs/
# END:   redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
layout: post
title: "From Static to Dynamic Typing: a Change In Beliefs"
date: 2014-01-06 02:33
categories: [swaac]
tags: [howtos, duck-typing]
---
[Sandy Metz][sandy-metz]'s Book, [Practical Object-Oriented Design in Ruby][poodr], she discusses the paradigm shift needed to believe that dynamically typed languages, such as Ruby, can be better than statically typed languages. 

In chapter 5, "Reducing Costs With Duck Typing", she contrasts the beliefs about static and dynamic typing:

> Static and dynamic typing both make promises and each has costs and benefits.

> Static typing aficionados cite the following qualities:

> -  The compiler unearths type errors at compile time.
> -  Visible type information serves as documentation.
> -  Compiled code is optimized to run quickly.

> These qualities represent strengths in a programming language only if you accept this set of corresponding assumptions:

> -  Runtime type errors will occur unless the compiler performs type checks.
> -  Programmers will not otherwise understand the code; they cannot infer an object’s type from its context.
> -  The application will run too slowly without these optimizations.

> Dynamic typing proponents list these qualities:

> -  Code is interpreted and can be dynamically loaded; there is no compile/make cycle.
> -  Source code does not include explicit type information.
> -  Metaprogramming is easier.

> These qualities are strengths if you accept this set of assumptions:

> -  Overall application development is faster without a compile/make cycle.
> -  Programmers find the code easier to understand when it does not contain type declarations; they can infer an object’s type from its context.
> -  Metaprogramming is a desirable language feature.

[sandy-metz]: http://sandymetz.com 
[poodr]: https://www.goodreads.com/book/show/18090276-practical-object-oriented-design-in-ruby 


(My commentary follows.)

<!--more-->

So the differences between the two views come down to this, for me:
How confident are you in your colleagues' coding skills? Or, from a
management perspective, how confident are you in your developers'
coding skills?  These may, of course, provide two different
answers. And you really can't address the question in terms of your
own confidence, because that is typically an area we are blind in
(either too high or too low).

But there is another way to look at it: how confident can you *become*
in your colleagues' or contributors' skills? If they (and so, you)
continuously take the purportedly safer route of static typing, it
fosters an air of non-risk-taking. Subsequently, you stifle
creativity, innovation, and the very souls of your software
craftspeople, and thus yourself.

The idea of releasing code that finds type errors in runtime sends
chills though many people's developer bones. And so, in the
dynamically typed development world of Ruby, the field is full of
really great test practices. Not uniformly, of course, there are lots
of people and organizations developing Ruby code in an unsafe manner
by eschewing all testing, either completely, or an effort made at the
end, where it really isn't as effective.

Also, it *does* require more skill and understanding of how to put in
place runtime error recovery mechanisms, because, yes, it is pretty
awful to throw a 500 Internal Server Error at a user in production,
but it's a fool who thinks that will never be needed if developing in
an completely statically typed paradigm.

In addition to Sandy's *really* excellent book, [Avdi Grimm][avdi] is
another strong proponent of writing [Confident Ruby][conf-ruby]. 

[avdi]: http://about.avdi.org/ 

[conf-ruby]: https://www.goodreads.com/book/show/19400982-confident-ruby 

> ... switching on type clutters up method
  logic, makes testing harder, and embeds knowledge about types in
  numerous places. As confident coders, we want to tell our ducks to
  quack and then move on. This means first figuring out what kind of
  messages and roles we need, and then insuring we only allow ducks
  which are fully prepared to quack into our main method logic.

So defensive coding is out in the dynamically-typed coding
world. Instead, we rely on our ability to deal with runtime errors
intelligently and gracefully, to speed up our code, our development,
and our understanding of the application we're developing, as a
narrative to helping our future selves and others maintain and extend
the code.

This is the way of the software craftsperson.
