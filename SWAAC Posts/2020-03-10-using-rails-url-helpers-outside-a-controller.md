---
title: "Using Rails url_helpers outside a controller context"
date: 2020-03-10T20:38
categories: [rails]
tags: [rails, helpers, url_helpers]
---

Sometimes I want to use a Rails url helper method outside the controller context.

Link: [Explanation on StackOverflow](https://stackoverflow.com/a/5456103 "good examples for doing this")

In essence:

``` ruby
Rails.application.routes.url_helpers.new_post_path
```


