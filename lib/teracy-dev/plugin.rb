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

        if !installed_plugins.has_key?(plugin['name']) and plugin['state'] == 'installed'
          logger.info("installing plugin: #{plugin}")

          if plugin['sources'].nil? or plugin['sources'].empty?
            plugin['sources'] = [
              "https://rubygems.org/",
              "https://gems.hashicorp.com/"
            ]
          end

          plugin_manager.install_plugin(plugin['name'], Util.symbolize(plugin))
          reload_required = true
        end

        if installed_plugins.has_key?(plugin['name']) and plugin['state'] == 'uninstalled'
          logger.info("uninstalling plugin: #{plugin['name']}")
          plugin_manager.uninstall_plugin(plugin['name'])
          reload_required = true
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
