require_relative 'logging'
require_relative 'util'

module TeracyDev
  class Plugin
    # install or uninstall plugins bases on the plugins config
    def self.sync(plugins)
      logger = TeracyDev::Logging.logger_for(self)
      plugins ||= []
      plugin_manager = Vagrant::Plugin::Manager.instance
      installed_plugins = plugin_manager.installed_plugins

      # reload_required when any plugin is installed/uninstalled
      reload_required = false

      plugins.each do |plugin|

        unless Util.exist? plugin['name']
          logger.warn("Plugin name must be configured for #{plugin}")
          next
        end

        case plugin['state']
        when 'installed'
          if installed_plugins.empty?
            unless Util.exist? plugin['sources']
              plugin['sources'] = [
                "https://rubygems.org/",
                "https://gems.hashicorp.com/"
              ]
            end
          end

          if !installed_plugins.has_key?(plugin['name'])
            logger.info("installing plugin: #{plugin}")
            plugin_manager.install_plugin(plugin['name'], Util.symbolize(plugin))
            reload_required = true
          end
        when 'uninstalled'
          if installed_plugins.has_key?(plugin['name'])
            logger.info("uninstalling plugin: #{plugin}")
            plugin_manager.uninstall_plugin(plugin['name'])
            reload_required = true
          end
        else
          logger.debug("The plugin state is not set, no action will be taken for #{plugin}")
        end
      end

      if reload_required
        logger.info("reloading...")
        exec "vagrant #{ARGV.join(" ")}"
      end
    end

    def self.installed?(plugin_name)
      return Vagrant.has_plugin?(plugin_name)
    end
  end
end
