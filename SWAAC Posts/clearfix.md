Clearfix Example
================

Using floats sometimes creates a problem in your web page. Floats do not have any defined height in the page, and so if you want a block of text to appear after all the floats, you need to clear the floats. This sometimes means you\'ll need to place another `div` after all the floats just to place the \"clear: both\" and get rid of floating.

But this also creates another problem in remembering and inserting the extra div, plus, it\'s extra markup -- who needs that?

So, some super CSS gurus came up with the concept of a clearfix class that you can just add to a block element to ensure all floats within that element get cleared properly.

This is called the \"clearfix\".

This particular method is the [micro clearfix by Nick Gallagher](http://nicolasgallagher.com/micro-clearfix-hack/). It\'s probably the smallest amount of code to enable this.

Without Clearfix
----------------

<iframe src="./no-clearfix-example.html" width="800" height="600">

</iframe>

With Clearfix
-------------

<iframe src="./clearfix-example.html" width="800" height="600">

</iframe>

Implementing Clearfix
---------------------

`clearfix` is pretty simple to implement in regular old CSS:

``` {.css}
.clearfix:before,
.clearfix:after {
  content: " "; /* fixes a problem in Opera */
  display: table; /* fixes a problem with collapsing margins */
}
.clearfix:after {
  clear: both; /* this is what clears the floats */
}
```
