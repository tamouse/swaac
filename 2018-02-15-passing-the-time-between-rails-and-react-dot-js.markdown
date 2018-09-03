---
layout: post
title: "Passing the Time between Rails and React.js"
date: 2018-02-15 18:39
categories: ["webdev"]
tags: ["time-formats", "rails", "react", "data-interchange"]
---

One of the problems I've encountered with a recent project is
maintaining the integrity of Time and Date information going back and
forth between a Rails server and a React client.

While the issue isn't necessarily specific to React, it affects any
sort of JavaScript client using [JavaScript's Date][js-date] object.

[js-date]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date "JavaScript Date Built-in Object on MDN"

The source of my frustration with this particular project is that the
dates in the client are passed around in various different formats,
and there is a lot of reformatting of the dates happening.

One of my sort of tenants of programming is to never format a date
or time (or datetime, if you will) until it's necessary to display it
to the user. (This applies in general, but a lot for times.)

On the Rails side, as on most Unix-based systems, times are objects
with an underlying float value with the integer part being the number
of seconds since the Unix Epoc, 1970-01-01 at midnight UTC. (Often
times one can see dates such as Dec 31, 1969 show up because of
timezone conversions to North America. No, in fact, zero time is *not* on
Wednesday everywhere.)

Rails has the ability to translate time in and out of storage quite
well, but it's sometimes tricky.

JavaScript has the ability create and parse dates and times, but it's
lousy at formatting nice date, which brings in the `moment` library
which is quite popular.

What I'm talking about here, though, is the passing of time
information back and forth between a Rails server and the JavaScript
client.

Most of the time, when you serialize a Rails record, the time
information is converted to a string, with the default format that
looks like: `"Wed, 28 Feb 2018 17:59:28 UTC +00:00"` (the output of
`.to_s`). In nearly every case, that's not a very useful value to be
passing to other programs, which is why I'm converting it to
JSON, presumably.

So, the better conversion, to avoid all confusion about timezones,
time formats, etc., is to convert it to milliseconds, both going out
and coming back, and convert accordingly, e.g.:

    (object.created_at.to_f * 1000).to_i

In GraphQL-land, this would be the `lambda` on the `resolve` entry for
a `field`:

    field :created_at_ms, "Time of creation in milliseconds" do
      resolve ->(object, _args, _context) { (object.created_at.to_f * 1000).to_i }
    end

Or create a resolver class:

```ruby
class TimeFieldMilliseconds

  def initialize(field)
    @field = field
  end

  def call(object, _args, _context)
    (object.public_send(field) * 1000).to_i
  end

end
```

And declare the field as:

    field :created_at_ms, "Time of creation in milliseconds" { resolve TimeFieldMillisecond.new(:created_at) }

On the client side, convert the milliseconds to a Date object as:

    let createdAt = new Date(object.created_at_ms)

or when using moment:

    let createdAt = moment(object.created_at_ms)
