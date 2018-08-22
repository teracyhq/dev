require 'logger'

require_relative 'common'

module TeracyDev
  LOG_FILTER = ENV['LOG_FILTER'] || nil # No filter: display all

  class Logging
    # Use a hash class-ivar to cache a unique Logger per class:
    @@loggers = {}

    @@filter_message = {}

    @@filter_progname = {}

    def self.logger_for(classname)
      @@filter_progname[classname] ||= [LOG_FILTER]

      @@filter_message[classname] ||= [LOG_FILTER]

      @@loggers[classname] ||= _configure_logger_for(classname)
    end

    # default filter is for progname
    def self.add_filter(classname, filter_regex)
      self.add_filter_for_progname(classname, filter_regex)
    end

    def self.add_filter_for_message(classname, filter_regex)
      @@filter_message[classname] << filter_regex
    end

    def self.add_filter_for_progname(classname, filter_regex)
      @@filter_progname[classname] << filter_regex
    end

    def self.filter_message(classname, text)
      return true if !@@filter_message[classname].any?

      @@filter_message[classname].reduce(true) do |memo, reg|
        memo and !Regexp.new(reg).match(text).nil?
      end
    end

    def self.filter_progname(classname, text)
      return true if !@@filter_progname[classname].any?

      @@filter_progname[classname].reduce(true) do |memo, reg|
        memo and !Regexp.new(reg).match(text).nil?
      end
    end

    # def self.filter(classname, text)
    #   return true if !@@filter[classname].any?

    #   @@filter[classname].reduce(true) do |memo, reg|
    #     memo and !Regexp.new(reg).match(text).nil?
    #   end
    # end

    def self._configure_logger_for(classname, filter_regex=nil)
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
        ret_msg = "[#{progname}:#{caller[5]}][#{TeracyDev::Common.green(severity)}]: #{msg}\n\n"

        case severity
        when "UNKNOWN", "FATAL", "ERROR"
          ret_msg = TeracyDev::Common.red(ret_msg)
        when "WARN"
          ret_msg = TeracyDev::Common.yellow(ret_msg)
        end

        # PROPOSAL: just use this one method: self.filter(classname, ret_msg)
        puts ret_msg if self.filter_message(classname, msg.to_s) and self.filter_progname(
          classname, "[#{progname}:#{caller[5]}]")
      end

      logger
    end
  end
end
