require_relative '../logging'

module TeracyDev
  module Config
    # Manage the vagrant configuration from the provided settings hash object
    class Manager
      @@instance = nil

      def initialize
        if !!@@instance
          raise "TeracyDev::Processors::Manager can only be initialized once"
        end
        @@instance = self

        @logger = TeracyDev::Logging.logger_for(self.class.name)
        @configurators = []
      end

      def register(configurator)
        if !configurator.respond_to?(:configure)
          @logger.warn("configurator #{configurator} must implement configure method, ignored")
          return
        end
        @configurators << configurator
        @logger.debug("configurator: #{configurator} registered")
      end


      def configure(settings, config, type:)
        @logger.debug("configure #{type}: #{config} with #{settings}")

        @configurators.each do |configurator|
          configurator.configure(settings, config, type: type)
        end
      end

    end
  end
end
