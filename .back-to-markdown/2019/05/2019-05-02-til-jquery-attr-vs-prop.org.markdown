\#+COMMENT -**- time-stamp-line-limit: 20; time-stamp-count: 2 -**-

**WARNING: This is old and likely obsolete.**

TIL: jQuery .attr() vs .prop() {#til-jquery-.attr-vs-.prop-1}
==============================

-   last update: Time-stamp: \<2020-03-23 05:12:08 tamara\>

Intro
-----

Sometime in the past, jQuery only had an `.attr()` method for looking at and setting an element\'s attributes. More recently, it acquired the `.prop()` method for setting a node\'s properties.

Radio Button example
--------------------

The problem I ran into this with was old code that dealt with toggling radio buttons on a form:

``` {.rjsx}
$('#customer_which_billing_address_service').attr('checked', true);
```

This would set the sense of the attribute in the source, but it wouldn\'t change the property, so the radio button remained unchecked visually; in addition, when the form was submitted the radio buttons set didn\'t get posted correctly.

Changing this to the `.prop()` method fixed both problems:

``` {.rjsx}
$('#customer_which_billing_address_parent').prop('checked', false);
$('#customer_which_billing_address_service').prop('checked', true);
```

This visually set the proper radio button, and when the form was submitted the correct radio button value was posted.
