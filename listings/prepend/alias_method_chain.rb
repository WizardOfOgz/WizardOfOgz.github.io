# This is a simplified version of code in Rails 4.2.4
require 'active_support/core_ext/module/aliasing'  # For alias_method_chain

module Deprecation
  def self.deprecate_methods(target_module, *method_names)
    method_names.each do |method_name|

      target_module.class_eval do
        define_method("#{ method_name }_with_deprecation") do |*args, &block|
          warn("#{ method_name } is deprecated.")
          send("#{ method_name }_without_deprecation", *args, &block)
        end

        alias_method_chain method_name, :deprecation
        # alias_method "#{ method_name }_without_deprecation", method_name
        # alias_method method_name, "#{ method_name }_with_deprecation"
      end
    end
  end
end

class Foo
  def bar
    puts "Fubar"
  end
end
Deprecation.deprecate_methods(Foo, :bar)
Foo.new.bar  # It works!


class Foo
  def bar
    puts "Fubar with altered behavior"
  end
end
Foo.new.bar  # Deprecation warning is missing
