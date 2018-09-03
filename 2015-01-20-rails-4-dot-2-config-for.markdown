---
layout: post
title: "Rails 4.2 config_for"
date: 2015-01-20 07:30
categories: ["swaac"]
tags: ["rails", "configuration"]
---
There have been a lot of blog posts and articles written on how to add
application-specific configurations to a Rails app. In version 4.2,
there is a method called `config_for` which makes a lot of that
obsolete, simplifying the results.

## A common Rails idiom

A seemingly very common idiom is to arrange appliation configuration
values in YAML+ERB files under the `config` directory in a Rails
app. Then, in an initializer, read in the file, process it through
ERB, then YAML extract the set appropriate to the running environment,
and save it in a constant or global:

### `config/app_config.yml`

``` yaml
default: &default
  service_url: https://my_service.example.com

development:
  <<: *default

test:
  <<: *default

production:
  service_url: <%= ENV['APP_SERVICE_URL'] %>
```

### `config/initializers/app_config.rb`

``` ruby
require 'yaml'
require 'erb'

APP_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config','app_config.yml'))).result)[Rails.env] || {}
```

## Enter `config_for` at Rails 4.2

[`config_for`](http://api.rubyonrails.org/classes/Rails/Application.html#method-i-config_for)
is a method on `Rails.application`. It can be called bar within all
the normal configuration contexts, such as inside
`config/environments/development.rb` and such.

What it does is fairly straightforward, reading a YAML+ERB file from
the `config` directory, returning the appropriate section based on the
current Rails environment.

It's a simple enough implementation:
<https://github.com/rails/rails/blob/1d1239d32856b32b19c04edd17d0dd0d47611586/railties/lib/rails/application.rb#L226>
(Note of course this is a volatile link). It's implemented in
Rails::Application#config_for.

You pass in a symbol that corresponds to a file name under `config`,
so `config_for(:app_config)` loads up the appropriate environment
variables from `config/app_config.yml`.

Now, your initializer can become simply:

### `config/initializers/app_config.rb`

``` ruby
APP_CONFIG = Rails.application.config_for(:app_config)
```

## Example

I've an example github repo at
<https://github.com/tamouse/test_config_for>. Feel free to fork it and
play with it yourself.
