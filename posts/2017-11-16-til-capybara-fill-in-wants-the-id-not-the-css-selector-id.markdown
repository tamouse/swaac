---
layout: post
title: "TIL: Capybara fill_in wants the id, not the CSS selector id"
date: 2017-11-16 14:12
categories: ["testing"]
tags: ["capybara", "rails", "testing", "forms", "fill_in"]
---

So today I learned that one should pay closer attention to what the
documetation says instead of just assuming you already know. RTFM^2.

In Capybara, you can fill in fields in forms using the `.fill_in()`
method. In
[the documentation](http://www.rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Actions#fill_in-instance_method)
it discusses the types of locators you can use:

> Locate a text field or text area and fill it in with the given text
> The field can be found via its name, id or label text.

It doesn't say *anything* about using a CSS selector!

So: this does not work:

    @modal.fill_in("#new-job-number-input-#{@job.id}", with: "999")

But this, however, **DOES** work:

    @modal.fill_in("new-job-number-input-#{@job.id}", with: "999")

That one, single "#" at the beginning of the string was throwing me
off, causing me to reach for other sorts of shenannigans to find the
field to fill in.

Hooray, persistence!
