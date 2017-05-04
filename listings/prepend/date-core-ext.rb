require "date"

module CoreExt
  module Date
    module Infinity
      # Adds comparison with Date instance.
      def <=>(other)
        case other
        when ::Date then d
        else
          super
        end
      end
    end
  end
end

::Date::Infinity.prepend(::CoreExt::Date::Infinity)
