---
layout: post
title: Postgresql Timestamp Accuracy and Precision
date: 2017-05-09 21:31
categories: ['postgresql']
tags: ['postgresql', 'databases', 'timestamps', 'test']
---

Today at work, a question came up whether one could count on the last
inserted item in a table to have the most recent value for the
`created_at` timestamp, so I went looking.

* Contents
{:toc}

## RTFM

The
[postgresql documentation](https://www.postgresql.org/docs/9.6/static/index.html) for
[Date / Time Types](https://www.postgresql.org/docs/9.6/static/datatype-datetime.html) shows
the resolution as 14 digits and 1 microsecond.

## FactoryGirl insert

I ran a small experiment where I first used `FactoryGirl` to insert 50
records. These showed only increasing timestamps showing there's
enough resolution at a microsecond to distinguish insertion order
accurately building and inserting objects with FG.

{% highlight sql %}
select id,created_at from posts;
 id  |         created_at
-----+----------------------------
 453 | 2017-05-10 03:24:20.065175
 454 | 2017-05-10 03:24:20.074039
 455 | 2017-05-10 03:24:20.077969
 456 | 2017-05-10 03:24:20.08049
{% endhighlight %}

## Create multiple records

Next I tried it by creating an array of new values and passing it to
the `.create` method of the Model. This also showed plenty of
resolution where none of them would be considdred a "tie" when
ordering.

{% highlight sql %}
select id,created_at from posts;
 id  |         created_at
-----+----------------------------
 553 | 2017-05-10 03:26:22.415659
 554 | 2017-05-10 03:26:22.432941
 555 | 2017-05-10 03:26:22.436157
 556 | 2017-05-10 03:26:22.437815
 557 | 2017-05-10 03:26:22.439465
{% endhighlight %}

## SQL Insert with date formatting

One of the things Rails is poor at is mass uploading. In the past I've
used techniques to get around this. So giving that a go, I built a set
of insert statements that used rails's `DateTime.now` to generate the
timestamp.

{% highlight ruby %}
data = (1..100).map do |_|
  OpenStruct.new(
    content: Faker::Lorem.sentence,
    created_at: DateTime.now,
    updated_at: DateTime.now
  )
end
{% endhighlight %}

Then made that into an SQL statement.

{% highlight ruby %}
insert = data.map do |x|
  "insert into posts (content, created_at, updated_at) " +
  "values ('#{x.content}', '#{x.created_at.strftime("%FT%T.%6N%Z")}', " +
  "'#{x.updated_at.strftime("%FT%T.%6N%Z")}' ); "
end.join();
{% endhighlight %}

This gave the same result of increasing timestamps.

{% highlight sql %}
select id,created_at from posts;
 id  |         created_at
-----+----------------------------
 603 | 2017-05-09 22:29:35.038286
 604 | 2017-05-09 22:29:35.038382
 605 | 2017-05-09 22:29:35.038421
 606 | 2017-05-09 22:29:35.038455
 607 | 2017-05-09 22:29:35.038484
{% endhighlight %}

### Forgetting the milliseconds: Ooops

Note that if the milliseconds are not included in the `strftime`
method above, then it is quite possible to insert timestamps that look
the same.

{% highlight ruby %}
insert = data.map do |x|
  "insert into posts (content, created_at, updated_at) " +
  "values ('#{x.content}', '#{x.created_at.strftime("%FT%T%Z")}', " +
  "'#{x.updated_at.strftime("%FT%T%Z")}' ); "
end.join();
{% endhighlight %}

Oops:

{% highlight sql %}
select id,created_at from posts;
 id  |     created_at
-----+---------------------
 703 | 2017-05-09 22:42:57
 704 | 2017-05-09 22:42:57
 705 | 2017-05-09 22:42:57
 706 | 2017-05-09 22:42:57
{% endhighlight %}

## SQL `now()` function

Next, I build an SQL query using the `now()` method for each new
record.

{% highlight sql %}
select id,created_at from posts;
 id  |         created_at
-----+----------------------------
 653 | 2017-05-10 03:36:42.252631
 654 | 2017-05-10 03:36:42.252631
 655 | 2017-05-10 03:36:42.252631
 656 | 2017-05-10 03:36:42.252631
 657 | 2017-05-10 03:36:42.252631
{% endhighlight %}

Here we can see that every value inserted got the same
timestamp. Conclusion that Postgresql calculates `now()` once in
compiling the insert statement.

## Single insert statement, multiple values with `now()`

Final check, using a single `insert into` statement with
multiple values.

{% highlight sql %}
insert into posts (content, created_at, updated_at) values
  ('Aut exercitationem harum molestiae.', now(), now()),
  ('Aliquid sit et distinctio quidem minima ut.', now(), now()),
  ('Officiis dolores cupiditate aut sit.', now(), now());
{% endhighlight %}

(only for 100 items.)

This gives the same result as the previous, as expected.

{% highlight text %}
select id,created_at from posts;
 id  |         created_at
-----+----------------------------
 353 | 2017-05-10 03:04:59.684801
 354 | 2017-05-10 03:04:59.684801
 355 | 2017-05-10 03:04:59.684801
 356 | 2017-05-10 03:04:59.684801
 357 | 2017-05-10 03:04:59.684801
{% endhighlight %}


## Conclusion

So it seems as though one might not be able to count on inserted
values having an increasing `created_at` value, but this won't come up
very often in a Rails app unless you're doing mass-inserts like the
above.
