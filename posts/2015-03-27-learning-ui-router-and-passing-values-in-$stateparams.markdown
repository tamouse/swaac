---
layout: post
title: "Learning: UI-Router and passing values in $stateParams"
date: 2015-03-27 00:37
categories: ["angularjs"]
tags: ["ui-router", "learning", "stateparams"]
source: https://github.com/angular-ui/ui-router/wiki/URL-Routing#stateparams-service
---
During a recent coding crunch towards putting on a demo, I was working
on the AngularJS client, trying to determine how to pass a value from
one state to another in ui-router.

AngularJS has a pretty steep learning curve (you're being steaped, so
to speak), and things like ui-router, while they make some things
easier, aren't necessarily easy to absorb quickly, especially under
the gun to get something ready in a quick fashion.

This particular note eluded me for a long time:

{% capture citation%}<a href="{{page.source}}">{{page.source}}</a>{% endcapture %}
{% include cited_quote.html source=page.source title=page.source citation=citation quote="As you saw previously the $stateParams service is an object that will have one key per url parameter." %}

## What this means:

Let's create a rather simple controller with the state of 'some' and a
url template of '/some/:variable' :

{% highlight javascript %}
angular.module('someCtrl', ['ui.router'])
  .config(function($stateProvider) {
    $stateProvider.state(
      'some', {
        url: '/some/:variable',
        controller: 'SomeCtrl',
        templateUrl: 'someCtrl.html'
      }
    );
  })
  .controller(
    'SomeCtrl',
    function($scope, $state) {
      // ...
    });
{% endhighlight %}

By defining the url variable `:variable`, you can then pass data
to it through `$stateParams.variable`:

{% highlight javascript %}
angular.module('OtherCtrl', ['ui.router'])
  .config(function($stateProvider) {
    $stateProvider.state(
      'other', {
        url: '/other',
        controller: 'OtherCtrl',
        templateUrl: 'other.html'
      }
    );
  })
  .controller(
    'OtherCtrl',
    function($scope, $state) {
      $scope.goSomewhere = function($state) {
        $state.go(
          'some',
          { variable: 'hithere' } // this goes into $stateParams for
                                  // state 'some'
        );
      }
    });
{% endhighlight %}

When `OtherCtrl.goSomewhere` is called, it will route to the
'some' state, and the 'hithere' will be passed in
`$stateParams.variable` field.

**HOWEVER** the thing that cost me hours is not understanding
that what is available in `$stateParams` *must* also be somehow
defined in the `$stateProvider.state` configuration's `url`
template.


{% highlight javascript %}
'/contacts/:contactId/phones/:phoneId'
{% endhighlight %}

maps to:

{% highlight javascript %}
$stateParams.contactId;
$stateParams.phoneId;
{% endhighlight %}

## What does NOT work

What you **CANNOT** do, though, is send through parameters which are
**NOT** in the `url` template:

{% highlight javascript %}
$state.go('some', {otherVariable: 'yo, dawg' });
{% endhighlight %}

as `otherVariable` is *not* defined in the url template for the
`SomeCtrl` controller.
