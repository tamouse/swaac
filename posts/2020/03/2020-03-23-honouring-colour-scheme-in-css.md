---
title: "Honouring the user's preferred colour scheme in CSS"
date: 2020-03-23T03:32
category: css
tags: [colour-scheme, dark-mode, light-mode, react, styled-components]
---

How do I honour the user's chosen preferred colour scheme in the CSS I'm writing? Recently MacOS introduced dark mode in Mojave, and further added a shifting light and dark mode to match the time of day in Catalina. I'd like my sites, but more importantly, my React apps to follow this.


## Background ##

The W3C has defined a media query, `prefers-color-scheme` ([Defined in Media Queries Level 5 Draft, March 2020](https://drafts.csswg.org/mediaqueries-5/#descdef-media-prefers-color-scheme "Still a draft")). It has [some implementations](https://caniuse.com/#search=prefers-color-scheme) already. At least it's on the majors, so it's probably okay to use.

## Media query ##

The check to see what colour scheme the user has set is done with a media query:

``` css
@media screen and (prefers-color-scheme: light) {
  /* settings for light scheme */
}
@media screen and (prefers-color-scheme: dark) {
  /* settings for dark scheme */
}
```

So this is clearly possible in regular CSS.

## Using in styled-components ##

Since I most often code in React, and most often use `styled-components` library to implement CSS-in-JS, I need a way that this will work. Turns out it's not so bad, using SC's `ThemeProvider`.

In your theme file, set up the various colours, with a group for light mode and another group for dark mode:

``` rjsx
const colors = {
    light: {
        primaryText: "#333",
        primaryBg: "#FFF",
        // and so on
    },
    dark: {
        primaryText: "#F2F2F2",
        primaryBg: "#000",
        // and so on
    },
    common: {
        // colors that work for both
    }
};

export default {
    colors
};

```

Where I wrap react components with the SC ThemeProvider, I can import and provide the theme as usual:

``` rjsx
import React from "react";
import { ThemeProvider} from 'styled-components';
import theme from "../../theme";

function App({ children }) {
    return (
        <ThemeProvider theme={theme} >
          {children}
        </ThemeProvider>
    );
}

export default App;
```

Then later, in the styled compeonent, this happens:

``` rjsx

import styled from 'styled-components';

export const SomeSection = styled.section`
  color: ${props => props.theme.colors.light.primaryText};
  backgound-color: ${props => props.theme.colors.light.primaryBg};

  @media screen and (prefers-color-scheme: light) {
    color: ${props => props.theme.colors.light.primaryText};
    backgound-color: ${props => props.theme.colors.light.primaryBg};
  }
  @media screen and (prefers-color-scheme: dark) {
    color: ${props => props.theme.colors.dark.primaryText};
    backgound-color: ${props => props.theme.colors.dark.primaryBg};
  }
`
```
