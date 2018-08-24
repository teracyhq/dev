require 'logger'

require_relative 'common'
require_relative 'logging/progname_acceptor'

module TeracyDev
  module Logging
    # Use a hash class-ivar to cache a unique Logger per class:
    @@loggers = {}
    @@acceptors = [PrognameAcceptor.new] # default acceptors

    def self.logger_for(classname)
      # cache
      @@loggers[classname] ||= configure_logger_for(classname)
    end

    # support to add more acceptor if needed for customization
    def self.add_acceptor(acceptor)
      @@acceptors << acceptor
    end

    private

    def self.configure_logger_for(classname)
      logger = Logger.new(STDOUT)
      logger.progname = classname
      log_level = ENV['LOG_LEVEL'] ||= "info"

      case log_level
        when "unknown"
          logger.level = Logger::UNKNOWN
        when "fatal"
          logger.level = Logger::FATAL
        when "error"
          logger.level = Logger::ERROR
        when "warn"
          logger.level = Logger::WARN
        when "info"
          logger.level = Logger::INFO
        when "debug"
          logger.level = Logger::DEBUG
      end

      logger.formatter = proc do |severity, datetime, progname, msg|
        accepted = true

        @@acceptors.each do |acceptor|
          if ! acceptor.accept(severity, datetime, progname, msg)
            accepted = false
            break
          end
        end

        if accepted
          # TODO(hoatle): implement this
          # display log message here with tracing
          msg = "[#{progname}:#{caller[5]}][#{severity}]: #{msg}\n\n"
          case severity
          when "UNKNOWN", "FATAL", "ERROR"
            msg = TeracyDev::Common.red(msg)
          when "WARN"
            msg = TeracyDev::Common.yellow(msg)
          end
          puts msg
        end
      end
      logger
    end
  end
end
