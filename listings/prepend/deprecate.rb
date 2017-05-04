module Deprecation
  def self.deprecate_methods(target_module, *method_names)
    target_module.prepend(
      Module.new {
        method_names.each do |method_name|
          define_method(method_name) do |*args, &block|
            warn("#{ method_name } is deprecated.")
            super(*args, &block)
          end
        end
      }
    )
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
Foo.new.bar  # This still works
