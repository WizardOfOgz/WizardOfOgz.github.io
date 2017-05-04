require_relative "../example"
require 'active_support/core_ext/module/aliasing'  # For alias_method_chain

# Just pretend like this is some 3rd party class out of  your control
# (actually, since you are a Ruby developer you are in complete control)
class BlackBox
  def to_s
    "black box"
  end
end

black_box = BlackBox.new

# Use alias_method_chain to
BlackBox.class_eval do
  def to_s_with_mischief
    original = to_s_without_mischief  # This is kinda like calling 'super' in other examples
    "#{ original } - pwnd!"
  end

  alias_method_chain :to_s, :mischief
  # # Or you could have done:
  # alias to_s_without_mischief to_s
  # alias to_s to_s_with_mischief
end

example("black_box.to_s", binding)
example("black_box.method(:to_s)", binding)
