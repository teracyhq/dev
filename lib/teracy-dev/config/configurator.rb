require_relative '../logging'

module TeracyDev
  module Config
    # the base class for Configurator to extend
    class Configurator
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      # configurator must have this method to execute actual configuration
      def configure(settings, config, type:)
        case type
        when 'common'
          configure_common(settings, config)
        when 'node'
          configure_node(settings, config)
        end
      end

      protected

      # sub class should override this
      def configure_common(settings, config); end

      # sub class should override this
      def configure_node(settings, config); end
    end
  end
end
