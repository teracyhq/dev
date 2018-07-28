require 'yaml'

require_relative '../logging'
require_relative '../util'

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
      end

      # build teracy-dev, entry extension and extensions setting levels
      # then override extensions => entry extension => teracy-dev
      # the latter extension will override the former one to build extensions settings
      def build_settings(entry_dir_path)
        @logger.debug("build_settings: #{entry_dir_path}")
        teracy_dev_settings = build_teracy_dev_settings()
        entry_settings = build_entry_settings(entry_dir_path)
        extensions_settings = build_extensions_settings(entry_settings)
        settings = Util.override(entry_settings, extensions_settings)
        @logger.debug("override(entry_settings, extensions_settings): #{settings}")
        settings = Util.override(teracy_dev_settings, settings)
        @logger.debug("override(teracy_dev_settings, settings): #{settings}")
        # create nodes by overrides each node with the default
        settings["nodes"].each_with_index do |node, index|
          settings["nodes"][index] = Util.override(settings['default'], node)
        end
        @logger.debug("final: #{settings}")
        settings
      end

      private

      def build_teracy_dev_settings()
        config_file_path = File.join(File.dirname(__FILE__), '../../../config.yaml')
        settings = load_yaml_file(config_file_path)
        @logger.debug("build_teracy_dev_settings: #{settings}")
        settings
      end


      def build_entry_settings(lookup_dir)
        config_default_file_path = File.join(File.dirname(__FILE__), '../../../', lookup_dir, 'config_default.yaml')
        settings = build_settings_from(config_default_file_path)
        @logger.debug("build_entry_settings: #{settings}")
        settings
      end

      def build_extensions_settings(entry_settings)
        if !Util.exist? entry_settings['teracy-dev'] or !Util.exist? entry_settings['teracy-dev']['extensions']
          return {}
        end
        extensions = entry_settings["teracy-dev"]["extensions"]
        @logger.debug("build_extensions_settings: #{extensions}")
        extensions_settings = []
        extensions.each do |extension|
          next if extension['enabled'] != true
          validate_extension(extension)
          absolute_path = File.join(File.dirname(__FILE__), '../../../', extension['path'], 'config_default.yaml')
          extensions_settings << build_settings_from(absolute_path)
        end

        settings = {}
        extensions_settings.reverse_each do |extension_settings|
          settings = Util.override(extension_settings, settings)
        end
        @logger.debug("build_extensions_settings: #{settings}")
        settings
      end


      def build_settings_from(default_file_path)
        @logger.debug("build_settings_from default file path: '#{default_file_path}'")
        override_file_path = default_file_path.gsub(/default\.yaml$/, "override.yaml")
        default_settings = load_yaml_file(default_file_path)
        @logger.debug("build_settings_from default_settings: #{default_settings}")
        override_settings = load_yaml_file(override_file_path)
        @logger.debug("build_settings_from override_settings: #{override_settings}")
        settings = Util.override(default_settings, override_settings)
        @logger.debug("build_settings_from final: #{settings}")
        settings
      end


      def load_yaml_file(file_path)
        if File.exist? file_path
          # TODO: exception handling
          result = YAML.load(File.new(file_path))
          if result == false
            @logger.debug("load_yaml_file: #{file_path} is empty")
            result = {}
          end
          result
        else
          @logger.debug("load_yaml_file: #{file_path} does not exist")
          {}
        end
      end

      def validate_extension(extension)
        @logger.debug("validate_extension: #{extension}")
        absolute_path = File.join(File.dirname(__FILE__), '../../../', extension['path'])

        # extension does exists, load the meta info and check the version requirements
        if File.exist? absolute_path
          validate_extension_meta(extension)
        else
          # extension path does not exist, check if it's required
          # if required, send error message and abort
          # otherwise, send a warning message
          required = extension['required'] || false
          if required == true
            @logger.error("This extension is required but its path does not exist: #{extension}")
            abort
          else
            @logger.warn("This extension's path does not exist, make sure it's intented: #{extension}")
          end
        end

      end

      def validate_extension_meta(extension)
        meta_path = File.join(File.dirname(__FILE__), '../../../', extension['path'], 'meta.yaml')

        if File.exist? meta_path
          meta = load_yaml_file(meta_path)
          if !Util.exist?(meta['name']) or !Util.exist?(meta['version'])
            @logger.error("The extension meta's name and version must be defined: #{meta}, #{extension}")
            abort
          end
          # check the version requirement
          if !Util.require_version_valid?(meta['version'], extension['require_version'])
            @logger.error("`#{extension['require_version']}` is required, but current `#{meta['version']}`: #{extension}")
            @logger.error("The current extension version must be updated to satisfy the requirements above")
            abort
          end

          # check if teracy-dev version satisfies the meta['target'] if specified
          if Util.exist?(meta['target']) and !Util.require_version_valid?(TeracyDev::VERSION, meta['target'])
            @logger.error("teracy-dev's current version: #{TeracyDev::VERSION}")
            @logger.error("this extension requires teracy-dev version: #{meta['target']} (#{extension})")
            abort
          end
        else
          @logger.error("#{meta_path} must exist for this extension: #{extension}")
          abort
        end
      end
    end
  end
end
