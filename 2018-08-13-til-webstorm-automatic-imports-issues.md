---
layout: post
title: "TIL: WebStorm automatic import problems"
date: 2018-08-13 12:26
categories: ["tools"]
tags: ["tools","webstorm"]
---

Working today in webstorm, I spent about an hour trying to figure out why a particular test was failing. I didn't realize that webstorm had fumbled an automatic import line.

The situation was, I had copied copied a couple lines fron one file to another one, and webstorm is happy to offer to create the import statements for you when you do this.

However, webstorm may not get the actual import correct.

In this case, it wrote the import statement as

    import { graphql } from "react-apollo/index"

when it should have been

    import { graphql } from "react-apollo"

This was throwing errors in testing that looked like

```
  ● Test suite failed to run

    /Users/tamara.temple/Projects/react/kickserv/node_modules/react-apollo/index.js:1
    ({"Object.<anonymous>":function(module,exports,require,__dirname,__filename,global,jest){export * from './browser';
                                                                                             ^^^^^^

    SyntaxError: Unexpected token export

      at ScriptTransformer._transformAndBuildScript (node_modules/jest-runtime/build/script_transformer.js:305:17)
      at Object.<anonymous> (app/javascript/src/client/src/concepts/customers/new/NewCustomerModal.js:3:14)
      at Object.<anonymous> (app/javascript/src/client/src/concepts/customers/new/NewCustomerModal.test.js:3:25)

```
