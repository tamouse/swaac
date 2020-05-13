\#+COMMENT -**- time-stamp-line-limit: 15; time-stamp-count: 2 -**-

**WARNING: This is old and likely obsolete.**

TIL: Fixing a Capybara Problem Scrolling the Submit Button Into View on a Modal Form Test {#til-fixing-a-capybara-problem-scrolling-the-submit-button-into-view-on-a-modal-form-test last_update="Time-stamp: <2020-03-23 05:09:46 tamara>" capture_date="[2019-03-06 Wed]" keywords="testing, capybara, scrolling, modal"}
=========================================================================================

-   last~update~: Time-stamp: \<2020-03-23 05:09:46 tamara\>
-   capture~date~: \[2019-03-06 Wed\]
-   keywords: testing, capybara, scrolling, modal

Background
----------

In [the product I work on](https://www.kickserv.com/), we have a form to let a user create a new customer during the editing of a job. This form is quite long. In the test, the only required field, the Customer\'s name, is filled in, and the new customer modal form is submitted.

Problem
-------

Since the form is so long, the submit button is not visible on the page, so [Capybara](http://teamcapybara.github.io/capybara/) cannot find it to click on it.

Solution
--------

Scroll the modal so the submit button comes into view.

If you execute the following line in a Capybara test:

``` {.ruby}
page.execute_script "window.scrollBy(0,10000)"
```

it will scroll the window down, however, the modal isn\'t really sitting inside the window. It\'s definitely part of the DOM, but we need to scroll the modal itself.

So we grab the **modal DOM element** and tell it to scroll down:

``` {.ruby}
page.execute_script "document.getElementById('new-customer-modal').scroll(0, 10000)"
```

which makes the submit button come into view, and then the Capybara `.click` method works.

Caveats
-------

This works when you\'re using Chrome (visible or headless). It does **not** work in IE11 or lower, nor does it work in Safari mobile.

The same issue can arise when using [NightWatch.js](http://nightwatchjs.org/), with a similar solution to scroll the modal rather than the window.
