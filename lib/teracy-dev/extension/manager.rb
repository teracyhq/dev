require_relative '../location/manager'
require_relative '../util'

module TeracyDev
  module Extension
    class Manager
      def self.manifest(extension)
        extension_lookup_path = extension['path']['lookup']
        extension_lookup_path ||= TeracyDev::DEFAULT_EXTENSION_LOOKUP_PATH
        lookup_path = File.join(TeracyDev::BASE_DIR, extension_lookup_path)
        path = File.join(lookup_path, extension['path']['extension'])
        manifest_path = File.join(path, 'manifest.yaml')
        YAML.load_file(manifest_path)
      end

      def initialize
        @logger = Logging.logger_for(self.class.name)
      end

      def install(extensions)
        @logger.debug("extensions: #{extensions}")
        timer_start = Time.now
        extensions.each do |extension|
          if Util.true?(extension['enabled'])
            sync(extension)
            validate(extension)
          end
        end

        ext_manifest_list = extensions.map { |x| Manager.manifest(x) if Util.true?(x['enabled']) }
        # returns a copy of self with all nil elements removed.
        ext_manifest_list.compact!

        extensions.each do |extension|
          validate_dependencies(extension, ext_manifest_list) if Util.true?(extension['enabled'])
        end
        timer_end = Time.now

        finished_time = timer_end - timer_start
        @logger.debug("installation finished in #{finished_time}s of extensions: #{extensions}")
      end

      private

      def sync(extension)
        return unless Util.true?(extension['enabled'])

        unless Util.exist?(extension['path']['extension'])
          @logger.error("#{extension} must have path.extension, " \
            'please set path.extension then reload again')
          abort
        end

        ext_lookup_path = extension['path']['lookup']
        ext_lookup_path ||= DEFAULT_EXTENSION_LOOKUP_PATH
        lookup_path = File.join(TeracyDev::BASE_DIR, ext_lookup_path)
        path = File.join(lookup_path, extension['path']['extension'].split('/')[0])
        location = {
          'lookup_path' => lookup_path,
          'path' => path
        }
        extension['location'].merge!(location)
        sync_existing = extension['path']['lookup'] == DEFAULT_EXTENSION_LOOKUP_PATH

        Location::Manager.sync(extension['location'], sync_existing)
      end

      def validate(extension)
        return unless Util.true?(extension['enabled'])

        begin
          manifest = Manager.manifest(extension)
        rescue Errno::ENOENT
          @logger.error("manifest for extension #{extension['path']['extension']} not found, " \
            "seem that you haven't synced all the required extensions. " \
            'Please run vagrant <status|up|reload> to sync them first')
          abort
        end

        if !Util.exist?(manifest['name']) || !Util.exist?(manifest['version'])
          @logger.error("The extension manifest's name and version " \
            "must be defined: #{manifest}, #{extension}")
          abort
        end
        # check the version requirement
        unless Util.require_version_valid?(manifest['version'], extension['require_version'])
          @logger.error("`#{extension['require_version']}` is required, " \
            "but current `#{manifest['version']}`: #{extension}")
          @logger.error('The current extension version must be updated ' \
            'to satisfy the requirements above')
          abort
        end

        # check if teracy-dev version satisfies the manifest['target'] if specified
        return unless Util.exist?(manifest['target'])

        return if Util.require_version_valid?(TeracyDev::VERSION, manifest['target'])

        @logger.error("teracy-dev's current version: #{TeracyDev::VERSION}")
        @logger.error('this extension requires teracy-dev version: ' \
          "#{manifest['target']} (#{extension})")
        abort
      end

      def validate_dependencies(extension, extention_manifest_list)
        extension_manifest = Manager.manifest(extension)
        return unless Util.exist?(extension_manifest['dependencies'])

        extension_manifest['dependencies'].each do |dependency|
          found = extention_manifest_list.find { |x| x['name'] == dependency['name'] }
          if found.nil?
            @logger.error("the extension #{dependency['name']} is required by " \
              "#{extension_manifest['name']} but could not be found.")
            abort
          end

          next if Util.require_version_valid?(found['version'], dependency['require_version'])

          @logger.error("the extension #{dependency['name']} " \
            "#{dependency['require_version']} is required by " \
          "#{extension_manifest['name']} but found version #{found['version']}")
          abort
        end
      end
    end
  end
end
