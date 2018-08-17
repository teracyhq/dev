require 'logger'

require_relative 'common'

module TeracyDev
  class Logging
    # Use a hash class-ivar to cache a unique Logger per class:
    @@loggers = {}

    def self.logger_for(classname)
      @@loggers[classname] ||= _configure_logger_for(classname)
    end

    def self._configure_logger_for(classname)
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
        msg = "[#{progname}][#{severity}]: #{msg}\n\n"
        case severity
        when "UNKNOWN", "FATAL", "ERROR"
          msg = TeracyDev::Common.red(msg)
        when "WARN"
          msg = TeracyDev::Common.yellow(msg)
        end
        puts msg
      end
      logger
    end
  end
end
