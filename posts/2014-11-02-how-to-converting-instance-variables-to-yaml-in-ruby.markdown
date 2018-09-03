---
layout: post
title: "How to: Converting Instance Variables to YAML in Ruby"
date: 2014-11-02 23:51
categories: [swaac]
tags: [ruby, instance-variables, howtos]
source: https://github.com/tamouse/example_converting_instance_variables_to_yaml_in_ruby
---
(Reposting from my old [wiki][tamwiki]):
On a recent post in ruby-talk, the question was asked how to convert something to `YAML`. Extending this generally to ruby objects, I went searching for something that would work besides a brute-force creation of a Hash.

## Introduction

The original request was to be able to generate the following YAML from a result:

`desired_output.yaml`:

``` yaml
---
- name: device-1
  parameters:
    app_folder: deploy_project
    app_id: "1"
    tar_file: deploy_project.tar.gz
    profile_id: "3"
    version_id: "2"
  classes:
  - install
```

If one were to take that and feed it back into Ruby via YAML.load, one gets the following structure:

``` ruby
[{"name"=>"device-1",
  "parameters"=>
   {"app_folder"=>"deploy_project",
    "app_id"=>"1",
    "tar_file"=>"deploy_project.tar.gz",
    "profile_id"=>"3",
    "version_id"=>"2"},
  "classes"=>["install"]}]

```

So an obvious structure is revealed. However, simply brute-forcing this from a result seemed not quite what I would want, so I went searching.

## What happens if you YAML-ize an Object directly?

Let's say we build a couple of classes that can be used with the above information (ignoring that it may have come from a database for the non).

`classes.rb`:

``` ruby
# Classes to convert to yaml

class Deploy
  attr_accessor :name, :parameters, :classes

  def initialize(name, parameters, classes)
    self.name = name
    self.parameters = parameters
    self.classes = classes
  end
end

class Params
  attr_accessor :app_folder, :app_id, :tar_file, :profile_id, :version_id

  def initialize(app_folder, app_id, tar_file, profile_id, version_id)
    self.app_folder = app_folder
    self.app_id = app_id
    self.tar_file = tar_file
    self.profile_id = profile_id
    self.version_id = version_id
  end

end

```


If we load up an array with the above classes using the data from the original request, we can see this:

``` 
$ pry -r yaml -r ./classes.rb
[1] pry(main)> deployments = Array.new
=> []
[2] pry(main)> deployments << Deploy.new("device-1",
[2] pry(main)*   Params.new("deploy_project", "1",
[2] pry(main)*   "deploy_project.tar.gz", "3", "2"),
[2] pry(main)* ["install"])
=> [#<Deploy:0x007fa0cf7a3ec0
  @classes=["install"],
  @name="device-1",
  @parameters=
   #<Params:0x007fa0cf7a3f38
    @app_folder="deploy_project",
    @app_id="1",
    @profile_id="3",
    @tar_file="deploy_project.tar.gz",
    @version_id="2">>]
[3] pry(main)> deployments.to_yaml
=> "---\n- !ruby/object:Deploy\n  name: device-1\n  parameters: !ruby/object:Params\n    app_folder: deploy_project\n    app_id: '1'\n    tar_file: deploy_project.tar.gz\n    profile_id: '3'\n    version_id: '2'\n  classes:\n  - install\n"
[4] pry(main)> puts deployments.to_yaml
---
- !ruby/object:Deploy
  name: device-1
  parameters: !ruby/object:Params
    app_folder: deploy_project
    app_id: '1'
    tar_file: deploy_project.tar.gz
    profile_id: '3'
    version_id: '2'
  classes:
  - install
=> nil
[5] pry(main)> 
```

While close, simply YAMLizing an Object doesn't give us what we want -- when loaded, it will look for the classes Deploy and Params to create objects from. We don't want this, exactly, we just want it in the form originally requested. When reread by an application that does not define
these classes, we get an error:

```
$ pry -r yaml
[1] pry(main)> YAML.load_file("direct_to_yaml_output.yaml")
ArgumentError: undefined class/module Deploy
from /opt/rubies/ruby-2.1.2/lib/ruby/2.1.0/psych/class_loader.rb:53:in `path2class'
[2] pry(main)> 
```

## How to just get the instance variables into a Hash?

In [this question][so_question] on stackoverflow, one of the respondents points to the [`instance_variables`][instance_variables_method] method on `Object` in ruby. This is pretty simple, and could be more helpful in a non-Rails environment. I decided to write a recursive version that can be mixed into a class:

`instance_valude_extension.rb`:

``` ruby
module InstanceValuesExtension

  module InstanceMethods
    def instance_values
      Hash[
        instance_variables.map do |name|
          key = name.to_s[1..-1]
          value = instance_variable_get(name)
          if (value.instance_variables.count > 1 && value.respond_to?(:instance_values))
            value = value.instance_values
          end
          [key, value]
        end
      ]
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

end

```

Using that same data above, we can get;

`example.rb`:

``` ruby
$:.unshift(File.expand_path("../", __FILE__))

require 'yaml'
require 'classes.rb'
require 'instance_values_extension'

Deploy.send(:include, InstanceValuesExtension)
Params.send(:include, InstanceValuesExtension)

deployments = [
  Deploy.new(
    "device-1",
    Params.new(
      "deploy_project",
      "1",
      "deploy_project.tar.gz",
      "3",
      "2"
    ),
    ["install"]
  )
]

puts deployments.map(&:instance_values).to_yaml
```

and Voila!

`actual_output.yaml`:

``` yaml
---
- name: device-1
  parameters:
    app_folder: deploy_project
    app_id: '1'
    tar_file: deploy_project.tar.gz
    profile_id: '3'
    version_id: '2'
  classes:
  - install
```

This won't do *everything* in-and-of-itself. For instance, if any of the instance variables consists of an Array or Hash (or even a Struct), it won't recurse into them. Refinement will be needed.

Still, an interesting exercise!

Note, also, this is *no* substitute for using `ActiveModel::Serializers` in Rails.

[so_question]: http://stackoverflow.com/questions/7638982/better-way-to-convert-several-instance-variables-into-hash-with-ruby 
[instance_variables_method]: http://www.rubydoc.info/stdlib/core/Object:instance_variables
[tamwiki]: http://wiki.tamouse.org/n=Technology.ConvertingInstanceVariablesToAHashInRuby 

(Source in [github]({{ pages.source }}).)


