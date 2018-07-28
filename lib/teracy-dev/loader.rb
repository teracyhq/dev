require 'yaml'

require_relative 'logging'
require_relative 'plugin'
require_relative 'util'
require_relative 'version'
require_relative 'processors/manager'
require_relative 'config/manager'
require_relative 'settings/manager'


module TeracyDev
  class Loader
    @@instance = nil

    attr_reader :processorsManager, :configManager

    def initialize
      if !!@@instance
        raise "TeracyDev::Loader can only be initialized once"
      end
      @@instance = self
      @logger = Logging.logger_for(self.class.name)
    end

    def start
      init_system
      @processorsManager = Processors::Manager.new
      @configManager = Config::Manager.new
      settings = build_settings.freeze
      require_teracy_dev_version(settings['teracy-dev']['require_version'])
      configure_vagrant(settings)
    end

    private

    def init_system
      system_settings = YAML.load_file(File.join(File.dirname(__FILE__), '../../system.yaml'))
      @logger.debug("init_system: system_settings: #{system_settings}")
      # versions requirements
      Vagrant.require_version system_settings['vagrant']['require_version']
      TeracyDev::Plugin.sync(system_settings['vagrant']['plugins'])
    end

    def build_settings
      extension_entry_dir_path = ENV['TERACY_DEV_EXTENSION_ENTRY_DIR_PATH'] ||= 'workspace/teracy-dev-entry/'
      settingsManager = Settings::Manager.new
      settings = settingsManager.build_settings(extension_entry_dir_path)
      load_extension_entry_files(settings)
      settings = process(settings)
    end

    def load_extension_entry_files(settings)
      @logger.debug("load_extension_entry_files: #{settings}")
      extensions = settings['teracy-dev']['extensions'] ||= []
      extensions.each do |extension|
        file_path = File.join(extension['path'], 'teracy-dev-ext.rb')
        absolute_path = File.join(File.dirname(__FILE__), '../../', file_path)
        @logger.debug("load_extension_entry_files: absolute_path: #{absolute_path}")
        if File.exist? absolute_path
          Util.load_file_path(file_path)
        else
          @logger.debug("load_extension_entry_files: #{file_path} does not exist, ignored.")
        end
      end
    end


    def process(settings)
      @processorsManager.process(settings)
    end

    def require_teracy_dev_version(*requirements)
      if !Util.require_version_valid?(TeracyDev::VERSION, *requirements)
        @@logger.error("teracy-dev's current version: #{VERSION}")
        @@logger.error("`#{requirements}` is required, make sure to update teracy-dev to satisfy the requirements.")
        abort
      end
    end

    def configure(settings, config, type:)
      @configManager.configure(settings, config, type: type)
    end


    def configure_vagrant(settings)
      Vagrant.configure("2") do |common|

        configure(settings, common, type: 'common')

        settings['nodes'].each do |node_settings|
          primary = node_settings['primary'] ||= false
          autostart = node_settings['autostart'] === false ? false : true
          common.vm.define node_settings['name'], primary: primary, autostart: autostart do |node|
            configure(node_settings, node, type: 'node')
          end
        end
      end
    end

  end
end
