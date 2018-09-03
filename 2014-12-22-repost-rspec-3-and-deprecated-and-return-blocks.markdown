---
layout: post
title: "Repost: RSpec 3 and deprecated .and_return blocks"
date: 2014-12-22 22:43
categories: ["swaac"]
tags: ["ruby", "rspec", "rspec3"]
source: http://owowthathurts.blogspot.com/2014/08/rspec-3-and-deprecated-andreturn-blocks.html
---
Over at the [owowthathurts blog]({{ page.source }}), a nice little tidbit of information on a difference between RSpec version 2 and version 3:

# RSpec 3 and Deprecated .and\_return Blocks

A deprecation warning I received after upgrading RSpec:

```
`and_return { value }` is deprecated. Use `and_return(value)` or
an implementation block without `and_return` instead
```

An example of code it's complaining about:

``` ruby
@mock_thing.should_receive(:something).and_return do
  double("SomeKindOfRelationship").tap do | mock_assoc |
    mock_assoc.should_receive(:where).and_return([ @mock_relationship ])
  end
end
```

To fix, just remove the `.and_return`:

``` ruby
@mock_thing.should_receive(:something) do
  double("SomeKindOfRelationship").tap do | mock_assoc |
    mock_assoc.should_receive(:where).and_return([ @mock_relationship])
  end
end
```


Of course, make sure your tests pass after the change.
