**WARNING: This is old and likely obsolete.**

TIL: Export Unwrapped GraphQL Components to make Unit Testing Possible {#til-export-unwrapped-graphql-components-to-make-unit-testing-possible published_date="2017-10-11T18:02" keywords="react, react-apollo, graphql, testing, jest, unit testing"}
======================================================================

-   PUBLISHED~DATE~: 2017-10-11T18:02
-   KEYWORDS: react, react-apollo, graphql, testing, jest, unit testing

This was a sanity-saver.

I\'ve been writing some React container components to handle dealing with some GraphQL mutations, and I wanted to unit test some of the functions inside.

Since I was only exporting the graphql-wrapped component, I felt a little stuck in trying to come up with a way to mock the ApolloClient in the ApolloProvider. It was getting crazy.

I asked in the `#react-apollo` channel in the Apollo slack team, and got a *great* response:

``` {.example}
tamouse [5:30 PM]
I’m looking for some guidance on doing unit testing with react-apollo components. Is there some kind of Mock I can set up for the ApolloProvider?


slightlytyler [5:32 PM]
@tamouse why not use the real provider and provide a mock network interface?

once you start testing with apollo / graphql it's not really a unit test anymore


tamouse [5:33 PM]
perhaps, but how do you test the functions inside a wrapped component?


slightlytyler [5:33 PM]
I render the unwrapped component with mock functions

that's a unit test imo


tamouse [5:33 PM]
so you export both wrapped and unwrapped forms?


slightlytyler [5:34 PM]
yup
```

Wow.

Captain Oblivious.

This is the simplest way to do this, bar none.

``` {.javascript}
export class MyComp extends React.Component { ... }

export default graphql(mutation)(MyComp)
```

In the code, I can import the wrapped component:

``` {.javascript}
import MyComp from './MyComp'
```

And in the test, I can import the *un*-wrapped component:

``` {.javascript}
import { MyComp } from './MyComp
```

So Cool!
