---
title: "YIL: Rails validators don't change parameter type"
date: 2020-04-07T09:04
category: rails 
tags: [validation, type, params]
---

So I figured this out a while ago, but seems that I forgot to write it down, hence "YIL" - Yesterday I Learned.

I was working with a numeric parameter in Rails, that needed to be a non-negative interger, less than a maximum level. A pretty simple validator :

``` ruby
validates_numericality_of :age,
                          :only_integer,
                          greater_than_or_equal_to: 0,
                          less_than_or_equal_to: MAX_AGE
```

The validators work with `age` regardless of whether it's a number or string; coming in via a parameter from the controller, it will be a string. In a Rails model, this isn't much of an issue since the variable gets converted to whatever is the right type when the record is persisted.

The case I was working with wasn't an ActiveRecord however, but just an ActiveModel service object.

In order to fix this for the object model, I used an `after_validation` callback to transform the variable:

``` ruby
def recast_attributes

  age = age.to_i

end
```

