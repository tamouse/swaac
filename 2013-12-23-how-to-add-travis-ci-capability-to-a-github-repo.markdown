---
# BEGIN: redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
redirect_from:
  - /blog/2013/12/23/how-to-add-travis-ci-capability-to-a-github-repo/
# END:   redirect added by jekyllpress on 2014-09-29 00:34:42 -0500
layout: post
title: "How To: Add Travis CI Capability to a Github Repo"
date: 2013-12-23 16:39
categories: swaac
tags: [programming, testing, continuous-integration]
---
A&amp;D has a private [Travis-CI][travisci] [server][adtravis] that is
used to verify changes to our private repos. Initially, this repo did
not use travis, since it didn't really have any automated tests to
run.

As [I (Tamara)][tamouse] started adding RSpec tests, my colleague
[Jason][dabootski] recommended including the repo in the travis CI
environment as well. This wasn't quite as straight-forward as
initially thought, so this attempts to document the pieces in pulling
this together.


<!--more-->


## Configuring `.travis.yml`

The first part of getting a repository ready to run under Travis is to
create a `.travis.yml` file to tell Travis how to build and test your
repository.

The Travis documentation is fairly easy to understand, but no set of
documentation is going to understand your specific repository's
needs. There aren't enough examples for every possibly scenario, thus
you need to really understand the environment needs of your
application.

There are various elements that you need to set up:

1. The language and language version
2. Environment variables
3. Other applications, libraries, servers, and so on that your
   application needs in order to run (e.g. Postgresql)
4. Travis behavioural elements, such as caching, building, and so on

`.travis.yml` is (obviously) a YAML file, which is the standard for
ruby applications.

### Setting the language

Since we're testing a Rails application here, ruby is our
language. The version we're using is 2.0.0 (with no particular build
set at this point). The two sections we need in the `.travis.yml` file
are:

```yaml
language: ruby
rvm:
  - 2.0.0
```

You can set multiple values in the `rvm` section, to tell travis to
run a build on each version. This can explode into a large build
matrix, though, so be circumspect. This repo contains a
`.ruby-version` file so it was easy to limit the versions to build
with.

This would be the minimum required to get any Rails app running, but
ours has a few more requirements.

### Environment Variables

*$repo* has some values it needs to pick up from the
environment to run correctly. With the current set of tests, the
Devise configuration parameter `secret_key_base` must be set. The
`env_vars-sample.rb` file is used as a template for the `env_vars.rb`
file that is used to set defaults if the values aren't set explicitly
in the environment.

For the current set of tests, the only env_var needed is
`SECRET_KEY_BASE` to make the Devise gem happy. Environment variables
are set in the `env` section of the `.travis.yml` file:

```yaml
env:
  SECRET_KEY_BASE="$(bundle exec rake secret)"
```

There is some secret sauce going on here. The `rake secret` task is
one provided by the standard Rails installation that will re-generate
a secret token, which is just a hashed string, and is quite suitable
for the secret key base. The above setting results in travis running
the following at the start of the build:

```bash
export SECRET_KEY_BASE="$(bundle exec rake secret)"
```

which gives us exactly what we need for the run.

Although it is a travis default, I've also set the `RAILS_ENV` envar
to `'test'` to ensure we're running in a test situation.

### Additional Software

The database used in *$repo* is Postgresql version 9.2,
because it makes use of the JSON variable type that was introduced at
that version. Travis by default uses Postgresql v. 9.1, so we need to
tell it what to use. The `addons` section lets us specify the version:

```yaml
addons:
  postgresql: 9.2
```

### Prerequisite Steps

Travis has hooks that will run before and after certain events in the
build. We need to make sure we have the right configuration files
created and the database created that will work for our repo.

The `before_script` section lets us give bash commands that will run
just before the test script starts.

#### Configuration Files

Every Rails app needs a `config/database.yml` file which must be
modified by the user when starting up the application. However, a good
rails practice is to make a sample configuration file which can be
included in the repository, but not the specific configuration file
which might contain passwords or other credentials that you don't want
to put out in public or even semi-public.

In addition, *$repo* has an environment variable
initialization file, that has similar credential secrets that we don't
want explicitly in the repository, so there is a
`config/env_vars.sample.rb` file that is copied and modified if
necessary.

Since the sample defaults will work for our needs in the Travis CI
environment, we can just copy them over directly. If the specific
values in the non-sample files need to be set, you could run the
sample file through sed, awk, perl, ruby or whatever to make the
appropriate edits.

