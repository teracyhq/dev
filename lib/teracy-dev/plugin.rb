require_relative 'logging'
require_relative 'util'

module TeracyDev
  class Plugin
    @logger = Logging.logger_for(self)

    # install or uninstall plugins bases on the plugins config
    def self.sync(plugins)
      plugins ||= []
      plugin_manager = Vagrant::Plugin::Manager.instance
      installed_plugins = plugin_manager.installed_plugins

      # reload_required when any plugin is installed/uninstalled
      reload_required = false

      plugins.each do |plugin|
        unless Util.exist? plugin['name']
          @logger.warn("Plugin name must be configured for #{plugin}")
          next
        end

        case plugin['state']
        when 'installed'
          if installed_plugins.empty?
            unless Util.exist? plugin['sources']
              plugin['sources'] = [
                'https://rubygems.org/',
                'https://gems.hashicorp.com/'
              ]
            end
          end
          # if the plugin is installed with global or local mode, it will not be installed
          unless installed?(plugin['name'])
            @logger.info("installing plugin: #{plugin}")
            retry_times = 0
            begin
              plugin_manager.install_plugin(plugin['name'], Util.symbolize(plugin))
              reload_required = true
            rescue
              retry_times += 1
              if retry_times <= 5 # retry only 5 times, # TODO: add utility for retry x times
                @logger.warn('failed to install plugin: ' \
                "'#{plugin['name']}', retrying#{'.'*retry_times}")
                retry
              end
              @logger.error("failed to install plugin: '#{plugin['name']}', please try again.")
              abort
            end
          end
        when 'uninstalled'
          if plugin_installed?(plugin)
            @logger.info("uninstalling plugin: #{plugin}")
            # plugin_manager.uninstall_plugin(plugin['name'])
            if Util.true? plugin['env_local']
              system("vagrant plugin uninstall #{plugin['name']} --local")
            else
              system("vagrant plugin uninstall #{plugin['name']}")
            end
            if $CHILD_STATUS.exitstatus.zero?
              reload_required = true
            else
              @logger.warn("failed to uninstall plugin: #{plugin}")
            end
          end
        else
          @logger.debug("The plugin state is not set, no action will be taken for #{plugin}")
        end
      end

      return unless reload_required

      @logger.info('reloading...')
      exec "vagrant #{ARGV.join(' ')}"
    end

    def self.installed?(plugin_name)
      return Vagrant.has_plugin?(plugin_name)
    end

    # check if the plugin is installed (by its name and env_local)
    def self.plugin_installed?(plugin)
      plugin_manager = Vagrant::Plugin::Manager.instance
      installed_plugins = plugin_manager.installed_plugins
      installed_plugin = installed_plugins[plugin['name']]
      return false if installed_plugin.nil?

      plugin['env_local'] ||= false
      return installed_plugin['env_local'] == plugin['env_local']
    end

    private_class_method :plugin_installed?
  end
end
