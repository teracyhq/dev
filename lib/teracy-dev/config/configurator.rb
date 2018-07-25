require_relative '../logging'

module TeracyDev
  module Config
    # the base class for Configurator to extend
    class Configurator
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      # configurator must implement this to execute actual configuration
      def configure(settings, config, type:)

      end

    end
  end
end
