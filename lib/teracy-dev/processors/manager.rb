require_relative '../logging'
require_relative '../util'

module TeracyDev
  module Processors
    class Manager
      @@instance = nil

      def initialize
        if !!@@instance
          raise "TeracyDev::Processors::Manager can only be initialized once"
        end
        @@instance = self

        @logger = Logging.logger_for(self.class.name)
        @processors = []
      end

      def register(processor, weight)
        if !processor.respond_to?(:process)
          @logger.warn("processor #{processor} must implement process method, ignored")
          return
        end

        unless weight.is_a? Integer and (0..9).include?(weight)
          @logger.warn("#{processor}'s weight must be integer and have value in range 0.. 9, otherwise weight will be set to default (5)")
          weight = 5
        end

        @processors << { processor: processor, id: @processors.length, weight: weight }
        @logger.debug("processor: #{processor} registered")
      end

      # run the pipelines
      def process(settings)
        @logger.debug("start processing: #{settings}")

        TeracyDev::Util.multi_sort(@processors, weight: :desc, id: :asc).each do |processor|
          result = processor[:processor].process(settings)
          if !result
            @logger.warn("invalid result from #{processor[:processor]}, ignored")
            next
          end
          settings = result
        end

        settings
      end

    end
  end
end
