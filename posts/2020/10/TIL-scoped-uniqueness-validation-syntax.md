## Keywords:

- Ruby
- Rails
- Validators
- ActiveRecord
- Uniqueness

## Introduction

In Rails versions prior to 5.1, the standard accepted way to do a scoped uniqueness validation was by using the `validate_uniqueness_of` method:

``` ruby
class Subcategory < ApplicationRecord

  belongs_to :category
  
  validate_presence of :slug
  validate_uniqueness_of :slug, scope: :category_id
end
```

With Rails 5.2, the longer forms are being deprecated, in favour of using the `validates` method instead.

In the api docs, however, the uniqueness validator isn't discussed, not even an example.

Luckily, I had rubocop set up to complain about the use of the older methods, and told it to fix the failures it found.

The new syntax would be:

``` ruby
class Subcategory < ApplicationRecord

  belongs_to :category
  
  validates :slug, presence: true
  validates :slug, uniqueness: { scope: :category_id }
end
```

