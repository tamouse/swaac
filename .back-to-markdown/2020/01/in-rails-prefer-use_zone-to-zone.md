---
title: "Prefer Time.use_zone to Time.zone in Rails"
date: 2020-01-19
categories: [rails]
tags: [timezones]
---

> Rails better practice for dealing with altering the current process's timezone

# In Rails, Prefer \`.use\_zone\` to \`.zone=\`

I had thought to write a post on this, but never got around to it.

[Prathamesh Sonpatki](https://prathamesh.tech/) [beat me to it :\)](https://prathamesh.tech/2019/07/11/use-time-use_zone-to-navigate-timezone/)

Essentially, this is the practice I use:

```text
Time.use_zone(current_user.timezone) do 
  # Do Time and DateTime operations under the auspices of the
  # current user's timezone setting.
  
  Time.current # The current time in the current user's timezone
  Time.zone.now # Equivalent to the above
end
```

It's better than just supposing that `Time.zone` has been set somewhere in the current process, **or** that `Time.zone` has been set to what the code in the block _expects it to be!_

## In Testing ##

The biggest source of error that I've encountered for this isn't in requests, but actually in the spec test cases for the product. Some test cases blythely set `Time.zone` in a before action, but never reset it in an after action.

If possible, wrap the time zone use inside an `around` action:

```text
around(:each) do |example|
  Time.use_zone(some_timezone) do
    yield example
  end
end
```

### With [Timecop](https://github.com/travisjeffery/timecop) ###

Since Timecop is essentially mocking the system clock, you can use it with `.use_zone` with impunity.

```text
around do |example|
  Timecop.freeze do
    @account = Fabricate(:account)
    Time.use_zone(account.timezone) do
      yield example
    end
  end
end
```

