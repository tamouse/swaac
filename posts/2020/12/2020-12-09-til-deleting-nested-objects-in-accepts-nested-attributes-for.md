---
title: "TIL: Deleting nested objects in accepts_nested_attributes_for"
Area: SWaaC
Created: 2020-05-04T12:46:00
Link: https://api.rubyonrails.org/v5.1.7/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for
Published: 2020-12-09T22:46
tags: Rails, attributes, nesting
topic: Ruby and Rails
---

> By default the associated records are protected from being destroyed. If you want to destroy any of the associated records through the attributes hash, you have to enable it first using the `:allow_destroy` option. This will allow you to also use the `_destroy` key to destroy existing records:

```ruby
class Member < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts, allow_destroy: true
end

params = { member: {
  posts_attributes: [{ id: '2', _destroy: '1' }]
}}

member.attributes = params[:member]
member.posts.detect { |p| p.id == 2 }.marked_for_destruction? # => true
member.posts.length # => 2
member.save
member.reload.posts.length # => 1
```

Up earlier in the page, the `_destroy` is mentioned:

> For each hash that does not have an id key a new record will be instantiated, unless the hash also contains a `_destroy` key that evaluates to true.

So apparently it doesn't matter what the actual value of the key is, as long as it's *truthy*

In the controller, make sure to permit the `_destroy` attribute as well.

## an example

If this is the row in your form that contains a subitem to go along with the update of the item:

```html
<div class="row" id="item_subitem_2_row">
  <input type="hidden" name="item[subitem][2][id]" value="12" id="item_subitem_2_id" />
  <!-- rest of row fields -->
  <button type="button" id="item_subitem_2_delete_button">
    <span class="trash-can-icon"></span>
  </button>
</div>
```

you would need to extract that row and replace it with:

```html
<div class="row">
  <input type="hidden" name="item[subitem][2][id]" value="12" />
  <input type="hidden" name="item[subitem][2][_destroy]" value="1" />
</div>
```

The `id` on the `input` field in the first code snippet is typically auto-generated by Rails form helpers. The "destroy" hidden input doesn't really need an `id` field as it won't be referred to by the DOM. Unless you need to for some reason, then add one.

Then some JavaScript is necessary to detect the delete subitem button click, and perform the replacement.

Theoretically, which means I haven't been able to try this yet, the `_destroy` field could be already defined for the form row, and you set the value of it to something truthy on button click, and hide the row.

-----

Source: <https://api.rubyonrails.org/v5.1.7/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for>