require_relative 'acceptor'

module TeracyDev
  module Logging
    # filter messages by LOG_PROGNAME env var
    # LOG_PROGNAME=TeracyDev => display all logs has progname matching TeracyDev, eg: TeracyDev, TeracyDev::Config, etc
    # LOG_PROGNAME=TeracyDev::Config => display all logs has progname matching TeracyDev::Config, eg: TeracyDev::Config, TeracyDev::Config::Provisioners, etc
    class PrognameAcceptor < Acceptor

      def initialize
        @LOG_PROGNAME = ENV['LOG_PROGNAME'] || '.*' # use regex to check with progname
      end

      def accept(severity, datetime, progname, msg)
        return !Regexp.new(@LOG_PROGNAME).match(progname.to_s).nil?
      end
    end
  end
end
