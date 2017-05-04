module M
  def baz
    puts "=> inside M"
    super if defined?(super)
  end
end

class Foo
  include M

  def baz
    puts "=> inside Foo"
    super
  end
end

class Bar
  prepend M

  def baz
    puts "=> inside Bar"
  end
end

puts "Use super methods to show the difference between `include` and `prepend` and the order of the inheritance chain.\n\n"

puts "Foo.new.baz (using include)"
Foo.new.baz
puts "-----------"
puts "Bar.new.baz (using prepend)"
Bar.new.baz
