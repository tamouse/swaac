---
layout: post
title: "New Hash Operators in Ruby 2.3"
date: 2016-03-14 23:27
categories: ["ruby"]
tags: ["hashes", "new-2.3", "operators"]

---

There are some new Hash operators in Ruby 2.3:

Subset operators:

* [`<`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-3C) - hash is a subset of other
* [`<=`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-3C-3D) - hash is a subset or equal to other
* [`>`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-3E) - other is a subset of hash
* [`>=`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-3E-3D) - other is a subset or equal to hash

Others:

* [`dig`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-dig) - "Extracts the nested value specified by the sequence of *idx* objects by calling `dig` at each step, returning `nil` if any intermediate step is `nil`."
* [`fetch_values`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-fetch_values) - "Returns an array containing the values associated with the given keys but also raises `KeyError` when one of keys can’t be found. Also see `Hash#values_at` and `Hash#fetch`."
* [`to_proc`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-to_proc) - this isn't documented, it seems
