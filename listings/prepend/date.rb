require_relative "../example"
require 'date'

date = Date.today
puts "date: #{ date }"

example("date < Date::Infinity.new", binding)
example("date < -Date::Infinity.new", binding)
