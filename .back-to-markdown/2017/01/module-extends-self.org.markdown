broken-links:nil

**WARNING: This is old and likely obsolete.**

Module extend self
==================

Buried in this blog post, I found an interesting construction. See the Example `module OrderRepository`.

I had never seen the `extend self` construct before, so I did a little playing around in Pry.

Using `extend self` in a module is similar to calling `class <<
  self ... end` with all the method definitions inside it. It\'s yet another way to get access to a module\'s eigenclass.

This goes along with using `def self.my_method` and using `module_function` to also making piecemeal module methods, the main distinction being that using `def self.my_method` creates a method that the **only** receiver will be the module itself, not any classes that include the module.

``` {.ruby}
module MyMod
  extend self

  def hi_there
    "hi there from inside MyMod"
  end

  private

  def go_away
    "go away now inside MyMod"
  end
end

MyMod.hi_there #=> "hi there from inside MyMod"
MyMod.go_away

class MyClass
  include MyMod

  def call_hi_there
    hi_there
  end
end

MyClass.hi_there
MyClass.new.hi_there #=> "hi there from inside MyMod"
MyClass.call_hi_there
MyClass.new.call_hi_there #=> "hi there from inside MyMod"
MyClass.go_away
MyClass.new.go_away

module YourMod
  class << self
    def hi_there
      "hi there from inside YourMod"
    end

    private

    def go_away
      "go away now inside YourMod"
    end
  end

  def que?
    "que? inside YourMod"
  end
end

YourMod.hi_there #=> "hi there from inside YourMod"
YourMod.go_away
YourMod.que?

module TheirMod
  def hi_there
    "hi there from inside TheirMod"
  end

  method_function :hi_there
end

TheirMod.hi_there #=> "hi there from inside TheirMod"

module ItsMod
  def self.hi_there
    "hi there from inside ItsMod"
  end
end

ItsMod.hi_there #=> "hi there from inside ItsMod"


class YourClass
  include YourMod

  def call_hi_there
    hi_there
  end
end

YourClass.new.hi_there #=> NoMethodError: undefined method `hi_there' for #<YourClass:0x007f50d0307cd0>
YourClass.new.call_hi_there #=> NameError: undefined local variable or method `hi_there' for #<YourClass:0x007f50d021aae8>

class TheirClass
  include TheirMod

  def call_hi_there
    hi_there
  end
end

TheirClass.new.hi_there #=> NoMethodError: private method `hi_there' called for #<TheirClass:0x007f50d0978880>
TheirClass.new.call_hi_there #=> "hi there from inside TheirMod"

class ItsClass
  include ItsMod

  def call_hi_there
    hi_there # not available!
  end

  def really_call_hi_there
    ItsMod.hi_there
  end
end

ItsClass.new.hi_there #=> NoMethodError: undefined method `hi_there' for #<ItsClass:0x007f50d0859aa8>
ItsClass.new.call_hi_there #=> NameError: undefined local variable or method `hi_there' for #<ItsClass:0x007f50d0817450>
ItsClass.new.really_call_hi_there #=> "hi there from inside ItsMod"

```
