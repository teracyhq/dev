module TeracyDev
  module Logging
    class Acceptor

      protected
      # to be implemented by subclass, return true or false
      # return true => log will be displayed
      def accept(severity, datetime, progname, msg)
        return true
      end
    end
  end
end
