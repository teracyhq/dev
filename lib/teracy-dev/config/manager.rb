require_relative '../logging'
require_relative '../util'

module TeracyDev
  module Config
    # Manage the vagrant configuration from the provided settings hash object
    class Manager
      @instance = nil

      def initialize
        raise 'TeracyDev::Config::Manager can only be initialized once' if !!@instance

        @instance = self
        @logger = TeracyDev::Logging.logger_for(self.class.name)
        @items = []
      end

      def register(configurator, weight)
        unless configurator.respond_to?(:configure)
          @logger.warn("configurator #{configurator} must implement configure method, ignored")
          return
        end

        unless weight.is_a?(Integer) && (0..9).include?(weight)
          @logger.warn("#{configurator}'s weight (#{weight}) " \
          'must be an integer and have value in range (0..9),' \
          'otherwise it will be set to default (5)')
          weight = 5
        end

        @items << { configurator: configurator, id: @items.length, weight: weight }
        @logger.debug("configurator: #{configurator} registered")
      end

      def configure(settings, config, type:)
        @logger.debug("configure #{type}: #{config} with #{settings}")

        TeracyDev::Util.multi_sort(@items, weight: :desc, id: :asc).each do |item|
          configurator = item[:configurator]
          configurator.configure(Util.deep_copy(settings).freeze, config, type: type)
        end
      end
    end
  end
end
