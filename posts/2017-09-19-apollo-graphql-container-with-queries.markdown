---
layout: post
title: "Apollo graphql container with queries"
date: 2017-09-19 18:29
categories: ["webdev"]
tags: ["graphql", "react", "apollo", "api"]
source: http://dev.apollodata.com/react/api-queries.html#graphql-query-data
---

The [graphql] function in [Apollo] &nbsp;[client] wraps queries with
a `data` property. The _canonical_ component wrapped with a query
should look like this:

[graphql]: http://dev.apollodata.com/react/api-graphql.html "graphql API docs"
[Apollo]: http://dev.apollodata.com/ "ApolloData Developer Documentation"
[client]: http://dev.apollodata.com/react/ "Apollo React Client"

{% highlight jsx %}
const MyComponent = props => {

  const { data: { loading, error, data_name } } = this.props;
  if (loading) {
    return <p>Loading...</p>;
  } else if (error) {
    return <p>Error!</p>;
  } else {
    return (
      <div>
        { blah blah }
      </div>
    );
  }

}
{% endhighlight %}


I've been using the pattern of wrapping a super-presentational component
in the graphql component, so that file only really deals with one
thing. This might be overkill; I could also write the file that the
`graphql` HOC wraps in another file, too, and just remember to process
the `loading`, `error`, and returned data.

The form typically given in the tutorials and docs looks rather like
this when put all together:


{% highlight jsx %}
import React from 'react'
// import PropTypes from 'prop-types'
import styled from 'styled-components'
import {graphql, gql} from 'react-apollo'
import PostSummary from './PostSummary'

const listPosts = gql`query Posts{viewer {public_posts {id title excerpt publishedAt}}}`

const PostsIndex = props => {
  const { data: { loading, error, viewer}, ...rest } = props

  if (loading) return <Loading>Loading...</Loading>
  if (error) return (
    <Error>
      <h3>Error:</h3>
      <p>{error}</p>
    </Error>
  )

  const {public_posts} = viewer

  if (!public_posts) return (
    <PostsListing {...rest}>No posts</PostsListing>
  )

  return (
    <PostsListing {...rest}>
      <h1>Posts</h1>
      {public_posts.map((post, idx) => {
        return <PostSummary post={post} key={idx} />
      })}
    </PostsListing>
  )
}

const PostsIndexWithData = graphql(listPosts)(PostsIndex)

PostsIndexWithData.propTypes = {}
PostsIndexWithData.defaultProps = {}

export default PostsIndexWithData

const Loading = styled.div`
  font-size: 2em;
  color: RebeccaPurple;
  background-color: PapayaWhip;
  margin: 10px;
  padding: 10px;
`

const Error = styled.div`
  backgound-color: rgb(245, 147, 156, 0.7);
  color: red;
  border: 1 solid red;
  margin: 10px;
  padding: 10px;
`

const PostsListing = styled.div`
  backgound-color: rgb(252, 243, 207, 0.7);
  color: black;
  border: 1 solid black;
  margin: 10px;
  padding: 10px;
`

{% endhighlight %}


{% include graphql_learning_project %}
