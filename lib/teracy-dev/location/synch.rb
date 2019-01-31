require_relative '../logging'

module TeracyDev
  module Location
    class Synch
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      protected

      # to be implemented by subclass
      # return true if sync action is carried out, otherwise, return false
      def sync(_location_conf, _sync_existing)
        return false
      end
    end
  end
end
