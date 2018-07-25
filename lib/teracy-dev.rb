# to use teracy/dev, just require it: require 'teracy/dev'
# and it will load all the required modules loaded here

require_relative 'teracy-dev/version'
require_relative 'teracy-dev/util'
require_relative 'teracy-dev/logging'
require_relative 'teracy-dev/settings/manager'
require_relative 'teracy-dev/processors/manager'
require_relative 'teracy-dev/config/manager'


# define public APIs here
module TeracyDev

  @@logger = Logging.logger_for('::')
  @@processorsManager = Processors::Manager.new
  @@configManager = Config::Manager.new
  # learn from https://github.com/hashicorp/vagrant/blob/ee5656da37c75e896201d389c79da199114603c2/lib/vagrant.rb#L216
  def self.require_version(*requirements)
    @@logger.info("teracy-dev version: #{VERSION}")
    Util.require_version(VERSION, *requirements)
  end

  def self.register_processor(processor)
    @@processorsManager.register(processor)
  end

  def self.process(settings)
    @@processorsManager.process(settings)
  end

  def self.build_settings(lookup_dir='workspace/dev-setup/')
    @@logger.debug("build_settings: #{lookup_dir}")
    Settings::Manager.build_settings(lookup_dir)
  end

  def self.load_extensions(extension_paths)
    extension_paths ||= []
    @@logger.debug("load_extensions: #{extension_paths}")
    extension_paths.each do |file_path|
      Util.load_file_path(file_path)
    end
  end

  def self.register_configurator(configurator)
    @@configManager.register(configurator)
  end

  def self.configure(settings, config, type:)
    @@configManager.configure(settings, config, type: type)
  end

end
