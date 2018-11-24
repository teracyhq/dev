require 'yaml'

require_relative 'logging'
require_relative 'plugin'
require_relative 'util'
require_relative 'version'
require_relative 'processors/manager'
require_relative 'config/manager'
require_relative 'settings/manager'
require_relative 'location/manager'

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
      @settingsManager = Settings::Manager.new
      @extension_entry_path = File.join(TeracyDev::BASE_DIR, TeracyDev::EXTENSION_ENTRY_PATH)
      # we sync teracy-dev and teracy-dev-entry before extensions
      sync()
      settings = build_settings().freeze
      require_vagrant_version(settings['vagrant']['require_version']) if TeracyDev::Util.exist?(settings['vagrant']['require_version'])
      require_teracy_dev_version(settings['teracy-dev']['require_version'])
      configure_vagrant(settings)
    end

    private

    def sync
      # teracy_dev_location and teracy_dev_entry_location is built from teracy-dev and teracy-dev-entry settings
      # with the override mechanism
      # extensions settings for these syncs are not accepted
      teracy_dev_settings = @settingsManager.build_teracy_dev_settings()
      entry_settings = @settingsManager.build_entry_settings(@extension_entry_path)
      settings = Util.override(teracy_dev_settings, entry_settings)
      @logger.debug("settings: #{settings}")
      sync_teracy_dev(settings['teracy-dev']['location'])
      sync_teracy_dev_entry(settings['teracy-dev']['entry_location'])
    end

    def sync_teracy_dev(location)
      location.merge!({
        "path" => TeracyDev::BASE_DIR
      })
      @logger.debug("location: #{location}")

      if Util.true?(location['sync'])
        if Location::Manager.sync(location) == true
          # reload
          @logger.info("reloading...")
          exec "vagrant #{ARGV.join(" ")}"
        end
      end
    end

    def sync_teracy_dev_entry(location)
      path = @extension_entry_path
      lookup_path = TeracyDev::EXTENSION_ENTRY_PATH.split('/')[0..-2].join('/')
      lookup_path = File.join(TeracyDev::BASE_DIR, lookup_path)
      dir = TeracyDev::EXTENSION_ENTRY_PATH.split('/').last

      location.merge!({
        "lookup_path" => lookup_path,
        "path" => path,
      })

      # override/init with env vars if available
      # this is useful to init the teracy-dev-entry or to override existing settings to enable auto sync
      # TERACY_DEV_ENTRY_LOCATION_GIT_REMOTE_ORIGIN, TERACY_DEV_ENTRY_LOCATION_GIT_BRANCH
      # TERACY_DEV_ENTRY_LOCATION_GIT_REF, TERACY_DEV_ENTRY_LOCATION_SYNC
      git_remote_origin = ENV['TERACY_DEV_ENTRY_LOCATION_GIT_REMOTE_ORIGIN'] || ENV['TERACY_DEV_ENTRY_LOCATION_GIT']
      git_branch = ENV['TERACY_DEV_ENTRY_LOCATION_GIT_BRANCH'] || ENV['TERACY_DEV_ENTRY_LOCATION_BRANCH']
      git_ref = ENV['TERACY_DEV_ENTRY_LOCATION_GIT_REF'] || ENV['TERACY_DEV_ENTRY_LOCATION_REF']
      git_tag = ENV['TERACY_DEV_ENTRY_LOCATION_GIT_TAG'] || ENV['TERACY_DEV_ENTRY_LOCATION_TAG']
      sync = ENV['TERACY_DEV_ENTRY_LOCATION_SYNC']

      deprecated_env = [
        'TERACY_DEV_ENTRY_LOCATION_GIT', 'TERACY_DEV_ENTRY_LOCATION_BRANCH',
        'TERACY_DEV_ENTRY_LOCATION_TAG', 'TERACY_DEV_ENTRY_LOCATION_REF'
      ]

      if (deprecated_env & ENV.keys).any?
        @logger.warn("deprecated: #{deprecated_env & ENV.keys}, please use this format instead: TERACY_DEV_ENTRY_LOCATION_GIT_<REMOTE_ORIGIN|BRANCH|TAG|REF>")
      end

      location['git'] ||= ''

      if location['git'].instance_of? String
        location['git'] = {
          "remote" => {
            "origin" => location['git']
          }
        }
      end

      location['git']['remote']['origin'] = git_remote_origin if git_remote_origin

      git_config = {}

      git_config['branch'] = git_branch if git_branch
      git_config['tag'] = git_tag if git_tag
      git_config['ref'] = git_ref if git_ref
      git_config['dir'] = dir if dir

      location['sync'] = sync if sync

      location['git'].merge!(git_config)

      @logger.debug("location: #{location}")

      # because teracy-dev.entry_location is optional, so if not configured, just continue
      if location['git']['remote']['origin'] == nil
        return
      end

      if Location::Manager.sync(location, location['sync']) == true
        # reload
        @logger.info("reloading...")
        exec "vagrant #{ARGV.join(" ")}"
      end
    end

    def build_settings
      settings = @settingsManager.build_settings(@extension_entry_path)
      load_extension_entry_files(settings)
      settings = process(settings)
      # updating nodes here so that processors have change to adjust nodes by adjusting default
      # create nodes by overrides each node with the default
      @logger.debug("settings: #{settings}")
      settings["nodes"].each_with_index do |node, index|
        settings["nodes"][index] = Util.override(settings['default'], node)
      end
      if Util.true?(ENV['LOG_SETTINGS_YAML'])
        @logger.debug("final settings: \n #{settings.to_yaml}")
      else
        @logger.debug("final settings: #{settings}")
      end
      settings
    end

    def load_extension_entry_files(settings)
      @logger.debug("settings: #{settings}")
      extensions = settings['teracy-dev']['extensions'] ||= []
      extensions.each do |extension|
        next unless Util.true?(extension['enabled'])
        lookup_path = File.join(TeracyDev::BASE_DIR, extension['path']['lookup'] ||= DEFAULT_EXTENSION_LOOKUP_PATH)
        path = File.join(lookup_path, extension['path']['extension'])
        entry_file_path = File.join(path, 'teracy-dev-ext.rb')
        @logger.debug("entry_file_path: #{entry_file_path}")
        if File.exist? entry_file_path
          Util.load_file_path(entry_file_path)
        else
          @logger.debug("#{entry_file_path} does not exist, ignored.")
        end
      end
    end

    def process(settings)
      @processorsManager.process(settings)
    end

    def require_vagrant_version(*requirements)
      vagrant_version = Vagrant::VERSION

      if !Util.require_version_valid?(vagrant_version, *requirements)
        @logger.error("vagrant's current version: #{vagrant_version}")
        @logger.error("`#{requirements}` is required, make sure to update vagrant to satisfy the requirements.")
        abort
      end
    end

    def require_teracy_dev_version(*requirements)
      if !Util.require_version_valid?(TeracyDev::VERSION, *requirements)
        @logger.error("teracy-dev's current version: #{VERSION}")
        @logger.error("`#{requirements}` is required, make sure to update teracy-dev to satisfy the requirements.")
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
