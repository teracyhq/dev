require 'yaml'

require_relative '../logging'
require_relative '../util'
require_relative '../extension/manager'

module TeracyDev
  module Settings
    class Manager

      @@instance = nil

      def initialize
        if !!@@instance
          raise "TeracyDev::Settings::Manager can only be initialized once"
        end
        @@instance = self
        @logger = Logging.logger_for(self.class.name)
        @extensionManager = Extension::Manager.new
      end

      # build teracy-dev, entry extension and extensions setting levels
      # then override: entry extension => extensions => teracy-dev
      # the latter extension will override the former one to build extensions settings
      def build_settings(entry_dir_path)

        @logger.debug("entry_dir_path: #{entry_dir_path}")
        teracy_dev_settings = build_teracy_dev_settings()
        entry_settings = build_entry_settings(entry_dir_path)
        # we use extensions config from entry overriding teracy-dev only to install and validate
        entry_extensions = Util.override(teracy_dev_settings, entry_settings)['teracy-dev']['extensions']
        @logger.debug("entry_extensions: #{entry_extensions}")
        @extensionManager.install(entry_extensions)

        extensions_settings = build_extensions_settings(entry_extensions)

        settings = Util.override(teracy_dev_settings, extensions_settings)
        @logger.debug("override(teracy_dev_settings, extensions_settings): #{settings}")

        settings = Util.override(settings, entry_settings)
        @logger.debug("override(settings, entry_settings): #{settings}")
        settings
      end

      private

      def build_teracy_dev_settings()
        config_file_path = File.join(File.dirname(__FILE__), '../../../config.yaml')
        settings = Util.load_yaml_file(config_file_path)
        @logger.debug("settings: #{settings}")
        settings
      end


      def build_entry_settings(lookup_dir)
        config_default_file_path = File.join(lookup_dir, 'config_default.yaml')
        settings = Util.build_settings_from(config_default_file_path)
        @logger.debug("settings: #{settings}")
        settings
      end


      def build_extensions_settings(extensions)
        @logger.debug("extensions: #{extensions}")
        extensions_settings = []
        extensions.each do |extension|
          next if extension['enabled'] != true
          lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] ||= DEFAULT_EXTESION_LOOKUP_PATH)
          path = File.join(lookup_path, extension['path']['extension'])
          extensions_settings << Util.build_settings_from(File.join(path, 'config_default.yaml'))
        end
        settings = {}
        extensions_settings.reverse_each do |extension_settings|
          settings = Util.override(extension_settings, settings)
        end
        @logger.debug("settings: #{settings}")
        settings
      end

    end
  end
end
