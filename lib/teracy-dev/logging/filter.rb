module TeracyDev
  module Logging
    class Filter

      protected
      # to be implemented by subclass, return the filtered message
      def filtered(msg)
        return msg
      end
    end
  end
end
