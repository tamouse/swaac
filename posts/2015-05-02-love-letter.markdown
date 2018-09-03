---
layout: post
title: "Love Letter?"
date: 2015-05-02 09:12
categories: ["thoughts"]
tags: []
---

<blockquote>
<p>"Remember this: Code is a letter you write your future self.<br>
Do you want it to be a love letter or a poison pen letter?"</p>
<footer>me</footer>
</blockquote>

I posted this recently in the #ruby chatroom on
<http://irc.freenode.net>. It's most definitely **not** an original
thought. Lots of others have expressed similar words and concepts.

I want to underline it here because I think it is rather essential to
the whole concept of Software as a Craft that this blog is about.

SWAAC for me started with this notion of future communication in
a
[chat I had with someone else on IRC]({% post_url 2012-12-05-code-as-literature-software-dev-as-communication %}).
The notion of whom we are writing our code for is something a lot of
programmers don't quite get. We don't write ruby, perl, java, C, etc,
for the computer. We write it to communicate our intent to ourselves
and other people reading our code. The computer doesn't actually care
a lick what our code means; it's not a cognitive processor that can
apply meaning, intent, implication, etc., onto our writing. Only
humans can do that. The compiler/interpretter merely translates into
things the computer can do things with. There is no DWIM (Do What I
Mean) for a computer.

So the question that prompted this remark was this:

> In a `begin - rescue - end` block, if the `rescue` is empty (i.e. does
> nothing), should I use an empty line (as `rescue`'s main body), just a
> ';' or no line at all (no line between `rescue` and `end`) ?

With a response of:

> If I really do nothing I put a comment to make clear it's intentional.

Which makes it clear *to your future self* as well as other people
reading your code. This is the love letter that you will appreciate
getting in the future.
