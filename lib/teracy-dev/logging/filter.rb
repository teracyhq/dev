require_relative '../logging'

module TeracyDev
  module Logging
    class Filter
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      protected

      # to be implemented by subclass, return the filtered message
      def filter(msg)
        return msg
      end
    end
  end
end
