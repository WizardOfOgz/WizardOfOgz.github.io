require 'date'

tomorrow = Date.today + 1

puts "The next 7 days:"
puts (tomorrow..Date::Infinity.new).take(7)
