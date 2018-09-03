---
layout: post
title: "Learning ReactNative"
date: 2016-07-09 01:18
categories:
  - react-native
tags:
  - learning
  - react
  - react-native
  - learning-notes

---

Notes and reflections on learning [ReactNative], from a workshop by [Scott Moss] at [FrontendMasters].

[ReactNative]: https://facebook.github.io/react-native/
[Scott Moss]: https://github.com/hendrixer
[FrontendMasters]: https://frontendmasters.com/

## What is ReactNative?

A version of [React] that builds native applications on [iOS] and [Android].

[React]: https://facebook.github.io/react/

## Create a new app


{% highlight bash %}
$ react-native init <ProjectName>
{% endhighlight %}

Afterwards, the instructions are pretty simple:

> To run your app on iOS:

{% highlight bash %}
cd your_app
react-native run-ios
{% endhighlight %}

> \- or -

> Open your_app/ios/my_react_native_todo_app.xcodeproj in Xcode
> Hit the Run button

> To run your app on Android:
> Have an Android emulator running (quickest way to get started), or a device connected

{% highlight bash %}
cd your_app
react-native run-android
{% endhighlight %}

## A few chores

{% highlight bash %}
git init
echo 'description of your app' | tee README.md > .git/description
hub create -d "$(cat README.md)"
npm init # fill in missing info
{% endhighlight %}

## Watchman

[Watchman] is a utility that is used by [ReactNative] in development
mode to notify the system to rebuild when a file changes. I don't
particularly like it, and it seems problematic. It's also a resource
hog. For instance, I can't run Spotify at the same time I'm working
(sux).

[Watchman]: https://facebook.github.io/watchman/ "Facebook's Watchman Tool"

Make to shut down the watchman server when switching projects.

{% highlight bash %}
watchman shutdown-server
{% endhighlight %}

## Json-Server

In order to have a nice server store, I'm using the [json-server]
module. It provides a nice RESTful server endpoint for the data you
want to serve up.

[json-server]: https://www.npmjs.com/package/json-server "Serves JSON files through REST routes."

### Initialize the data file

Create the `db.json` file with the following content:


{% highlight json %}
{
  "todos": []
}
{% endhighlight %}

Make sure the key is in quotes -- it's **JSON** not JavaScript.

**Caveat:** if you decide to pre-populate the database, make **sure**
that you have an `id` field for each record.


## Redux

[Redux] is the predictable state container for JavaScript. React has
been associated strongly the Redux, although it's not the only option
on the block (see [RxJs] too).

[Redux]: http://redux.js.org/
[RxJs]: http://reactivex.io/ "An API for async programming with observable streams"

### `.fetch()`

The [`.fetch()`][fetch] function is the new, modern replacement for
doing AJAX-y things with XmlHttpRequest. It's a cleaner interface and
built right in. Using [isomorphic-fetch] lets you use it browser or
server side to perform [async actions]. It's a bit odd for a name,
though, since you can use any of the HTTP verbs with it, not just GET.

[fetch]: https://developer.mozilla.org/en-US/docs/Web/API/GlobalFetch/fetch "GlobalFetch.fetch @ MDN"
[async actions]: http://redux.js.org/docs/advanced/AsyncActions.html "Async Actions"
[isomorphic-fetch]: https://www.npmjs.com/package/isomorphic-fetch "Isomorphic WHATWG Fetch API, for Node &amp; Browserify"



**NOTE:** remember that `.json()` on the `Response` object is a
*function*.

{% highlight javascript linenos %}
export function fetchTodos() {
  return dispatch => {
    dispatch(requestTodos())
    return fetch(ENDPOINT)
      .then(response => response.json())
      .then(json => dispatch(receivedTodos(json)))
  }
}
{% endhighlight %}

## Testing

I'm testing with [Mocha] and [Chai] modules

[Mocha]: http://mochajs.org/ "Mocha JS testing framework"
[Chai]: http://chaijs.com/ "Chai Assertion Library"

<del>Because I'm using `babel` in the tests, I also needed to install
`bable-preset-react` to get the `run-ios` to work.</del>

In fact, using Mocha like this causes `react-native` to have
conniptions, so I'm taking out the `.babelrc` file until I can figure
out how to have both tests and native. :(
