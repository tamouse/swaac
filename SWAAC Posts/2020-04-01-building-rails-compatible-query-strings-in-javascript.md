---
layout: post
title: "Building Rails-compatible Query Strings in JavaScript"
date: 2020-04-01T13:57
categories: [javascript]
tags: [query-string, javascript, functions, missing-libraries, rails]
---

The [MDN](https://developer.mozilla.org/en-US/ "Mozilla Development Network") defines the [URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams "The URLSearchParams interface defines utility methods to work with the query string of a URL") to help build query strings based on objects.

What it *doesn't* do, however, is build a Rails-compatible query string from a nested object, i.e., an object with properties that other objects, i.e. Object, Array, etc. This won't do anything if the parent object has a function property, but it's a pretty good implementation.

I don't even remember where this comes from, I've written it for so many different projects I just copy it from the last one.

The problem is that when given a params object like:

``` javascript
let params = {
    a: 27,
    b: "forty-two",
    c: [1, 2, 3, 5],
    d: { id: 2887, name: "Gillian" }
}
```

Passing this into URLSearchParams doesn't give a query string that Rails finds useful in parsing parameters up in the controller:

``` javascript
let qa = new URLSearchParams(params).toString()
```

yields: `a=27&b=forty-two&c=1,2,3,5&d=d=%5Bobject+Object%5D` which is *really* no good to Rails (doubt it would be good for express either, but that's not what this one's about).

So we need something a bit more on point:

``` javascript
function serializeObjectToRailsQueryString(params, prefix) {
  const query = Object.keys(params).map(key => {
     const value = params[key]

     if (params.constructor === Array) key = `${prefix}[]`
     else if (params.constructor === Object)
       key = prefix ? `${prefix}[${key}]` : key

     if (typeof value === "object")
       return serializeObjectToQueryString(value, key)
     else return `${key}=${encodeURIComponent(value)}`
   })

   return [].concat.apply([], query).join("&")
}
```

Passing that same params object above, yields the following:

``` javascript
"a=27&b=forty-two&c[]=1&c[]=2&c[]=3&c[]=5&d[id]=2887&d[name]=Gillian"
```

When the controller `params` method is called, it yields a AC::Parameters object of:

``` ruby

{
  a: 27,
  b: "forty-two",
  c: [1, 2, 3, 5],
  d: { id: 2887, name: "Gillian"}
}

```

just as we'd expect.

