---
layout: post
title: "Testing blur() events in Cucumber/Capybara"
date: 2016-10-10 16:18
categories: ["testing"]
tags: ["testing", "cucumber", "steps", "capybara", "blur", "focus", "using", "send_keys"]

---

After banging my head on this problem for a long time, chasing blog
posts, stackoverflow, lots of opinions, bug reports, and so on, I
finally asked my workmates, and together we arrived at a method that
works.

## The Problem

There is apparently a bug, although it's marked as INVALID in
bugzilla, that prevents `focus()` and `blur()` events from being
executed directly when the test browser is not focused.

The links I chased:

* https://github.com/mattheworiordan/jquery-focus-selenium-webkit-fix
* https://github.com/mattheworiordan/jquery-focus-selenium-webkit-fix/blob/master/app/assets/javascripts/jquery.focus.test-fix.js
* https://makandracards.com/makandra/12661-how-to-solve-selenium-focus-issues

And many many more...

## What worked

The most obviously glaring thing to do is **NOT** make this event
happen via executing a JS script, but by simply **SENDING A TAB**.

Here's the step:

``` ruby
When(/^I unfocus field (.*?)$/) do |field_name|
  field = page.find_field(field_name)
  field.native.send_keys :tab
end
```

That did the trick, and now we all have an uncle Bob.

Thanks Nic and JD
