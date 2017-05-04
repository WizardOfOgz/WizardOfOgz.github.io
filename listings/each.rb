class C
  attr_writer :xs

  # def to_ary
  #   @xs.keys
  # end

  def to_hash
    @xs
  end
end


c = C.new
# c.xs = [1,2,3]
c.xs = { a: 1, b: 2 }

c.tap do |*args, a: nil, **options|
  puts args.inspect
  puts a.inspect
  # puts b.inspect
  # puts c.inspect
  # puts d.inspect
  puts options.inspect
end
