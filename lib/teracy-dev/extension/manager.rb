module TeracyDev
  module Extension
    class Manager
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
        lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] || 'extensions')
        path = File.join(lookup_path, extension['path']['extension'])
        git = extension['location']['git'] # maybe we'll support for protocols
        branch = extension['location']['tag'] || extension['location']['branch']
        ref = extension['location']['ref'] # TODO: support sync to a specific revision

        @logger.debug("path: #{path}")

        if File.exist? path
          # TODO: make sure the extention is always at the correct latest state
          # up to date branch; up to date tag, etc.
        else
          # sync bases on the location specification
          if git != nil
            if Vagrant::Util::Which.which('git') == nil
              @logger.error("git is not avaiable")
            end
            Dir.chdir(lookup_path) do
              @logger.info("cd #{lookup_path} && git clone #{git} -b #{branch} --single-branch --depth=1")
              system("git clone #{git} -b #{branch} --single-branch --depth=1")
            end
          end
        end
      end

      def validate(extension)
        return if extension['enabled'] != true
        lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] || 'extensions')
        path = File.join(lookup_path, extension['path']['extension'])
        manifest_path = File.join(path, 'manifest.yaml')

        if File.exist? manifest_path
          manifest = Util.load_yaml_file(manifest_path)
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
        else
          @logger.error("#{manifest_path} must exist for this extension: #{extension}")
          abort
        end
      end

    end
  end
end