We want to make sure we're putting our work in the proper
directory. Travis provides a few environment variables to us, one of
which is the `TRAVIS_BUILD_DIR` envar, that points to the directory of
the current build.

(Note these might be done quite differently when creating the
production environment.)

```yaml
before_script:
  - /bin/cp $TRAVIS_BUILD_DIR/config/database.sample.yml $TRAVIS_BUILD_DIR/config/database.yml
  - /bin/cp $TRAVIS_BUILD_DIR/config/env_vars.sample.rb $TRAVIS_BUILD_DIR/config/env_vars.rb
```

#### Creating The Testing Database

For each travis run, we must create the testing database anew (travis
does not persist databases across runs). Since we're using Postgresql,
we simply run the client and create the database with the default
user, `postgres` as specified by travis.

```yaml
before_script:
  - psql -c 'create database howto_repo_test;' -U postgres
```

#### The `before_script` Section

Combining the previous two subsections, the resultant `before_script`
section that runs all these is:

```yaml
before_script:
  - /bin/cp $TRAVIS_BUILD_DIR/config/database.sample.yml $TRAVIS_BUILD_DIR/config/database.yml
  - /bin/cp $TRAVIS_BUILD_DIR/config/env_vars.sample.rb $TRAVIS_BUILD_DIR/config/env_vars.rb
  - psql -c 'create database howto_repo_test;' -U postgres
```

## Travis Operations

### Bundler Caching

One thing that Travis can do for is cache our bundle operations, thus
saving considerable time each build in creating the bundle
environment. For this repo, there is a huge time savings from having
to recompile local versions of native code (Nokogiri in particular
takes a long time to build the native version).

We can tell Travis to cache the bundle within the `cache` section:

```yaml
cache: bundler
```

### Bundler Options

Normally, Travis runs bundler with just the `--deployment` option, but
I've added `guard` and `pry` to the Gemfile to enable me to run
continuous testing and debugging locally. We don't want these in the
CI run, however, so I've put all the local stuff inside a `guard`
group within the Gemfile. We need to tell Travis not to include it:

```yaml
bundler_args: --without guard --deployment
```

which tells bundler to omit the `guard` section, and install things as
if this were a deployment.


## Final `.travis.yml` Contents

Putting the whole thing together:

```yaml
language: ruby
cache: bundler
bundler_args: --without guard --deployment
rvm:
  - 2.0.0
before_script:
  - /bin/cp $TRAVIS_BUILD_DIR/config/database.sample.yml $TRAVIS_BUILD_DIR/config/database.yml
  - /bin/cp $TRAVIS_BUILD_DIR/config/env_vars.sample.rb $TRAVIS_BUILD_DIR/config/env_vars.rb
  - psql -c 'create database howto_repo_test;' -U postgres
env:
  RAILS_ENV=test
  SECRET_KEY_BASE="$(bundle exec rake secret)"
addons:
  postgresql: 9.2
```

## Triggering a Travis Run

Normally, Travis will begin a build whenever code is pushed to the
repository if the repository contains a `.travis.yml` file. The thing
you also need to do is turn on the service hooks for the repository to
interact with TravisCI. To do this, you need to be able to change the
settings of the repo on Github. Since I didn't have such permissions,
Jason did this, but then it wasn't clear why builds were not starting.

The *other* issue with this is that if you've already created a pull
request for a given branch, adding to that branch does *not* seem to
trigger Travis builds. Once that PR was merged, then Travis builds
began as expected.

At present, Travis will happily build anytime there is a push to *any*
branch on Github, including new feature, bugfix, and chore
branches. This includes any new or existing branches, so we don't have
the first-time issue any more.

## Acknowledgements

My thanks in particular to [Jason Bucki][dabootski] for his help on
pushing me to do this and getting this up and running. Also thanks to
[Kyle Kestell][kkestell] for his help on understanding the application
and getting me up to speed.


[adtravis]: https://magnum.travis-ci.com/ "Private A&amp;D Travis-CI server"
[travisci]: http://travis-ci.com "Travis Continuous Integeration and Testing"
[tamouse]: https://github.com/tamouse "Tamara Temple @ Github"
[dabootski]: https://github.com/dabootski "Jason Bucki"
[kkestell]: https://github.com/kkestell "Kyle Kestell"
