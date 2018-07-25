require_relative '../logging'
require_relative 'plugins'
require_relative 'vm'
require_relative 'ssh'
require_relative 'winrm'
require_relative 'winssh'
require_relative 'vgrant'
require_relative 'provisioners'
require_relative 'virtualbox_provider'
require_relative 'networks'
require_relative 'synced_folders'

module TeracyDev
  module Config
    # Manage the vagrant configuration from the provided settings hash object
    class Manager

      def initialize
        @logger = TeracyDev::Logging.logger_for('Config::Manager')
        @configurators = []

        # system configurators
        register(Networks.new)
        register(Plugins.new)
        register(VirtualBoxProvider.new)
        register(Provisioners.new)
        register(SSH.new)
        register(SyncedFolders.new)
        register(Vgrant.new)
        register(VM.new)
        register(WinRM.new)
        register(WinSSH.new)
      end

      def register(configurator)
        if !configurator.respond_to?(:configure)
          @logger.warn("configurator #{configurator} must implement configure method, ignored")
          return
        end
        @configurators << configurator
        @logger.debug("configurator: #{configurator} registered")
      end


      def configure(settings, config, type:)
        @logger.debug("start configuring #{type}: #{config} with #{settings}")

        @configurators.each do |configurator|
          configurator.configure(settings, config, type: type)
        end
      end

    end
  end
end
