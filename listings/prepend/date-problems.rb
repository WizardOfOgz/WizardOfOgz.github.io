require_relative "../example"
require 'date'
require 'active_support/core_ext/range/overlaps'  # For Range#overlaps?

date = Date.today

example("date < Date::Infinity.new", true, binding)
example("(date..Date::Infinity.new).overlaps?(date..Date::Infinity.new)", true, binding)
example("(date..Date::Infinity.new).overlaps?(date - 7..date - 1)", false, binding)
example("(-Date::Infinity.new..date).overlaps?(date..Date::Infinity.new)", true, binding)
example("Date::Infinity.new < date", false, binding)
