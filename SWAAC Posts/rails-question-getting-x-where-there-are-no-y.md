\[Rails Question\] Getting X where there are no Y
=================================================

**WARNING: This is old and likely obsolete.**

-   published date: 2015-03-03 05:38
-   keywords: \[\"code\", \"examples\", \"questions\", \"rails\", \"ruby\"\]
-   source: <https://github.com/tamouse/example_questions_without_answers>

There was a question recently in the `#RubyOnRails` IRC channel on [freenode](http://www.freenode.net): \"How can I retrieve all the questions that don\'t have answers?\". [This Rails coding example shows the answer](https://github.com/tamouse/example_questions_without_answers).

Two Models
----------

-   Question
-   Answer

Associations
------------

-   Question *has~many~* Answers
-   Answer *belongs~to~* Question

Finding Questions with No Answers:
----------------------------------

``` {.ruby}
Question.includes(:answers).where(answers: {id: nil})
```

Converse: Finding All Questions that have Answers:
--------------------------------------------------

``` {.ruby}
Question.includes(:answers).where.not(answers: {id: nil})
```
