**WARNING: This is old and likely obsolete.**

Side-by-side layout with CSS Grid {#side-by-side-layout-with-css-grid published_date="2017-12-03 21:58" keywords="css, grid, layout, webdesign, react"}
=================================

-   date: 2017-12-03 21:58
-   keywords: css, grid, layout, webdesign, react

In my continuing search for my \"best\" web site layout, I\'ve come down pretty strongly on the side-by-side \"dashboard\" style, where there aren\'t page headers or footers. The reasons I\'m not particularly liking page headers and footers has to do with the way I tend to scroll through sites, but pressing the spacebar. This tends to make the content scroll underneath the fixed headers, and I have to back up using the up arrow. It\'s a pain with so many other websites, especially when they interpret using the up arrow as \"The User must want more options in the header! Let\'s make it BIGGER\" which means I have to up arrow even more.

So.

Creating a Grid side-by-side layout with 100% stretch
-----------------------------------------------------

Here\'s a [Codepen.IO Pen](https://codepen.io/tamouse/pen/KyEPPG) that creates that layout using CSS Grid.

<p data-height="597" data-theme-id="0" data-slug-hash="KyEPPG" data-default-tab="css,result" data-user="tamouse" data-embed-version="2" data-pen-title="side-by-side dashboard layout using grid" class="codepen">

See the Pen side-by-side dashboard layout using grid by Tamara Temple (@tamouse) on CodePen.

</p>

<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

The important thing to remember about this:
-------------------------------------------

> When I want an inner block to stretch to the full height of the window, I must set that inner block element, **and all wrapping block elements** height to 100%.

Making this work on a React app
-------------------------------

In a typical React app, I have 4 levels that need to be set to 100%:

-   html
-   body
-   app component
-   the div inside the app component

The canonical react app, as `create-react-app` defines it, looks like so:

``` {.html}
<html>
  <head> .... </head>
  <body>
    <div id="app">React app loading...</div>
  </body>
</html>
```

After the react app loads, it looks like so:

``` {.html}
<html>
  <head> .... </head>
  <body>
    <div id="app">
      <div id="react__app">... </div>
    </div>
  </body>
</html>
```

(Just off the top of my head, I\'m unsure what the react app\'s `div` looks like exactly, but I\'m sure it *is* a `div` element so the below will work.)

So I use this as my basic CSS:

``` {.css}
html, body, body > #app, #app > div { height: 100%; }
```

to get the react app to fill the full window height like I want it.
