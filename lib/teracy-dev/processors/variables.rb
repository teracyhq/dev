require_relative 'processor'

module TeracyDev
  module Processors
    class Variables < Processor

      def process(settings)
        @logger.debug("process: #{settings}")
        # TODO: implement this
        settings
      end
    end
  end
end

