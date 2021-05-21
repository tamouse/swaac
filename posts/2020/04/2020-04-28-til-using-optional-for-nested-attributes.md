# TIL: Using optional for nested attributes

Area: SWaaC  
Created: Apr 25, 2020 10:18 AM  
Done: No  
Draft Date: Apr 28, 2020  
Hide: No  
Series: TIL  
Status: In Review  
Tags: Rails, nesting  
Topic: Ruby and Rails  a

## TL;DR

Eventually I found the issue: When you (meaning "I") do this, you (I) need to set `optional: true` on the `belongs_to` side.

## The Problem

I've been banging my head on the keyboard trying to figure this out.
I had two models where once accepts the nested attributes for the other. It was just not working the way I thought it should. 
I kept getting back a validation error on the relationship `purchase_id`, and everything I tried was not working as I expected.
Removing the `accepts_nested_attributes_for` line made it work, and it really should have behaved the same way.

## Discussion

### Two models

1. `Purchase`, has many `PurchaseDetail`
2. `PurchaseDetail`, which belongs to `Purchase`

### purchase.rb:

```ruby
class Purchase < ApplicationRecord
  has_many :purchase_details
  accepts_nested_attributes_for :purchase_details
end
```

### purchase_detail.rb ###

```ruby
class PurchaseDetail < ApplicationRecord
  belongs_to :purchase, optional: true       ## NOTE: optional!!!
end
```

The `belongs_to` line as an `optional: true`, which tells Rails that the dependent records are required to have the foreign key field filled in when they are part of the whole conglomeration. This switched meanings from Rails 4 to Rails 5 sometime.

### The following form view:

```html
<%= form_for(purchase) do |f| %>
  <div class="field">
    <%= f.label :name %>
    <%= f.text_field :name %>
  </div>

  <%= f.fields_for :purchase_details, purchase.purchase_details.each do |ff| %>
    <div class="field">
      <%= ff.label :kind %>
      <%= ff.text_field :kind %>
    </div> 
  <% end %>

  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

### Produces the following form:

```html
<form class="new_purchase" id="new_purchase" action="/purchases" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="authenticity_token" value="68IcN2OakPU+T2Y0SdbckzQPIrAN7XKoeaHxHD8JLB0KnCblSMaC78tHziLSm6orY8htBDDpwjSgNi5G+pt6hQ==" />
  <div class="field">
    <label for="purchase_name">Name</label>
    <input type="text" name="purchase[name]" id="purchase_name" />
  </div>
  <div class="field">
    <label for="purchase_purchase_details_attributes_0_kind">Kind</label>
    <input type="text" name="purchase[purchase_details_attributes][0][kind]" id="purchase_purchase_details_attributes_0_kind" />
  </div> 
  <div class="field">
    <label for="purchase_purchase_details_attributes_1_kind">Kind</label>
    <input type="text" name="purchase[purchase_details_attributes][1][kind]" id="purchase_purchase_details_attributes_1_kind" />
  </div> 
  <div class="actions">
    <input type="submit" name="commit" value="Create Purchase" data-disable-with="Create Purchase" />
  </div>
</form>
```

### This comes up to the PurchasesController#purchase_params private method:

```ruby
  def purchase_params
    params.require(:purchase).permit(:name, purchase_details_attributes: [:id, :kind])
  end
```

### Which is called in PurchasesController#create:

```ruby
def create
    @purchase = Purchase.new(purchase_params)
    
    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end
```

This was **failing** on me for the longest time, until it was pointed out that the `belongs_to` relationship has `:optional` turned *off by default in Rails 5!* Setting it to true suddenly made everything work as expected. This was a long long frustrating day.

The most difficult thing is looking at the app I'm working on, running this same version of Rails and Ruby, is that it works *without* having to specify the `optional: true` flag on the `belongs_to`. 

## The aftermath

The failure when the `optional` field was left off was that the independent record would not save because of a validation error. Inspecting the validation errors on the dependent records didn't lead me to a solution straight away, though. I still had to fumble around, read lots of blog posts and stack overflows until I finally found mention of the `optional: true` flag.

This confused me for a long time, as well, as the project I'm currently working on also does not have the `optional: true` set and yet it works. The project did migrate from 4 to 5, but perhaps there's some gem that takes care of that. I will have to ask about it.
