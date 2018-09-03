---
layout: post
title: "TIL: React Error boundary workarounds"
cateogies: [react]
tags: [react, errors, error-handling, error-boundaries, componentDidCatch]
source: https://reactjs.org/docs/error-boundaries.html
---

Recently I was working on a next-gen standalone react client for my
work, and I decided I wanted to put in error boundaries, which were
introduced in React v16. From the [docs]({{ page.sourc }}):

> Error boundaries are React components that catch JavaScript errors
> anywhere in their child component tree, log those errors, and
> display a fallback UI instead of the component tree that
> crashed. Error boundaries catch errors during rendering, in
> lifecycle methods, and in constructors of the whole tree below them.

This is well and good, but the first thing I ran into was how to catch
errors that happen outside of the space React's error boundaries work
in. The following aren't caught by `componentDidCatch`:

* Event handlers
* Asynchronous code (e.g. setTimeout or requestAnimationFrame callbacks)
* Server side rendering
* Errors thrown in the error boundary itself (rather than its
  children)

The particular problem I was working on was catching login errors,
which were returned as a promise rejection. Since the error boundary
didn't handle this, i searched for help on this, and got it in the
React.MN slack.

After thinking about it, it does make sense, since React is
declarative, this pretty much has to be handled as some form of
state. The key is, what to do?

I took a page out of some previous work where I was doing a
`<Redirect/>` when a state entry became `true` , so I did it again for
this. I'd catch the rejected promise in the handler, and set a state
variable to `true`:

```javascript
login = () => {
  logon()
    .then(
      // do logon stuff when it works
    )
    .catch(error => {
      this.setState({
        hasError: true,
        error
      })
    })
}
```

So now there's a state variable `hasError` that's true, and the actual
error in state. Down in the `render` method:

```javascript
render() {
  if (this.state.hasError) throw this.state.error

  // go on with no error
}
```

This does the bubble-up necessary for the error boundary to catch it.

Here's a codepen:

<p data-height="735" data-theme-id="0" data-slug-hash="ZxxdGO"
data-default-tab="js,result" data-user="tamouse"
data-embed-version="2" data-pen-title="ErrorBoundary Example"
class="codepen">See the Pen <a
href="https://codepen.io/tamouse/pen/ZxxdGO/">ErrorBoundary
Example</a> by Tamara Temple (<a
href="https://codepen.io/tamouse">@tamouse</a>) on <a
href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

&nbsp;

&nbsp;


It turns out I didn't use this to handle login errors, but it was a
useful excursion and learning experience anyway.
