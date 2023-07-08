---
title: "Quick start for doing take home tests in Ruby and Rails"
date: 2023-04-10T15:20
tags: [ruby,rails,interviews,take-home-tests,tips]
---

Having gone through a number of interviews this year and last, I have had to more than my share of take home tests for propective employers.

The take home test is typically couched as few requirements intended to show how you approach and solve a given problem. While it's not a truly valid representation of how you'll perform on the job, it's certainly a lot more accurate that timed over-the-shoulder programming, which seems to have replaced the dreaded white boarding coding exercises of the past. At least you get to use your own tools to build the response.

Ruby comes with the `bundler` gem, giving us the `bundle` command, with it set of subcommands which is a pretty common pattern in Ruby for command line tools. You're likely familiar with `bundle install` already,

Rails comes with an application generator, set off by the `rails new ...args`, showing the subcommand pattern already. The `rails new` command has a lot of options and it's not helpful to spend a lot of time reading up on them if you're only going to be building some backend features.

## A basic ruby setup ##

Running the command `bundle help gem` shows the options for building a skeleton gem, just like the ones we all bundle and use in our work. Here's a great start:

``` shell
bundle gem take_home_test -b -t minitest --ci=github --linter=rubocop 
```

The above creates a new directory called "take_home_test" and populates it with files and directories appropriate for building out an CLI app, Going through the options:

- `-b` - created and `exe/` directory and a stub file `exe/take_home_test`. This is the executable for the command line app.
- `t minitest` - sets up the gem to use minitest. You could also use `rspec` instead of minitest if you want.
- `--ci=github` - this is not required, but if you are using github to keep your take home test gem, might as well have it run the tests for you on push, too.
- `--linter=rubocop` - [Rubocop](https://rubocop.org/ "The Ruby Linter/Formatter that Serves and Protects") is the more popular and agreed upon linter for Ruby. I prefer having it around, but it is optional

The output from the command looks like so (there may be some changes are time goes on):

``` text
Creating gem 'take_home_test'...
Changelog enabled in config
rubocop is already configured, ignoring --linter flag.
RuboCop enabled in config
Initializing git repo in /Users/tamouse/tmp/take_home_test
      create  take_home_test/Gemfile
      create  take_home_test/lib/take_home_test.rb
      create  take_home_test/lib/take_home_test/version.rb
      create  take_home_test/sig/take_home_test.rbs
      create  take_home_test/take_home_test.gemspec
      create  take_home_test/Rakefile
      create  take_home_test/README.md
      create  take_home_test/bin/console
      create  take_home_test/bin/setup
      create  take_home_test/.gitignore
      create  take_home_test/test/test_helper.rb
      create  take_home_test/test/test_take_home_test.rb
      create  take_home_test/.github/workflows/main.yml
      create  take_home_test/CHANGELOG.md
      create  take_home_test/.rubocop.yml
      create  take_home_test/exe/take_home_test
```

If this is your first time running `bundle gem`, take some time to peruse the files to get familiar with them.

Before you can run `bundle install` to install the gems, you'll need to edit the `take_home_test.gemspec` file. You'll notice a number of "TODO"s. These need to be fixed before the `bundle install` command will work.

``` ruby
# frozen_string_literal: true

require_relative "lib/take_home_test/version"

Gem::Specification.new do |spec|
  spec.name = "take_home_test"
  spec.version = TakeHomeTest::VERSION
  spec.authors = ["Tamara Temple"]
  spec.email = ["tamouse@gmail.com"]

  spec.summary = "take home test example"
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/tamouse/take_home_test"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

```
