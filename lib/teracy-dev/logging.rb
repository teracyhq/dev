require 'logger'

require_relative 'common'


module TeracyDev
  module Logging
    # Use a hash class-ivar to cache a unique Logger per class:
    @@loggers = {}
    @@acceptors = []
    @@filters = []

    def self.logger_for(classname)
      # cache
      @@loggers[classname] ||= configure_logger_for(classname)
    end

    # support to add more acceptor if needed for customization
    def self.add_acceptor(acceptor)
      @@acceptors << acceptor
    end

    def self.add_filter(filter)
      @@filters << filter
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
          @@filters.each do |flt|
            if flt.respond_to?(:filtered)
              deprecated_msg = "[TeracyDev::Logging][WARN]: filter.filtered is deprecated, use filter.filter instead for #{flt}"
              puts TeracyDev::Common.yellow(deprecated_msg)
              msg = flt.filtered(msg.to_s)
            else
              msg = flt.filter(msg.to_s)
            end
          end
          log = "[#{progname}][#{severity}]: #{msg}\n"
          case severity
          when "UNKNOWN", "FATAL", "ERROR"
            log = TeracyDev::Common.red(log)
          when "WARN"
            log = TeracyDev::Common.yellow(log)
          when "INFO"
            log = TeracyDev::Common.green(log)
          when "DEBUG"
            # display log message here with tracing
            # display the trace of the exact line numeber having logger call (file, line number, function name)
            tracing = TeracyDev::Common.light_gray("#{caller[3]}\n")
            log = log + tracing
          end

          puts log
        end
      end
      logger
    end
  end
end
