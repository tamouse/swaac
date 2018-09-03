---
layout: post
title: "Rails: Immutable Records and Attributes"
date: 2015-08-13 05:58
categories: ["rails"]
tags: ["immutability", "activerecord", "rails"]
source: http://stackoverflow.com/a/14781183/742446
---
Recently needing to ensure that financial transactions remain
unchanged, I went looking about to see if anyone else had solved
this. I had done it previously, and my method turns out to be
useful.

## Immutability

Sometimes, you want to ensure that once created, an ActiveRecord model
object record does not get changed. In my case, these are records of
transactions against payment methods. They serve as an audit trail and
history of financial transactions performed by users in our system
(yay [Brewtoad](https://www.brewtoad.com/)!!).

## Whole-record Immutability

In this case, I wanted the entire record to remain unchangeable. There
are two approaches to this, either hooking before_save or using a
validation. I prefer using a validation as it also provides some
feedback to the caller.

{% highlight ruby %}
class Transaction < ActiveRecord::Base

  validate :force_immutable

  # ....

  private

  def force_immutable
    if self.changed? && self.persisted?
      errors.add(:base, :immutable)
      # Optional: restore the original record
      self.reload
    end
  end
end
{% endhighlight %}

`force_immutable` will only invalidate the operation when the record
is "dirty" which is checked with the `.changed?` method, **and** the
record has already been saved to the database which is checked by the
`.persisted?` method.

As per usual, the error is added to the `errors` collection and the
validation will fail.

But the extra thing I'm adding here is I'm *reloading* the record to
preserve for the caller the immutable state of the record.

> NOTE: There is a good argument to be made for **NOT** doing this as
> well, and having the caller deal with the issue.

## Attribute Immutability

In some cases, I only want some attribute fields in the record to be
immutable, such as an order's PO Number. There is a Rails method
`attr_readonly` in `ActiveRecord::ReadOnly::ClassMethods` however it
simple acts silently and I'd like to provide some feedback to the
caller.

I use the same mechanism of the validation, but here individual
attributes are checked to see if they've changed in some way.


{% highlight ruby %}
class Order < ActiveRecord::Base
  IMMUTABLE = %w{po_number}

  validate :force_immutable

  # ...

  private

  def force_immutable
    if self.persisted?
      IMMUTABLE.each do |attr|
        self.changed.include?(attr) &&
          errors.add(attr, :immutable)
      end
    end
  end
end
{% endhighlight %}

Inside the `force_immutable` method, the validation is only performed
on an already persisted record. For every element of the `IMMUTABLE`
array, it is checked against the list of changed attributes. If an
`IMMUTABLE` element has been changed, an error for that attribute is
shown.

It is possible also to restore the previous value, similarly to the
way the entire record is reloaded. The
[`ActiveModel::Dirty`](http://api.rubyonrails.org/classes/ActiveModel/Dirty.html)
module includes the previous values allowing you to restore them if
you wish. It's a bit more work than simply reloading the entire record
as I did above, because the caller may have made legitimate changes as
well as the changes to immutable attributes.

{% highlight ruby %}
class Order < ActiveRecord::Base
  IMMUTABLE = %w{po_number}

  validate :force_immutable

  # ...

  private

  def force_immutable
    if self.persisted?
      IMMUTABLE.each do |attr|
        self.changed.include?(attr) &&
          errors.add(attr, :immutable) &&
          self[attr] = self.changed_attributes[attr]
      end
    end
  end
end
{% endhighlight %}
