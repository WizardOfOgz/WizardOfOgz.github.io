M = Module.new

class Foo
  include M
end

class Bar
  prepend M
end


puts "M  included: #{ Foo.ancestors.inspect }"
puts "M prepended: #{ Bar.ancestors.inspect }"

# puts <<MSG
# \n### Note that .ancestors returns the inheritance chain
# and not the class hierarchy. The superclass is the same
# for both cases above\n
# MSG
# puts "Foo's superclass: #{ Foo.superclass }"
# puts "Bar's superclass: #{ Bar.superclass }"
