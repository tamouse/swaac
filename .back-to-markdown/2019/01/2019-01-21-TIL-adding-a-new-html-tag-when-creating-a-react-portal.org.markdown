**WARNING: This is old and likely obsolete.**

TIL: Adding a new HTML tag name when creating a React Portal {#til-adding-a-new-html-tag-name-when-creating-a-react-portal keywords="react, portal, html, tag names" capture_date="Mon Jan 21 16:49:12 2019" last_update="Time-stamp: <2020-03-23 05:09:13 tamara>"}
============================================================

-   keywords: react, portal, html, tag names
-   capture date: Mon Jan 21 16:49:12 2019
-   last updated: Time-stamp: \<2020-03-23 05:09:13 tamara\>

I was working on a replacement for the `Modal` component in `react-bootstrap` since it is clear the library is moving away from where we want to be with our app.

While doing so, I noticed it was difficult to find the Portal that react creates in the DOM tree, since I was using just a regular old `<div>` element. Given in HTML5 you can invent your own HTML tag names (which Web Components and CSS Components take advantage of as well).

So I called the created element `<modal-portal>` and it\'s quite visible when it shows up in the DOM, and it makes an easy grab handle for testing.

In my `ModalPortal` component, the code looks like this:

``` {#ModalPortal.js .rjsx}
constructor(props) {
  super(props)
  this.el = document.createElement("modal-portal")
  this.modalRoot = document.querySelector(this.props.selector || "body")
}
```

In the DOM, the component looks like this:

``` {.html}
<modal-portal>
  <div class="modal fade in" style="display: block;">...</div>
</modal-portal>
```
