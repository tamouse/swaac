---
layout: post
title: "json - How to send raw post data in a Rails functional test? - Stack Overflow"
date: 2013-09-17 14:09
comments: true
categories: [swaac]
tags: [testing, rails, json]
source: http://stackoverflow.com/questions/2103977/how-to-send-raw-post-data-in-a-rails-functional-test
---
**Note:** I tried playing with this in
`~/Project/rubystuff/railsstuff/my_newer_app/spec/controllers/shout_controller_spec.rb`
and could not quite get it to work.


<!--more-->

> ## How to send raw post data in a Rails functional test?
> 
> I'm looking to send raw post data (e.g. unparamaterized json) to one of
> my controllers for testing: ``
> 
>     class LegacyOrderUpdateControllerTest < ActionController::TestCase
>      test "sending json" do
>        post :index, '{"foo":"bar", "bool":true}'
>      end
>     end
> 
> but this gives me a
> `NoMethodError: undefined method `symbolize_keys' for #<String:0x00000102cb6080>`
> 
> What is the correct way to send raw post data in
> ActionController::TestCase?
> 
> Here is some controller code
> 
>     def index
>         post_data = request.body.read
>         req = JSON.parse(post_data)
> 
> 7 Answers
> ---------
> 
> I ran across the same issue today and found a solution.
> 
> In your test\_helper.rb define the following method inside of
> ActiveSupport::TestCase:
> 
>       def raw_post(action, params, body)
>         @request.env['RAW_POST_DATA'] = body
>         response = post(action, params)
>         @request.env.delete('RAW_POST_DATA')
>         response
>       end
> 
> In your functional test, use it just like the `post` method but pass the
> raw post body as the third argument.
> 
>     class LegacyOrderUpdateControllerTest < ActionController::TestCase
>      test "sending json" do
>        raw_post :index, {}, {:foo => "bar", :bool => true}.to_json
>      end
>     end
> 
> I tested this on Rails 2.3.4 when reading the raw post body using
> 
>     request.raw_post
> 
> instead of
> 
>     request.body.read
> 
> If you look at the [source code](http://github.com/rails/rails/blob/2-3-stable/actionpack/lib/action_controller/request.rb#L381)
> you'll see that raw\_post just wraps request.body.read with a check for
> this RAW\_POST\_DATA in the request env hash.
> 
> This approach continues to work correctly in Rails 3.1
> 
> Huh, yeah And Rails 3.2 too. Thanks!
> 
> Make sure you're using request.raw\_post (as in this answer) instead of
> request.body when parsing the JSON in your controller, or you'll get a
> weird error about "can't convert StringIO into String".
>
> This doesn't work in rails 3.2.10+
> 
> I actually solved the same issues just adding one line before simulating
> the rspec post request. What you do is to populate the
> "RAW\_POST\_DATA". I tried to remove the attributes var on the post
> :create, but if I do so, it do not find the action.
> 
> Here my final solution.
> 
>     def do_create(attributes)
>       request.env['RAW_POST_DATA'] = attributes.to_json
>       post :create, attributes
>     end 
> 
> In the controller the code you need to read the JSON is something
> similar to this
> 
>       @property = Property.new(JSON.parse(request.body.read))
> 
> great! Just one line, and I had it work even without the `attributes`
> sent in to post.

> Looking at stack trace running a test you can acquire more control on
> request preparation: ActionDispatch::Integration::RequestHelpers.post
> =\>
> [ActionDispatch::Integration::Session.process](https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/testing/integration.rb)
> =\>
> [Rack::Test::Session.env\_for](https://github.com/brynary/rack-test/blob/master/lib/rack/test.rb)
> 
> You can pass json string as :params AND specify a content type
> "application/json". In other case content type will be set to
> "application/x-www-form-urlencoded" and your json will be parsed
> properly.
> 
> So all you need is to specify "CONTENT\_TYPE":
> 
>     post :index, '{"foo":"bar", "bool":true}', "CONTENT_TYPE" => 'application/json'
> 
> This does not work for me. I get an error like "undefined method
> \`symbolize\_keys' for \#\<String:0x00000102b4b0d8\>" 
> 
> The `post` method expects a hash of name-value pairs, so you'll need to
> do something like this:
> 
>     post :index, :data => '{"foo":"bar", "bool":true}'
> 
> Then, in your controller, get the data to be parsed like this:
> 
>     post_data = params[:data]
> 
> 
> I've tried this, it needs to be completely raw though
> {"response":"error","errors":"can't parse request: 598: unexpected token
> at 'data=
> 
> If you are using RSpec (\>= 2.12.0) and writing Request specs, the
> module that is included is `ActionDispatch::Integration::Runner`. If you
> take a look at the source code you can notice that the
> [post](https://github.com/rails/rails/blob/4147e0feaddac0e86c9b1f52eec4b1e33d7d6591/actionpack/lib/action_dispatch/testing/integration.rb#L39)
> method calls
> [process](https://github.com/rails/rails/blob/4147e0feaddac0e86c9b1f52eec4b1e33d7d6591/actionpack/lib/action_dispatch/testing/integration.rb#L254)
> which accepts a `rack_env` parameter.
> 
> All this means that you can simply do the following in your spec:
> 
>     #spec/requests/articles_spec.rb
> 
>     post '/articles', {}, {'RAW_POST_DATA' => 'something'}
> 
> And in the controller:
> 
>     #app/controllers/articles_controller.rb
> 
>     def create
>       puts request.body.read
>     end
> 
> Maybe it's the way you're formatting your JSON, it might need to be
> escaped some how? Try doing this:
> 
>     post :index, :data => {:foo => 'bar', :bool => true }.to_json
> 
> This will turn the hash into json, and hopefully that should work. If
> not... well then I'm all out of ideas =)

