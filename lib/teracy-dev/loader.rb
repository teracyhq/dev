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

    attr_reader :processorsManager, :configManager, :settings

    def initialize
      if !!@@instance
        raise "TeracyDev::Loader can only be initialized once"
      end
      @@instance = self
      @logger = Logging.logger_for(self.class.name)
    end

    def start
      @processorsManager = Processors::Manager.new
      @configManager = Config::Manager.new
      @settings = build_settings().freeze
      require_teracy_dev_version(settings['teracy-dev']['require_version'])
      configure_vagrant(settings)
    end

    private

    def build_settings
      extension_entry_path = File.join(TeracyDev::BASE_DIR, TeracyDev::EXTENSION_ENTRY_PATH)
      settingsManager = Settings::Manager.new
      settings = settingsManager.build_settings(extension_entry_path)
      load_extension_entry_files(settings)
      settings = process(settings)
      # updating nodes here so that processors have change to adjust nodes by adjusting default
      # create nodes by overrides each node with the default
      @logger.debug("settings: #{settings}")
      settings["nodes"].each_with_index do |node, index|
        settings["nodes"][index] = Util.override(settings['default'], node)
      end
      @logger.debug("final: #{settings}")
      settings
    end


    def load_extension_entry_files(settings)
      @logger.debug("load_extension_entry_files: #{settings}")
      extensions = settings['teracy-dev']['extensions'] ||= []
      extensions.each do |extension|
        next if extension['enabled'] != true
        lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] || 'extensions')
        path = File.join(lookup_path, extension['path']['extension'])
        entry_file_path = File.join(path, 'teracy-dev-ext.rb')
        @logger.debug("load_extension_entry_files: entry_file_path: #{entry_file_path}")
        if File.exist? entry_file_path
          Util.load_file_path(entry_file_path)
        else
          @logger.debug("load_extension_entry_files: #{entry_file_path} does not exist, ignored.")
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
