require_relative '../logging'

module TeracyDev
  module Processors
    # the base class for Processor to extend
    class Processor
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      # processor must implement this to execute actual configuration
      def process(settings)
        settings
      end

    end
  end
end
