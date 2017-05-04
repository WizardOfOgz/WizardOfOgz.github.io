# Mixin best practice

module M
  def self.included(klass)
    klass.include(InstanceMethods)
    klass.prepend(PrependedMethods)
    klass.extend(ClassMethods)
  end

  module InstanceMethods; end
  module PrependedMethods; end
  module ClassMethods; end
end

class Foo
  include M
end
