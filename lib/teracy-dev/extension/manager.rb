require_relative '../location/manager'
require_relative '../util'

module TeracyDev
  module Extension
    class Manager

      def self.manifest(extension)
        lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] || 'extensions')
        path = File.join(lookup_path, extension['path']['extension'])
        manifest_path = File.join(path, 'manifest.yaml')
        return YAML.load(File.new(manifest_path))
      end

      def initialize
        @logger = Logging.logger_for(self.class.name)
      end

      def install(extensions)
        @logger.debug("install: #{extensions}")
        extensions.each do |extension|
          sync(extension)
          validate(extension)
        end
      end

      private

      def sync(extension)
        return if extension['enabled'] != true
        lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] ||= DEFAULT_EXTENSION_LOOKUP_PATH)
        path = File.join(lookup_path, extension['path']['extension'])
        extension['location'].merge!({
          "lookup_path" => lookup_path,
          "path" => path
        })
        sync_existing = extension['path']['lookup'] == DEFAULT_EXTENSION_LOOKUP_PATH
        Location::Manager.sync(extension['location'], sync_existing)
      end

      def validate(extension)
        return if extension['enabled'] != true
        manifest = Manager.manifest(extension)

        if !Util.exist?(manifest['name']) or !Util.exist?(manifest['version'])
          @logger.error("The extension manifest's name and version must be defined: #{manifest}, #{extension}")
          abort
        end
        # check the version requirement
        if !Util.require_version_valid?(manifest['version'], extension['require_version'])
          @logger.error("`#{extension['require_version']}` is required, but current `#{manifest['version']}`: #{extension}")
          @logger.error("The current extension version must be updated to satisfy the requirements above")
          abort
        end

        # check if teracy-dev version satisfies the manifest['target'] if specified
        if Util.exist?(manifest['target']) and !Util.require_version_valid?(TeracyDev::VERSION, manifest['target'])
          @logger.error("teracy-dev's current version: #{TeracyDev::VERSION}")
          @logger.error("this extension requires teracy-dev version: #{manifest['target']} (#{extension})")
          abort
        end
      end

    end
  end
end
