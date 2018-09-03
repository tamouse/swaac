---
layout: post
title: "TIL: ApolloClient Authentication (graphql)"
date: 2017-07-22 02:19
categories: ["webdev"]
tags: ["graphql", "react", "apollo-client"]

---

Continuing to work on the GraphQL Client and Server project at work,
today I learned how to authenticate using ApolloClient.

(Note: there's lots I've learned the past couple of weeks, but I
haven't gotten to write everything up. This is just today's big
learning.)

It turns out that authenticating is rather easy when you're working in
a same origin situation, i.e., the React Apollo client is calling an
endpoint from the same domain the React client was downloaded from.

The [Authentication](http://dev.apollodata.com/react/auth.html) page
for the React Apollo client is very straight-forward in it's
explanation. Since the application is using Cookies to keep the
authentication for the app, the following code works well:

{% highlight javascript %}
// source: client/src/apolloClient.js
import { ApolloClient, createNetworkInterface } from 'react-apollo';

const networkInterface = createNetworkInterface({
  uri: '/graphql',
  opts: {
    credentials: 'same-origin'
  }
})

const client = new ApolloClient({
  networkInterface
});

export default client
{% endhighlight %}

The essential bit is tne `credentials: 'same-origin'`
option. ApolloClient knows how to handle these and builds the request
header with the appropriate cookies.

I'm sort of embarassed how long it took me to figure out that this was
the solution to the problem I was having, since all I was seeing was
an Internal Server Error.
