Repost: RSpec 3 and deprecated .and~return~ blocks {#repost-rspec-3-and-deprecated-.and_return-blocks}
==================================================

**WARNING: This is old and likely obsolete.**

-   published date: 2014-12-22 22:43
-   keywords: \[\"rspec\", \"rspec3\", \"ruby\", \"swaac\"\]
-   source:

Over at the [ow ow! that hurts! blog](http://owowthathurts.blogspot.com/2014/08/rspec-3-and-deprecated-andreturn-blocks.html) , a nice little tidbit of information on a difference between RSpec version 2 and version 3:

RSpec 3 and Deprecated .and~return~ Blocks {#rspec-3-and-deprecated-.and_return-blocks}
------------------------------------------

A deprecation warning I received after upgrading RSpec:

``` {.example}
`and_return { value }` is deprecated. Use `and_return(value)` or
an implementation block without `and_return` instead
```

An example of code it\'s complaining about:

``` {.ruby}
@mock_thing.should_receive(:something).and_return do
  double("SomeKindOfRelationship").tap do | mock_assoc |
    mock_assoc.should_receive(:where).and_return([ @mock_relationship ])
  end
end
```

To fix, just remove the `.and_return`:

``` {.ruby}
@mock_thing.should_receive(:something) do
  double("SomeKindOfRelationship").tap do | mock_assoc |
    mock_assoc.should_receive(:where).and_return([ @mock_relationship])
  end
end
```

Of course, make sure your tests pass after the change.
