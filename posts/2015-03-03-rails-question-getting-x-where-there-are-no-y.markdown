---
layout: post
title: "[Rails Question] Getting X where there are no Y"
date: 2015-03-03 05:38
categories: [rails]
tags: [questions, examples, code, ruby]
source: https://github.com/tamouse/example_questions_without_answers
---
There was a question recently in the `#RubyOnRails` IRC channel on
[freenode]: "How can I retrieve all the questions that don't have
answers?". [This Rails coding example shows the answer][source].

## Two Models

* Question
* Answer

## Associations

* Question *has_many* Answers
* Answer *belongs_to* Question

## Finding Questions with No Answers:

{% highlight ruby %}
Question.includes(:answers).where(answers: {id: nil})
{% endhighlight %}

## Converse: Finding All Questions that have Answers:

{% highlight ruby %}
Question.includes(:answers).where.not(answers: {id: nil})
{% endhighlight %}



[freenode]: http://www.freenode.net "Freenode IRC Network"
[source]: {{ page.source }} "GitHub repo for example source"
