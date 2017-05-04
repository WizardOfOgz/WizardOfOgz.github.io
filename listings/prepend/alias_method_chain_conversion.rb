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

module Ext
  module BlackBox
    def to_s
      "#{ super } - pwnd!"
    end
  end
end

BlackBox.prepend(Ext::BlackBox)

example("black_box.to_s", binding)
example("black_box.method(:to_s)", binding)
