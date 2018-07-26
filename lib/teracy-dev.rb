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
  @@settingsManager = Settings::Manager.new

  # learn from https://github.com/hashicorp/vagrant/blob/ee5656da37c75e896201d389c79da199114603c2/lib/vagrant.rb#L216
  def self.require_version(*requirements)
    if !Util.require_version_valid?(VERSION, *requirements)
      @@logger.error("teracy-dev's current version: #{VERSION}")
      @@logger.error("`#{requirements}` is required, make sure to update teracy-dev to satisfy the requirements.")
      abort
    end
  end

  def self.register_processor(processor)
    @@processorsManager.register(processor)
  end

  def self.process(settings)
    @@processorsManager.process(settings)
  end

  def self.build_settings(organization_dir_path='workspace/dev-setup/')
    @@logger.debug("build_settings: #{organization_dir_path}")
    @@settingsManager.build_settings(organization_dir_path)
  end

  # load extension file (Vagrantfile-ext.rb) by convention if available within the extension path
  def self.load_extensions(settings)
    extensions = settings['teracy-dev']['extensions']
    @@logger.debug("load_extensions: #{extensions}")
    extensions.each do |extension|
      file_path = Util.normalized_dir_path(extension['path']) + 'Vagrantfile-ext.rb'

      if File.exists? file_path
        Util.load_file_path(file_path)
      else
        @@logger.debug("load_extensions: #{file_path} does not exist, ignored.")
      end
    end
  end

  def self.register_configurator(configurator)
    @@configManager.register(configurator)
  end

  def self.configure(settings, config, type:)
    @@configManager.configure(settings, config, type: type)
  end

end
