---
layout: post
title: "Using Current User (Viewer) as root of GraphQL queries"
date: 2017-09-19 21:09
categories: ["webdev"]
tags: ["graphql", "graphql-ruby", "authorization", "viewer-rooted-graph"]
source: https://youtu.be/etax3aEe2dA
---

I was watching a [youtube video by Dan Schafer]({{ page.source }}) of
Facebook where he talks about a lot of things, with the immedate
take-away for me of rooting the graphql query in the current viewer or
user of the website (big assumption this is being driven by a user
sitting in front of a client.)

The idea makes sense to me, as it's a way of establishing who is
requesting info and be able to authorize the queries and mutations.

For [graphql-ruby], this means setting up the Query graph like so:

[graphql-ruby]: https://github.com/rmosolgo/graphql-ruby/tree/master/lib/graphql "Ruby implementation of GraphQL"

{% highlight ruby %}
Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  field :viewer, Types::ViewerType, "Viewer of data, may be an anonymous user or registered user" do
    resolve ->(_object, _args, context) do
      if context[:current_user].present?
        context[:current_user]
      else
        NullUser.new
      end
    end
  end
end
{% endhighlight %}

The viewer type is reflective of the `User` model in the data store,
which is what is contained in the `current_user` in the context passed
in. That value can be obtained in a few ways: some typical to Rails
apps, through OAuth, through JWTs, etc. It's not especially important
here how the current user is determined to the graphql system, as it
should be. Here we can see that if there is no current user in the
context, a "Null User" object is returned.

For sake of clarity, the `ViewerType` is:

{% highlight ruby %}
Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"
  field :id, !types.ID, hash_key: :uuid
  field :name, !types.String
  field :email, !types.String
  field :my_posts, types[Types::PostType] do
    resolve ->(obj, _, _) { obj.posts }
  end

  field :public_posts, types[Types::PostType] do
    resolve ->(_,_,_){ Post.publised }
  end
  field :all_authors, types[Types::UserType] do
    resolve ->(_,_,_){ User.all }
  end
end
{% endhighlight %}

Giving the above a query like:


{% highlight text %}
query Query { viewer { public_posts { title excerpt publishedAt }}}
{% endhighlight %}

Will return a JSON object like:


{% highlight json %}
{
  "data" : {
    "viewer": {
      "public_posts": [
        {
          "title": "Some post title",
          "excerpt": "It was a dark and stormy night...",
          "publishedAt": "2017-09-18T12:25:03.005600-05:00"
        },
        {
          "title": "Another post",
          "excerpt": "We were once free to roam the...",
          "publishedAt": "2017-09-18T12:25:03.005600-05:00"
        }
      ]
    }
  }
}
{% endhighlight %}


Here's something I'm doing, which I haven't seen anywhere else yet.

The application is the canonical micropost system, with users, posts,
and (eventually) comments.

Posts belong to Users, Comments belong to both Users and Posts. A rule
would be that all published posts are visible to everyone, and these
are gathered with the `:public_posts` field.

Another rule would be that only the post's author can update, publish,
or delete a given post

So, a query from an anonymous user would have the published posts, but
`my_posts` would be an empty set.

Another way to sort this is have multiple root fields in the base
query, but this seems frowned on.

{% include graphql_learning_project %}
