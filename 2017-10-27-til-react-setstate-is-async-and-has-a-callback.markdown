---
layout: post
title: "TIL: React setState is async, and has a callback"
date: 2017-10-27 17:35
categories: ["webdev"]
tags: ["webdev", "react", "setState"]
source: "https://stackoverflow.com/questions/42038590/when-to-use-react-setstate-callback"
---

While this wasn't _today_ exactly, I just learned this recently, and
it made a difference for something I was working on.


I had been looking around for a way to determine if the component's
state had changed as I expected, mostly doing some debugging and
tracing, I discovered that `setState` is an asynchronous function. The
second parameter to `setState` is a callback function that runs when
the state has finished updating.

The [discussion](https://stackoverflow.com/a/42038724/742446) at
[stackoverflow]({{ page.source }}) gives a quite detailed explanation,
which is great.

In my case, doing a simplistic `console.log` debugging thing, I ended
up with


{% highlight javascript %}
handleUpdate() {
  var payload = {
    data: this.state.myData,
    other: this.props.someOtherCrap,
  }
  return mutate({
    variables: payload
  })
    .then(response => {
      this.setState({
        data: response.newData,
      },
      console.log(this.state))
    })
}
{% endhighlight %}

There are much better reasons for having that callback, of course, but
this is the one I found a need for at the time.
