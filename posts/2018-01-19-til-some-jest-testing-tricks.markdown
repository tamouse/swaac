---
layout: post
title: "TIL: Some Jest testing tricks"
date: 2018-01-19 22:12
categories: ["testing"]
tags:
  - jest
  - testing
  - react
  - instance
  - beforeEach
  - beforeAll
  - setup-teardown
---
Deeper learning after much pondering and RTFM for Jest

* Contents
{:toc}

## TIL: using beforeAll and beforeEach in jest tests

This has been bugging me for awhile. I have wanted to set up things
in `beforeAll` and `beforeEach` functions, like I do in RSpec, but
couldn't quite figure out how to get them in the `it` calls.

Turns out to be stupid simple. All you need to do is set the items
on the `global` context, like so:

{% highlight javascript %}
beforeAll(()=>{
  global.TagsInstance = new Tags({
    item: item,
    item_type: "Job",
    data: data,
    mutate: noop
  })
})
{% endhighlight %}

After the suite finishes, clear out the item:

{% highlight javascript %}
afterAll(()=>{
  global.TagsInstance = undefined
})
{% endhighlight %}

I suppose that pollutes the global space, so one might want to do
it in a namespace, and then clear that every time, too:


{% highlight javascript %}

beforeEach(()=>{
  global.beforeEach.actual = mount(
    <Tag item={item}/>
  )
})

afterEach(()=>{
  global.beforeEach = undefined
})
{% endhighlight %}

# TIL: you can call instance variables and functions on an Enzyme wrapper

Okay, this is very cool. I didn't know this would work BUT IT DOES!

This involves a few different things:

- calling a method on a mounted instance of a component
- putting an expect on a callback
- interogating a mounted component's state

{% highlight javascript %}
it("can i call stuff directly?", ()=>{
  const actual = mount(<MyComponent />)
  actual.instance().setState({ boo: "boo"}, () => {
    expect(actual.instance().state.boo).toEqual("boo")
  })
})
{% endhighlight %}
