---
layout: post
title: "Notes on using ActionMailer in Rails"
date: 2017-05-06 03:54
categories: ["rails"]
tags: ["rails", "ruby", "actionmailer"]

---

(This article was originally posted on Sat Aug 24 10:39:09 2013 in
wiki.tamaratemple.com. It deserves a new home.)

[ActionMailer](http://guides.rubyonrails.org/action_mailer_basics.html) allows
a Rails application to send and receive emails in a fashion similar to
a Rails controller. You can have multi-part bodies, templates,
attachments, and so on. It isn't quite a complete ecosystem, as you
need to have a transport for sending and recieving mail, and you need
to have a way of accurately testing your emails, so I'm going to write
some notes to complete that view.

## First, read the documentation

[The Rails Guides](http://guides.rubyonrails.org/) provide the
basics for getting up and running using ActionMailer.

In addition,
the
[api docs](http://api.rubyonrails.org/classes/ActionMailer/Base.html)
provides more details on the usage of the methods in ActionMailer.

## Testing Considerations

Since we are all good TDD/BDD-ers (we are, right?), I'm going to start
with how you can set up your Rails environment for testing your
mailers.

The Rails Guides provide a section
on
[testing your mailers](http://guides.rubyonrails.org/testing.html#testing-your-mailers),
which you should go off and read right now.

### Delivery Mode `:test`

The simplest setup for this, especially useful for unit and functional
testing, is to set the delivery mode for action mailer to `:test` in
the `test` environment.

**File:** `config/environments/test.rb`:
{% highlight ruby %}
  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
{% endhighlight %}

In a new Rails app, this is the default setting, so you don't really
need to do anything in particular.

### MailCatcher For Round-Trip Testing

While it is often the case that you should not bother to test the
underlying delivery mechanisms, sometimes you really want to see what
your email is going to look like in the eyes of the
receiver. [MailCatcher](http://mailcatcher.me/) to the
rescue. MailCatcher is a nice utility that emulates an SMTP
connection and provides a webmail view of the mails it catches. To use
MailCatcher, after you've installed it according to the instructions,
is to set up your environments files appropriately. In this case, I'm
going to set it in the `development` environment.

**File:** `config/environments/development.rb`:
{% highlight ruby %}
  config.action_mailer.deliver_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'localhost',
    :port => 1025
  }
{% endhighlight %}

When you cause mails to be sent with your mailer, the mails can be
seen by pointing your browser at <http://localhost:1080> and it
works like your typical web mail reader. (You can't reply or forward,
obviously.)

## Intercepting Emails on Staging

When getting ready to deploy a project update, generally a good
practice is to deploy to a staging server that mirrors your production
environment as closely as possible to see if there will be any errors
during final deploy. One of the things frequently done in this is a
run with a copy (or near copy) of production data.

However, you probably don't want mail going out indiscrimantly from
your staging environment to your users, so the thing you want to do
here is intercept the emails. You can set up mailcatcher like above,
but there are alternatives, such as catching all mail and switch the
outbound addresses to something more benign.

[Someone thought this through already](http://guides.rubyonrails.org/action_mailer_basics.html#intercepting-emails)
The example works perfectly for what I need to be able to do full
systems testing on staging without worrying about sending bogus
emails to users!
