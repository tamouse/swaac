---
layout: post
title: "WordCamp Minneapolis 2016: Diving Back Into WordPress"
date: 2016-05-23 04:10
categories: ["wordpress"]
tags: ["relearning", "themes", "custom-themes", "wordcamp"]

---

![](https://2016.minneapolis.wordcamp.org/files/2016/02/wordpress-logo-2016.png) ![](https://2016.minneapolis.wordcamp.org/files/2016/02/wcmpls-logo-2016.png)
{: .text-center}


This past weekend, May 20-22, I attended
[WordCamp Minneapolis 2016](https://2016.minneapolis.wordcamp.org/)
(twitter hash tag [#wcmpls](http://twitter.com/search?q=%23wcmple))
which was a **huge** lot of fun. I haven't looked at WordPress and PHP
in years, at least since around 2007. A lot has changed, and a lot
hasn't changed. I also found a really welcoming community among the
\#wcmpls crowd.

Since I stopped using it, WordPress has only continued to grow and
improve, thanks to the dedicated efforts of the WordPress open source
community and project leaders.

It was also great to step away from the Ruby on Rails server-side
environment I've been running in for the past many years and engage in
a bit of nostalgia in PHP (and perhaps some [nastalgia](#nastalgia) as well).

One of the things that made this event so much fun for me was all the
people I already knew through [GDI].

[GDI]: http://gdiminneapolis.com "Girl Develop It Minneapolis Chapter"


<figure>
<div class="text-center">
<img src="{{"images/wcmpls-gdi-attendees.jpg" | prepend:
site.s3path}}" class="" alt="GDI WordCamp attendees. We happy few." />
</div>
<figcaption class="text-center">
<p>Our merry band, we happy few.</p>
<p><small><a href="https://twitter.com/GDImpls">GDI Mpls</a></small></p>
</figcaption>
</figure>





<hr class="divider divider-primary">

## Friday Foundation

For the first time, #wcmpls had a Friday-before-the-conference
technical day, and I chose to dive deep into the development track and
learn about creating a custom theme from scratch.

This was wonderful because it met my dual needs of expressing my
creativity in software building and relearning and extending my
knowledge into the platform.

I ended up a little frustrated with the day, because what I was
building didn't work as I expected. Not so unusual during these
massive teaching days; I certainly wouldn't expect them to hold up
everything until I understood what I was doing wrong.

<hr class="divider divider-primary">

## Saturday

Sessions, sessions, sessions! I tended to pick the more tech/dev side
of things and was rewarded with some great topics. There were several
that were quite a bit more "junior" in my experience, such as the
JavaScript with WordPress sessions, where it seems that JavaScript is
enjoying a lot of attention, but has not yet penetrated into the
mainstream of things.

Likewise, there's still a bit of a feeling I got that as far as
development practices go, things are still sometimes pretty loose as
far as source control, continuous testing/integration, and what-not.

From my "can't leave it unfinished" feeling from Friday, I spent a
fair bit of time hitting up other people and working on getting a
working custom theme with custom post types and custom taxonomy in
place, even using bootstrap to drive the theme, which I find pretty
awesome.

There was this thing called the "Happy Bar" (I think) -- which I
didn't find out what it was until late Sunday afternoon, at which
point I went over and *promptly* got great answers for some lingering
questions.

My prior experience extended to child themes and small changes here
and there in CSS and layout, but having a packaged custom theme
example is really great.

> The example custom theme code can be seen out on
> [github](https://github.com/tamouse/example-wordpress-theme-creation-wcmpls16)
> and there's a [demo](http://wp.pontiki.io/demo-custom-theme/)
> available, too.
{: .text-right}

As often happens, while you're trying to solve one problem, you come
with another, and in the midst of that, an idea is spawned to automate
something, and then another yak is ready for shaving. Randall Monroe
captures this, of course:

![Automating](http://imgs.xkcd.com/comics/automation.png "'Automating' comes from the roots 'auto-' meaning 'self-', and 'mating', meaning 'screwing'.")
{: .text-center}

So, yeah, part of the day I worked on building a [Thor] tool to
automatically build a [Vagrant] box provisioned with [Ansible] that
would be usable as a [WordPress] custom theme and plugin development
environment. Yeah, it's still in progress ...

[Thor]: http://whatisthor.com "What is Thor?"
[Vagrant]: http://vagrantup.com "Vagrant by HashiCorp"
[Ansible]: http://ansible.com "Automation for Everyone"
[WordPress]: https://wordpress.org "code is poetry"

But at least I did get a custom theme, custom post type, and custom
taxonomy built! Yay!


<hr class="divider divider-primary">

### Saturday Talks

There were lots of great talks and speakers. I only attended two talks
on Saturday, and they were awesome.

#### Amy Gebhardt's _From Junior to Senior: Why We Teach_

[Amy] is a friend whom I have the pleasure of volunteering with at
[Girl Develop It][GDI]. Her talk explored a bit of what goes on at
GDI, whose mission is the teach beginning HTML, CSS, and JavaScript to
Women. The hope is to bring diversity into the web development world.

[Amy]: http://twitter.com/amlyhamm "Amy Gebardt on Twitter"

With that, and with all the bootcamps, however, there is a
backpressure created as many firms and agencies don't wish to hire
inexperienced or junior developers.

Amy's talk struck right to the heart of this, outlining why it's a
good idea, and once you decide to try it, how to engage them, and then
how to bring them up to speed once they join your organization.

In her usual brilliant and high-energy way, Amy provided a lot of human
and humane reasons for all of this, and presented her own difficulties
in dealing with the third step of this, handling your own work and
reactions when working with someone who needs a lot of hand-holding.

* <small>[Slides from Amy's Talk](http://amlyhamm.com/talks/wcmpls/from-junior-to-senior/)</small>

<figure>
<div class="text-center">
<img src="{{ "images/wcmpls-amyg-hiring-junior-devs.jpg" | prepend:
site.s3path }}" class="" alt="Amy Gebardt brings the excitement!" />
</div>
<figcaption class="text-center">
<p><a href="https://twitter.com/amlyhamm">Amy Gebhardt</a> brings the
excitement!</p>
<p><small>Credit: <a href="https://twitter.com/amlyhamm">@amlyhamm</a></small></p>
</figcaption>
</figure>

<hr class="divider divider-primary">

#### Eryn O'Neil's _Programmers Can UX Too: Avoiding the Programmer's User Interface_

Eryn's talk was very enjoyable, she has rather good comedic timing,
and knows her audience. (In fact, she spent quite a bit of time up
front making sure she *had* the right audience, inviting people to
leave if they though they wouldn't get much out of her talk.)

Eryn's message is right there in the title: as a developer, you, too,
*must* understand enough about what your user is trying to accomplish,
and that you really need to make your software enjoyable enough for
the user to operate that they'll continue to do so.

My comment to Eryn afterwards was that I was struck (again) by the
importance of paying attention to the user, whom all the value of your
code resides in. There are intrinsic values, certainly, and your own
aesthetic values, but the actual value rests on whether or not the
user will use your code. We build these things not to sit in a
repository, but to be out in the world, solving problems for people.

* <small>[Eryn's slides](http://www.slideshare.net/eryno/programmers-can-ux-too-minnewebcon-2014)</small>

<figure>
<div class="text-center">
<img src="{{ "images/wcmplw-eryn-oneil-the-programmers-ux.jpg" | prepend: site.s3path}}" class="" alt="Eryn
O'Neil (@eryno) showing us the Programmer's UX (unph)" />
</div>
<figcaption class="text-center">
<a href="https://twitter.com/eryno">Eryn O'Niel</a>
showing us the Programmer's UX (unph)
<p><small>Credit: <a href="https://twitter.com/ChrisEdwardsCE">@ChrisEdwardsCE</a></small></p>
</figcaption>
</figure>

<hr class="divider divider-primary">

## Sunday

The morning was taken up with a brunch at the [Fountain Room] in
downtown Minneapolis, which if you've never been is pretty doggone
spectacular. One of the top spots for wedding receptions, apparently.

<figure>
<div class="text-right">
<img src="{{ "images/fountain-room-pano-20160522-rot.jpg" | prepend: site.s3path}}" class="" alt="" />
</div>

<figcaption class="text-right">
<div class="text-right">
<a href="{{ "images/fountain-room-pano-20160522.jpg" | prepend:
site.s3path }}" target="_blank" title="Fountain Room, Minneapolis,
Panoramic Photo">Here's a panorama of the room</a>. (Off page, because
it's big.)
</div>
<p><small>Credit: me!</small></p>
</figcaption>
</figure>



### Lightning Talks

The lightning talks were rather good, but I think the first two were
speaking to bloggers as a business more than mere devs.

<hr class="divider divider-primary">

#### Shawn Pfunder's _Bicycle Freelancing_.

  Shawn uses a bicycle shop as analogy and metaphor for creating your
  own business.

  5 main points:

  * build a tribe
  * secure space
  * get together
  * teach others
  * get personal

<figure>
<div class="text-center">
<img src="{{ "images/wcmpls-pfunder-bicycle-freelancing.jpg" |
prepend: site.s3path}}" class="" alt="Shawn Pfunder on how your
business should be like a bike shop #wcmpls" />
</div>
<figcaption class="text-center">
<a href="https://twitter.com/pfunder">Shawn Pfunder</a>
on how your business
should be like a bike shop.
<p><small>Credit: <a href="https://twitter.com/_horneck">@_horneck</a></small></p>
</figcaption>
</figure>

<hr class="divider divider-primary">


#### Aaron Rosell's _Why Email Newsletters Help Bloggers Build Influence_

  Aaron presented a case study of one of his clients, who runs a
  fashion blog. She began also putting out a few different
  newsletters:

  * blog teaser
  * news / article / interest aggregator, not limited to fashion
  * weekend edition, more articles, lots of personal stuff, things not
    found on the blog itself.

  Aaron's points are that if you're a serious blogger, consider adding
  an e-mail (or e-mails) to your blog, and capture more attention,
  more readers, make yourself more personable, more accessible, and in
  addition, gather a lot more data about your readers so you
  understand them better.

<hr class="divider divider-primary">

#### Cate DeRosia's _Why You Should Embrace Failure_

  Cate's talk restated something most people have heard before, but
  that bears repeating often, as it's something that hasn't been fully
  grokked and integrated into our culture very well:

> "We learn from failure"
> {: .text-center}

  It's really important to remember that when you've just deleted the
  corporate database, or cost the company $100,000 in accidental
  overcharges (okay, it only looked like it was $7000, and it was only
  a data error, but still...). The key thing is to learn from those
  mistakes. Fix the causes of the errors so they won't happen
  again. Fix the causes of the causes of the errors, find the root
  cause and fix that. Keep improving.

  Ultimately, failing can be a very positive experience once we get
  over the fear and frustration. That won't go away, we are human
  after all, but we don't have to let those feelings rule us.

<figure>
<div class="text-center">
<img src="{{"images/wcmpls-cate-derosio-learn-from-failure.jpg" | prepend: site.s3path}}" class="" alt="Cate
DeRosia learning from failure" />
</div>
<figcaption class="text-center">
<p><a href="https://twitter.com/mysweetcate">Cate DeRosia</a> helping us
to embrace our failures in order to learn and grow.</p>
<p><small>Credit: <a href="https://twitter.com/topher1kenobe">@topher1kenobe</a></small></p>

</figcaption>
</figure>

<hr class="divider divider-primary">

### Sunday Sessions

There were fewer talks on Saturday, only in the afternoon. I went all
in on the JavaScript talks:

#### Solomon Scott's _JavaScript <3 WordPress_

Solomon is a true lover of JavaScript (as am I) and his passion shows
through quite well.

This was an important talk for me, not from the overview of JavaScript
Solomon presented, but from the eagerness of the audience, and my own
interest, in bringing the two worlds together. On Friday, I had just
learned how to intergrate the styles and scripts I could make for a
custom theme or plugin, and Solomon provided for me the binding of
modern JavaScript development with WordPress integration. It was
really nice.

He does speak way too fast, though. :D

* <small>[JavaScript <3 WordPress slides](http://solomonscott.com/index.php/javascript-and-wordpress/)</small>

<figure>
<div class="text-center">
<img src="{{ "images/wcmpls-solomonscott-wp-heart-js.jpg" | prepend: site.s3path}}" class="" alt="Solomon
Scott showing some love. #wcmpls" />
</div>
<figcaption class="text-center">
<p><a href="https://twitter.com/SolomonSScott">Solomon Scott</a> showing
some love.</p>
<p><small>Credit: <a href="https://twitter.com/Julie381Julie">@Julie381Julie</a></small></p>
</figcaption>
</figure>

<hr class="divider divider-primary">

#### Josh Broton's _WordPress+React: A Match Made In Heaven_

Wow. Josh is like the most dynamic speaker ever. He's bouncing around
the podium, his slides are just *lousy* with animated GIFs and he's
astoundingly funny and engaging. That's just the outside.

Inside, Josh's talk was super engaging, and super informative. For
most of the people attending, I think React is a completely new
concept, but I was quite eager to see how it could be used.

The upshot, and this is the same conclusion I've reached on the Rails
side, is that WordPress can and should be used only as an API source
(your web service) and completely eschew any of it's own views. It
only delivers up JSON to a Single Page App (SPA) which is written in a
way that is really outside the entire WordPress Loop.

When the user comes in to your site, the main WordPress page would
just deliver the SPA to the browser, and subsequent interaction with
WordPress would be entirely AJAX-driven.

It's quite compelling, I think, and it will be interesting to see how
much traction this concept gets in the WP community. I like it a lot.

* <small>No slides yet for Josh's talk. Coming soon, I hope.</small>

<figure class="text-center">
<div class="text-center">
<img src="{{
"images/wcmpls-josh-broton-its-just-js-but-its-not-but-it-is.jpg" |
prepend: site.s3path }}" alt="Josh Broton: React:
it's just javascript, but it's not, but it is" />
</div>
<figcaption class="text-center">
<p><a href="https://twitter.com/joshbroton">Josh Broton</a>: "React: It's just
Javascript, but it's not, but it is."</p>
<p><small>Credit: <a href="https://twitter.com/foundartphotog">@foundartphotog</a></small></p>
</figcaption>
</figure>

<hr class="divider divider-primary">

## Conclusion

I was pretty tired, but also pretty jazzed. I had such a great time,
and I'm so happy to those who made this possible.

A special shout-out to
[Michelle Schulp](https://twitter.com/marktimemedia) who organized
this super event, and lovingly opened up a space for me at the last
minute.
Most excellent work!



<hr class="divider divider-primary">

<a name="#nastalgia"></a>
<div class="row">
<div class="col-md-8 col-md-offset-2">
<p class="text-muted">
<em>"Nastalgia"</em> is just a word I made-up by accident when referring to
that feeling where you look at something in the past and it makes you
a bit sick.
</p>
</div>
</div>

<hr class="divider divider-primary">

<div class="row">
<div class="col-md-8 col-md-offset-2">
<p class="text-muted">
<small>
Images were taken from the <a
href="https://twitter.com/search?q=%23wcmpls&src=typd">
#wcmpls twitter search feed</a>.
Copied without persmission, credit goes to the originators. Apologies
all around. I do appreciate your work.
</small>
</p>
</div>
</div>

<hr class="divider divider-primary">
