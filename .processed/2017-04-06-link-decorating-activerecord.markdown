# Link: Decorating ActiveRecord

- published date: 2017-04-06 23:01
- keywords: ["activerecord", "decorators", "links", "rails", "tl-dr"]
- source: https://robots.thoughtbot.com/decorating-activerecord



This came across my path this
week: [Joël Quenneville](https://robots.thoughtbot.com/authors/joel-quenneville)'s
article,
[Decorating ActiveRecord]({{ page.source }}),
which outlines some hazards when you go about decorating ActiveRecord
models.

Do read the article, it's good.


*******




Here's the tl;dr for my memory:

> If you’re decorating an ActiveRecord or ActiveModel object in Rails,
> you probably want to define the following to ensure the decorator
> works the way you expect instead of silently delegating to the
> underlying object:


<blockquote>

```ruby linenos
class Profile < SimpleDelegator
  extend ActiveModel::Naming

  def to_model
    self
  end
end
```

</blockquote>
