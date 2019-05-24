require_relative '../logging'

module TeracyDev
  module Logging
    class Acceptor
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      protected

      # to be implemented by subclass, return true or false
      # return true => log will be displayed
      def accept(_severity, _datetime, _progname, _msg)
        return true
      end
    end
  end
end
