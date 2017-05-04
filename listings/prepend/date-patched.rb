require_relative "../example"
require 'date'
require 'active_support/core_ext/range/overlaps'  # For Range#overlaps?
require_relative "date-core-ext.rb"  # Our patch

puts "Date::Infinity.ancestors:\n#{ Date::Infinity.ancestors }"

date = Date.today

# These should work now
example("Date::Infinity.new < date", false, binding)
example("(-Date::Infinity.new..date).overlaps?(date..Date::Infinity.new)", true, binding)
example("(-Date::Infinity.new..date).overlaps?(date + 1..Date::Infinity.new)", false, binding)
