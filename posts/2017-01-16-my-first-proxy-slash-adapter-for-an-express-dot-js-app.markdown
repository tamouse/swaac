---
layout: post
title: "My First Proxy/Adapter for an Express.js app"
date: 2017-01-16 01:32
categories: ["node.js"]
tags: ["node.js", "express.js", "javascript", "using-apis-from-javascript"]

---

Recently, I attended [HackTheGap 2017](https://hackthegap.com), which
is an all-women hack-a-thon in the Twin Cities. (Huge fun!) Our team
built a web app using Node.js, Express.js, and MongoDB, mixing in a
little Python nltk for good
measure:
[BrainDump/ShrinkBot](https://github.com/BrainDumpShrinkBot/brain_dump_shrink_bot).
This is the first serious Express app I've done from scratch, although
not too strenuous.

One of the things we wanted was to be able to pull
some content from other sites based on some keywords ("tags") that
were extracted from a diary / journal entry using nltk.

One of those sources is [Giphy](https://giphy.com) with has an API in
Beta. The [Giphy API](https://github.com/Giphy/GiphyAPI) (github) is a
free for all way of accessing the fun animated GIFs stored on that
site.

## Which HTTP package?

I tried a few different HTTP packages,
including [superagent], [request], and finally settling on
[node-fetch]. I went with this latter because it is most familiar to
me from working in client-side JavaScript.

[superagent]: https://www.npmjs.com/package/superagent
[request]: https://www.npmjs.com/package/request
[node-fetch]: https://www.npmjs.com/package/node-fetch

## The Giphy API

The api is really very simple:

The search URL is `http://api.giphy.com/v1/gifs/search`

Parameters are:

- `api_key` - public beta api_key is 'dc6zaTOxFJmzC' (everyone gets
  the same one)
- `q` - search terms or phrase
- `limit` - number of hits to return
- `offset` - skip this many hits before returning `limit`
- `rating` - "y", "g", "pg", "pg-13", "r"
- `lang` - 2-letter language code, e.g. 'en'
- `fmt` - 'json' or 'html'

Only `api_key` and `q` are required.

It returns by default a JSON structure with a whole pile of info. See
the repo's README for actual information.

The proxy/adapter I wrote was really quite simple. I created a module
with an IIFE that configured adapter and returned a method to call the
API.

I wanted to be able to pass in configuration values for the various
pieces of the API. For this first pass, I kept things a bit locked
down.

The consumer provides an array of tag strings to search for, and a
callback to process the return from the API.

{% highlight javascript linenos %}
/**
 * Getting a gif from Giphy: https://github.com/giphy/Giphyapi#search-endpoint
 */

const config = require('./../config');
const fetch = require('node-fetch');

module.exports = (function (config) {

  function fetch_giphy(tags, cb) {
    var url = config.services.giphy.url;
    url += '?api_key=' + config.services.giphy.api_key;
    url += '&q=' + encodeURI(tags.join(' '));
    url += '&limit=1';
    url += '&rating=g';
    fetch(url)
      .then(function (res) {
          return res.json();
        },
        function (err) {
          console.error("ERROR!!!" + err);
        })
      .then(function (data) {
        return cb(data);
      });
  }

  return {
    fetch_giphy: fetch_giphy
  }

})(config);
{% endhighlight %}

I wrote a mocha test for this as well, although I could probably do a
lot more in terms of verification:


{% highlight javascript linenos %}
const expect = require('expect.js');

const config = require('./../../config');
const get_giphy = require('./../../services/get_giphy');

describe('get_giphy tests', function () {

  it('returns a json data block', function (done) {
    get_giphy.fetch_giphy(['funny', 'cat'], function (data) {
      console.log("data: ",JSON.stringify(data, null, 2));
      expect(data).to.be.ok();
      done();
    });
  });
});

{% endhighlight %}

## TIL: calling `done` to fire async mocha tests

This particular thing was driving me nuts: I was running the test over
and over and could not figure out why it was just running to
completion instead of performing the call.

Mocha has an added bit where it passes in a callback to tell it when
the asynchronous tests finish. This had completely eluded me, but one
of the HackTheGap mentors told me about it, and everything started to
work.


## Follow-on thoughts

Although I'm specifying the API settings in a configuration object
that gets passed in, I'm not really allowing that to be injected. It
would be more helpful, maybe to export just the outer function itself,
and let the consumer pass in the configuration, thus allowing
injection per environment / use.

I might also roll back to using `superagent` as I like it's way of
dealing with building query strings rather nice (just passing in an
Object) vs. presently with `fetch` where I'm basically hard-coding
strings.
