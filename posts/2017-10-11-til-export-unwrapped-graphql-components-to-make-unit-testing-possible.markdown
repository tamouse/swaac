---
layout: post
title: "TIL: Export Unwrapped GraphQL Components to make Unit Testing Possible"
date: 2017-10-11 18:02
categories: ["graphql"]
tags: ["react", "react-apollo", "graphql", "testing", "jest", "unit-test"]
---

This was a sanity-saver.

I've been writing some React container components to handle dealing
with some GraphQL mutations, and I wanted to unit test some of the
functions inside.

Since I was only exporting the graphql-wrapped component, I felt a
little stuck in trying to come up with a way to mock the ApolloClient
in the ApolloProvider. It was getting crazy.

I asked in the #react-apollo channel in the Apollo slack team, and got
a *great* response:

```
tamouse [5:30 PM]
I’m looking for some guidance on doing unit testing with react-apollo components. Is there some kind of Mock I can set up for the ApolloProvider?


slightlytyler [5:32 PM]
@tamouse why not use the real provider and provide a mock network interface?

once you start testing with apollo / graphql it's not really a unit test anymore


tamouse [5:33 PM]
perhaps, but how do you test the functions inside a wrapped component?


slightlytyler [5:33 PM]
I render the unwrapped component with mock functions

that's a unit test imo


tamouse [5:33 PM]
so you export both wrapped and unwrapped forms?


slightlytyler [5:34 PM]
yup
```

Wow.

Captain Oblivious.

This is the simplest way to do this, bar none.


{% highlight jsx %}
export class MyComp extends React.Component { ... }

export default graphql(mutation)(MyComp)
{% endhighlight %}

In the code, I can import the wrapped component:


{% highlight jsx %}
import MyComp from './MyComp'
{% endhighlight %}

And in the test, I can import the *un*-wrapped component:


{% highlight jsx %}
import {MyComp} from './MyComp
{% endhighlight %}

So Cool!
