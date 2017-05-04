def example(str, expected = nil, binding)
  @i ||= 0
  @i += 1
  result = eval(str, binding)
  status = result == expected ? :OK : :WRONG!  unless expected.nil?
rescue Exception => e
  result = e.message
  status = "ERROR!"
ensure
  puts <<EXAMPLE

Example ##{ @i }
#{ str }
# => #{ result }#{ " (#{ status })" if status }
EXAMPLE
end
