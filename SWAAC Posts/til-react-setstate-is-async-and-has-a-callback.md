**WARNING: This is old and likely obsolete.**

TIL: React setState is async, and has a callback {#til-react-setstate-is-async-and-has-a-callback published_date="2017-10-27T17:35" keywords="webdev, react, setState"}
================================================

-   PUBLISHED\\~DATE~: 2017-10-27T17:35
-   KEYWORDS: webdev, react, setState

While this wasn\'t *today* exactly, I just learned this recently, and it made a difference for something I was working on.

I had been looking around for a way to determine if the component\'s state had changed as I expected, mostly doing some debugging and tracing, I discovered that `setState` is an asynchronous function. The second parameter to `setState` is a callback function that runs when the state has finished updating.

[Official documentation on `setState` as of React 16.4](https://reactjs.org/docs/react-component.html#setstate)

The [discussion](https://stackoverflow.com/a/42038724/742446) at [stackoverflow](https://stackoverflow.com/questions/42038590/when-to-use-react-setstate-callback) gives a quite detailed explanation, which is great.

In my case, doing a simplistic `console.log` debugging thing, I ended up with

``` {.javascript}
handleUpdate() {
    let payload = {
        data: this.state.myData,
        other: this.props.someOtherCrap,
    }
    return mutate({
        variables: payload
    })
        .then(response => {
            this.setState({
                data: response.newData,
            },
                          console.log(this.state))
        })
}
```

There are much better reasons for having that callback, of course, but this is the one I found a need for at the time.

Update 2018-09-03T17:52:52-0500
-------------------------------

I\'ve since found several uses for the callback, which included calling a callback function that sends an update to a consumer component or the context when something in state is updated. I\'ve also been finding a use to use the function form of the first paramter:

``` {.javascript}
handleUpdate = () => {
    let payload = {
        data: this.state.myData,
        other: this.props.someOtherThing
    }
    return mutate({
        variables: payload
    })
        .then(({ loading, error, mutationName }) => {
            this.setState(
                state => ({
                    data: mutationName
                }),
                () => {
                    this.props.updateCaller(mutationName)
                })
        })
}

```
