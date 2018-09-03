---
layout: post
title: "TIL: Call done() to fire async mocha tests"
date: 2017-01-16 02:03
categories: ["javascript"]
tags: ["mocha", "async", "testing"]
---

Working on [my first express API call]({% post_url 2017-01-16-my-first-proxy-slash-adapter-for-an-express-dot-js-app %})
this weekend, I learned something important for testing.

I was running the test over and over and could not figure out why it
was just running to completion instead of performing the call.

This was driving me nuts.

Mocha has an added bit where it passes in a callback to tell it when
the asynchronous tests finish. This had completely eluded me, but one
of the HackTheGap mentors told me about it, and everything started to
work.

{% highlight javascript linenos %}
describe('tests', function () {
  it('does an async thing', function (done) {
    do_an_async_thing(test_data, function (data) {
      expect(data).to.be.ok();
      done();
    });
  });
});
{% endhighlight %}

Passing `done` to the `it` function callback is what sets things in
motion. Mocha then knows there is some async piece to happen, and
calling `done()` at the end of the test case signals back to mocha
that an async test has finished.

Very important!
