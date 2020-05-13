Getting keywords from a web page via Nokogiri
=============================================

**WARNING: This is old and likely obsolete.**

-   published date: 2013-08-29 20:15
-   keywords: \[\"nokogiri\", \"ruby\", \"scraping\", \"swaac\"\]
-   source:

A snippet.

<!--more-->

In order to scrape the keywords from a web page using Nokigiri (to, for example, add to categories of a Jekyll page) is straight-forward, it turns out.

Script
------

``` {.ruby}
require 'open-uri'
require 'nokogiri'

url="http://wiki.tamaratemple.com/"
content=Nokogiri::HTML(open(url))
keywords=content.search('//meta[@name="keywords"]').attr('content').value
puts keywords
```

Output
------

``` {.example}
$ ruby keywords-from-url.rb 
Tamara Temple, Wiki, TamWiki
```
