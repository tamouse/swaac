# Using open-ended ranges in rails

I just found out about this today.

You can use an open-ended range when checking dates in ActiveRecord:

```ruby
    account.orders.where(occurred_at: 6.months.ago..).count
```

This replaces the old way of doing this:

```ruby
    account.orders.where("occurred_at > ?", 6.months.ago).count
```
