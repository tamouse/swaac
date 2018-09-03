---
layout: post
title: "Pdf Rendering With Phantomjs - Big elephants"
date: 2013-10-24 23:40
categories: [swaac]
tags: [pdf, phantomjs]
source: http://big-elephants.com/2012-12/pdf-rendering-with-phantomjs/
---
A repost of <{{page.source}}>


> Pdf Rendering With Phantomjs {.entry-title}
> ============================
> 
> Dec 17th, 2012
> 
> When it comes to generating printable documents in your Rails App a lot of people use [prawn](http://prawn.majesticseacreature.com/) to create pdfs. Although prawn is a very powerful gem for this kind of task, things can easily get complicated if you have complex styling . At [adeven](http://www.adeven.com/) we use the powerful [d3js library](http://d3js.org/) to create daily reports for our [adjust.io](http://www.adjust.io/) customers. Unfortunately, adding javascript-based content to your pdf is impossible with prawn, so we turned to [PhantomJS](http://phantomjs.org/).
> 
> Generate pdf from html with PhantomJS
> -------------------------------------
> 
> PhantomJS is a headless WebKit with JavaScript API. It's well known for headless website testing in CI environments - check out [Poltergeist](https://github.com/jonleighton/poltergeist/) to learn more about Testing JavaScript with PhantomJS. However, PhantomJS can also be used for screen-capturing as well as generating pdf documents.
> 
> Shrimp
> ------
> 
> Our [shrimp gem](https://github.com/adeven/shrimp) is a simple wrapper around PhantomJS's pdf-rendering capabilities. You can download and install PhantomJS from [http://phantomjs.org/download.html](http://phantomjs.org/download.html) or simply do a
> 
>     brew install phantomjs
> 
> if you are on MacOS using homebrew.
> 
> To install shrimp just type
> 
>     gem install shrimp
> 
>     require 'shrimp'
>     url = 'http://www.adjust.io/'
>     options = { :margin => "1cm"}
>     Shrimp::Phantom.new(url, options).to_pdf("~/output.pdf")
> 
> Et voila! A rendered pdf of your website.
> 
> Shrimp comes with plenty of options that you can pass to the Phantom Object. However, you can also configure shrimp to your needs with a config file:
> 
>     Shrimp.configure do |config|
>       # The path to the phantomjs executable
>       # defaults to `where phantomjs`
>       config.phantomjs = '/usr/local/bin/phantomjs'
> 
>       # the default pdf output format
>       # e.g. "5in*7.5in", "10cm*20cm", "A4", "Letter"
>       config.format           = 'A4'
> 
>       # the default margin
>       config.margin           = '1cm'
> 
>       # the zoom factor
>       config.zoom             = 1
> 
>       # the page orientation 'portrait' or 'landscape'
>       config.orientation      = 'portrait'
> 
>       # a temporary dir used to store tempfiles like cookies
>       config.tmpdir           = Dir.tmpdir
> 
>       # the default rendering time in ms
>       # increase if you need to render very complex pages
>       config.rendering_time   = 1000
> 
>       # the timeout for the phantomjs rendering process in ms
>       # this needs always to be higher than rendering_time
>       config.rendering_timeout       = 90000
>     end
> 
> Most of the options are self explanatory. Note that if you have very complex pages with a lot of javascript that needs to be executed after document ready, you might want to increase the rendering\_time. For example with our d3js graphs we need 3 seconds to get good results.
> 
> Keep in mind, that the rendering\_timeout should be higher than the rendering\_time.
> 
> The Phantom Class come with three different rendering options:
> 
>     require 'shrimp'
>     phantom = Shrimp::Phantom.new('http://www.adjust.io/')
>     # returning a pdf file path
>     phantom.to_pdf("~/output.pdf")
>     => "/Users/rapimo/output.pdf"
>     # returning a File handle
>     phantom.to_file("~/output.pdf")
>     => #<File:/Users/rapimo/output.pdf>
>     # returning the file content as String
>     phantom.to_string
>     => "%PDF-1.4....
> 
> Shit's being weird
> ------------------
> 
> If some error occurs you will still get a result - an empty file. This is necessary to let some asynchronous rendering like Shrimp::Middleware know about it. However you still can check the error response.
> 
>     require 'shrimp'
>     phantom = Shrimp::Phantom.new('http://www.adjust.io/foo/bar')
>     phantom.to_pdf("~/output.pdf")
>     phantom.error
>     => "302 Unable to load the address!\n"
> 
> To make sure the resulting pdf has the expected content, phantom does not follow redirects or render weird 500 status pages. So everything other than a 200 response results in an empty output file.
> 
> If you prefer bang methods each of the rendering options comes with a bang!
> 
>     require 'shrimp'
>     Shrimp::Phantom.new('http://www.adjust.io/foo/bar').to_pdf!("~/output.pdf")
>     => Shrimp::RenderingError: Rendering Error: 404 Unable to load the address!
> 
> Shrimp::Middleware
> ------------------
> 
> The shrimp gem comes with a rack-aware Middleware that allows users to get a pdf view of any page on your site by appending .pdf to the URL.
> 
> **Non-Rails Rack apps**
> 
>     # in config.ru
>     require 'shrimp'
>     use Shrimp::Middleware
> 
> **Rails apps**
> 
>     # in application.rb(Rails3) or environment.rb(Rails2)
>     require 'shrimp'
>     config.middleware.use Shrimp::Middleware
> 
> **With Shrimp options**
> 
>     # options will be passed to Shrimp::Phantom.new
>     config.middleware.use Shrimp::Middleware, :margin => '0.5cm', :format => 'Letter'
> 
> **With conditions to limit routes that can be generated in pdf**
> 
>     # conditions can be regexps (either one or an array)
>     config.middleware.use Shrimp::Middleware, {}, :only => %r[^/public]
>     config.middleware.use Shrimp::Middleware, {}, :only => [%r[^/invoice], %r[^/public]]
> 
>     # conditions can be strings (either one or an array)
>     config.middleware.use Shrimp::Middleware, {}, :only => '/public'
>     config.middleware.use Shrimp::Middleware, {}, :only => ['/invoice', '/public']
> 
>     # conditions can be regexps (either one or an array)
>     config.middleware.use Shrimp::Middleware, {}, :except => [%r[^/prawn], %r[^/secret]]
> 
>     # conditions can be strings (either one or an array)
>     config.middleware.use Shrimp::Middleware, {}, :except => ['/secret']
> 
> ### Polling
> 
> To avoid deadlocks, Shrimp::Middleware renders the pdf in a separate process retuning a 503 Retry-After response Header. you can setup the polling interval and the polling offset in seconds.
> 
>     config.middleware.use Shrimp::Middleware, :polling_interval => 1, :polling_offset => 5
> 
> ### Caching
> 
> To avoid rendering the page on each request you can setup some the cache ttl in seconds
> 
>     config.middleware.use Shrimp::Middleware, :cache_ttl => 3600, :out_path => "/my/pdf/store" 
> 
> ### Cookies
> 
> If you use `Rack::Session::Cookie` in your RackApp the user cookie is passed to PhantomJS. Thus you don't need to worry about Login Credentials or other session based content.
> 
> However, as we also send pdf reports to our customers we want to render resources without being logged in. Since we use devise for user handling in our Rails App, things get easy with our own devise SignInInterceptor:
> 
>     # lib/devise/sign_in_interceptor.rb
>     module Devise
>       class SignInInterceptor
>         def initialize(app, opts)
>           @app    = app
>           @scope  =opts[:scope]
>           @secret = opts[:secret]
>           @klass  = opts[:klass]
>         end
> 
>         def call(env)
>           if user = Rack::Request.new(env).cookies[@secret]
>             env['warden'].session_serializer.store(@klass.constantize.find(user), @scope)
>           end
> 
>           @app.call(env)
>         end
>       end
>     end
> 
>     # application.rb
>     require File.expand_path('../../lib/devise/sign_in_interceptor', __FILE__)
>     config.middleware.use Devise::SignInInterceptor, { :scope  => :user, :klass => 'User',
>                                                         :secret => "our_very_very_long_secret" }
> 
> With this setup we can add a `to_pdf` method to our resource
> 
>     # report.rb
>     def to_pdf
>       host        = Rails.env.production? ? 'www.adjust.io' : 'localhost:3000'
>       url         = Rails.application.routes.url_helpers.reports_url(self, :host => host)
>       cookie      = { 'our_very_very_long_secret' => user_id }
>       options     = { :margin => "1cm"}
>       res         = Shrimp::Phantom.new(url, opt, ck).to_pdf("#{Rails.root}/reports/report_#{self.id}.pdf")
>     end
> 
> ### Fancy Ajax
> 
> The middleware return three different status codes based on the rendering status.
> 
>     503 Retry-After                     # as long as the rendering is still in progress
>     504                                 # if rendering took longer than request_timeout
>     200 Content-Type application/pdf    # delivering the pdf file if rendering is finished 
> 
>     if request was HTTP_X_REQUESTED_WITH (Ajax)
> 
>     200 Content-Type text/html          # delivering html with the link to the pdf file 
> 
> To include some fancy Ajax stuff with jquery you can do
> 
>      var url = '/my_page.pdf'
>      var statusCodes = {
>           200: function() {
>             console.log("going to the resulting pdf");
>             return window.location.assign(url);
>           },
>           504: function() {
>            console.log("Shit's being weird");
>           },
>           503: function(jqXHR, textStatus, errorThrown) {
>             var wait;
>             wait = parseInt(jqXHR.getResponseHeader('Retry-After'));
>             console.log("wait some time");
>             return setTimeout(function() {
>               return $.ajax({
>                 url: url,
>                 statusCode: statusCodes
>               });
>             }, wait * 1000);
>           }
>       }
> 
>       $.ajax({
>         url: url,
>         statusCode: statusCodes
>       })
> 
> ### CSS Styling
> 
> The good thing about PhantomJS is that you only need to take care of webkit's css implementation. To implement manual page breaks you can do:
> 
>     .newpage {
>       width: 21cm;
>       height: 29.3cm;
>       overflow: hidden;
>       border-top: none;
>       position: relative;
>       page-break-before: always;
>     }
> 
>     .non-breaking-box {
>       page-break-inside: avoid;
>     }
> 
> TL;DR
> -----
> 
> You don't always have to fight the fat prawn when a lightweight shrimp can do.
> 
> Posted by Manuel Kniep Dec 17th, 2012 [phantomjs](/blog/categories/phantomjs/), [rails](/blog/categories/rails/), [ruby](/blog/categories/ruby/)
> 
> [Tweet](http://twitter.com/share)
> 
> [« Testing Results from Apptrace's Sentiment Analyzers](/2012-12/testing-sentiment-analyzers/ "Previous Post: Testing Results from Apptrace's Sentiment Analyzers") [Tuning Postgres on MacOS »](/2012-12/tuning-postgres-on-macos/ "Next Post: Tuning Postgres on MacOS")
> 
> Comments
> ========
> 
> Please enable JavaScript to view the [comments powered by Disqus.](http://disqus.com/?ref_noscript)
> 
> Recent Posts
> ============
> 
> -   [Tuning Redismq - how to use Redis in Go](/2013-10/tuning-redismq-how-to-use-redis-in-go/)
> -   [Rport - Business Intelligence Apps with R](/2013-10/rport-business-intelligence-apps-with-r/)
> -   [Exploring Query Locks in Postgres](/2013-09/exploring-query-locks-in-postgres/)
> -   [Goem - The Missing Go Extension Manager](/2013-09/goem-the-missing-go-extension-manager/)
> -   [Building a Message Queue using Redis in Go](/2013-09/building-a-message-queue-using-redis-in-go/)
> 
> GitHub Repos
> ============
> 
> -   Status updating...
> 
> [@adeven](https://github.com/adeven) on GitHub
> 
> Latest Tweets
> =============
> 
> -   Status updating...
> 
> [Follow @adevencom](http://twitter.com/adevencom)
