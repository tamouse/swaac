---
layout: post
title: "Dealing with mixed encodings in a file"
date: 2014-11-02 15:12
categories: [swaac]
tags: [character-sets, encoding, ruby]
---
What can you do when a file contains strings with mixed character set encodings?


I recently was working on a Rails application and had to deal with a data file that contained strings with different encodings. Each line was internally consistent, however, one line might be in ISO-8859-1, while another might be in UTF-8. This is how I solved the problem in Ruby and PHP.

## The Problem

The data file was a collection of quotes that were submitted by patrons of an IRC channel. The person who implemented the quote collector decided to use the Pilcrow, "¶", as the internal line separator for multi-line quotes. This sounded like a good idea; the pilcrow being the international mark for a paragraph and all.

The problem is that pilcrow occupies different codebases on different character sets. For several people submitting quotes, from an older windows-based irc client, the character set used is ISO-8859-1. For other people, using more recent clients, UTF-8 is the standard.

The result was that the pilcrow would appear in the file in two ways:

* 0xB6 - a single byte character as per ISO-8859-1
* 0x00B6 - a two-byte character as per UTF-8

<table width="80%" cellspacing="2px" cellpadding="5px" border="1" style="border-collapse: collapse;">
  <thead>
    <tr><th width="20%">Charset</th><th>Example</th></tr>
  </thead>
  <tfoot></tfoot>
  <tbody>
    <tr><td>ISO-8859-1:</td><td>"&lt;orangejuice&gt; Clive Anderson was nervous as hell.\xB6&lt;kbeetl&gt; No, he was British.\xB6&lt;kbeetl&gt; It's subtle, but there's a difference.\n"</td></tr>
    <tr><td>UTF-8:</td><td>"&lt;MildBill&gt; What's odd?¶&lt;FreeTrav&gt; About half of the natural numbers.\n"</td></tr>
  </tbody>
</table>



## Ruby solution

Ruby by default reads files in UTF-8. The resulting array of strings in the file, thus, will have different encodings. To test what a particular string is encoded as, you need to do the following construction:

{% highlight ruby %}
s.force_encoding(encoding).valid_encoding?
{% endhighlight %}

where encoding is the name of the character set you are testing.

So we end up with this sort of thing:

{% highlight ruby %}
# get the source file
quotes.collect! do |q|
  if q.force_encoding("UTF-8").valid_encoding?
    q.gsub!(/¶/, "\n")
  else
    q = q.force_encoding("ISO-8859-1").
      gsub(/#{0xb6.chr.force_encoding("ISO-8859-1")}/, "\n")
  end
  q
end
{% endhighlight %}

