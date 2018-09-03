---
layout: post
title: "Why you should stop pirating Google's geo APIs « Pete Warden's blog"
date: 2013-09-11 22:49
categories: [swaac]
tags: [open-software, gis, google, apis, data-science-toolkit]
source: http://petewarden.com/2013/09/09/why-you-should-stop-pirating-googles-geo-apis/
---
Using Google's proprietary APIs in ways that violate Google's TOS
prevents more open and free (libre) sources from emerging and
evolving, as well as opening up your application to reprisal or
failure when the APIs change or go away.

Instead, use:

* [Data Science Toolkit](http://www.datasciencetoolkit.org/), an open VM that
wraps a lot of the geo community's greatest open-source projects in a
friendly and familiar interface.

> Why you should stop pirating Google's geo APIs
> ==============================================
> 
> [September 9, 2013](http://petewarden.com/2013/09/09/why-you-should-stop-pirating-googles-geo-apis/ "September 9, 2013")
> By [Pete Warden](http://petewarden.com/author/petewarden/ "View all posts by Pete Warden")
>
> This morning I ran across a wonderful open source project called 
> "[Crime  doesn't climb](https://github.com/gwintrob/crime-doesnt-climb/blob/master/README.md)",
> analyzing how crime rates vary with altitude in San Francisco. Then I
> reached this line, and honestly couldn't decide whether to cry or
> scream: "*Here's the code snippet that queries the Google Elevation API
> (careful–Google rate limits aggressively)*"
> 
> Google is very clear about 
> [the accepted usage of all their geo APIs](https://developers.google.com/maps/documentation/elevation/#Limits),
> here's the quote that's repeated in almost every page: "*The Elevation
> API may only be used in conjunction with displaying results on a Google
> map; using elevation data without displaying a map for which elevation
> data was requested is prohibited.*"
> 
> The crime project isn't an exception, it's common to see geocoding and
> other closed APIs being used in all sorts of unauthorized ways .
> [Even](http://ariya.ofilabs.com/2013/07/geolocation-and-interactive-maps.html)
> [tutorials](http://peteh.me/speeding-up-geocoding-on-rails-with-geocoder/)
> openly recommend going this route.
> 
> So what? Everyone ignores the terms, and Google doesn't seem to enforce
> them energetically. People have projects to build, and the APIs are
> conveniently to hand, even if they're technically breaking the terms of
> service. Here's why I care, and why I think you should too:
> 
> **Google's sucking up all the oxygen**
> 
> Because everyone's using closed-source APIs from Google, there's very
> little incentive to improve the open-source alternatives. 
> [Microsoft loved it when people in China pirated Windows](http://labnol.blogspot.com/2007/07/we-love-microsoft-software-piracy-in.html),
> because that removed a lot of potential users for free alternatives, and
> so hobbled their development, and something very similar is happening in
> the geo world. Open geocoding alternatives would be a lot further along
> if crowds of frustrated geeks were diving in to improve them, rather
> than ignoring them.
> 
> **You're giving them a throat to choke**
> 
> Do you remember when the Twitter API was a wonderful open platform to
> build your business on? Do you remember how well that worked out? If
> you're relying on Google's geo APIs as a core part of your projects you
> already have a tricky dependency to manage even if it's all kosher. If
> you're not using them according to the terms of service, you're
> completely at their mercy if it becomes successful. Sometimes the
> trade-off is going to be worth it, but you should at least be aware of
> the alternatives when you make that choice.
> 
> **A lot of doors are closed**
> 
> Google is good about rate-limiting its API usage, so you won't be able
> to run bulk data analysis. You also can only access the data in a
> handful of ways. For example, for the crime project they were forced to
> run point sampling across the city to estimate the proportion of the
> city that was at each elevation, when having full access to the data
> would have allowed them to calculate that much more directly and
> precisely. By starting with a closed API, you're drastically limiting
> the answers you'll be able to pull from the data.
> 
> **You're missing out on all the fun**
> 
> I'm not [RMS](http://stallman.org/), I love open-source for very
> pragmatic reasons. One of the biggest is that I hate hitting black boxes
> when I'm debugging! When I was first using Yahoo's old Placemaker API, I
> was driven crazy by its habit of marking an references to "The New York
> Times” as being in New York. I ended up having to patch around this
> habit for all sorts of nouns, doing a massive amount of work when I knew
> that it would be far simpler to tweak the original algorithm for my use
> case. When I run across bugs or features I'd like to add to open-source
> software, I can dive in, make the changes, and anyone else who has the
> same problem also benefits. It's not only more efficient, it's a lot
> more satisfying too.
> 
> **So, what can you do?**
> 
> There's a reason Google's geo APIs are dominant – they're
> well-documented, have broad coverage, and are easy to access. There's
> nothing in the open world that matches them overall. There are good
> solutions out there though, so all I'd ask is that you look into what's
> available before you default to closed data.
> 
> I've put my money where my mouth is, by pulling together the
> [Data Science Toolkit](http://www.datasciencetoolkit.org/) as an open VM that
> wraps a lot of the geo community's greatest open-source projects in a
> friendly and familiar interface, even
> [emulating Google's geocoder URL structure](http://www.datasciencetoolkit.org/developerdocs#googlestylegeocoder).
> Instead of using Google's elevation API, the crime project could have
> used NASA's SRTM elevation data through the
> [coordinates2statistics](http://www.datasciencetoolkit.org/developerdocs#coordinates2statistics) JSON
> endpoint, or even logged in to the PostGIS database that drives it to
> run bulk calculations.
> 
> There are a lot of other alternatives too. I have high hopes for
> [Nominatim](http://wiki.openstreetmap.org/wiki/Nominatim),
> OpenStreetMap's geocoding service, though a lot of my applications
> require a more ‘permissive' interface that accepts messier input.
> PostGIS now comes with
>  [a geocoder for US Census 'Tiger' data pre-installed too](http://wiki.bitnami.com/Components/PostgreSQL/PostGIS_Quick_Start_Guide#How_can_I_install_Tiger_Geocoder.3f).
> [Geonames](http://www.geonames.org/) has a great set of data on places
> all around the world you can explore.
> 
> If you don't see what you want, figure out if there are any similar
> projects you might be able to extend with a little effort, or that you
> can persuade the maintainers to work on for you. If you need
> neighborhood boundaries, why not take a look at building them
> in [Zetashapes](http://zetashapes.com/) and contributing them back? If
> Nominatim doesn't work well for your country's postal addresses, dig
> into improving their parser. I know only a tiny percentage of people
> will have the time, skills, or inclination to get involved, but just by
> hearing about the projects, you've increased the odds you'll end up
> helping.
> 
> I want to live in a world where basic facts about the places we live and
> work are freely available, so it's a lot easier to build amazing
> projects like the crime analysis that triggered this rant. Please, at
> least find out a little bit about the open alternatives before you use
> Google's geo APIs, you might be pleasantly surprised at what's out
> there!
> 
