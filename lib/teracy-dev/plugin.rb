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

          unless plugin['plugin_vars'].nil?
            install_plugin_by_cmd(plugin, logger)
          else
            if plugin['sources'].nil? or plugin['sources'].empty?
              plugin['sources'] = [
                "https://rubygems.org/",
                "https://gems.hashicorp.com/"
              ]
            end

            plugin_manager.install_plugin(plugin['name'], Util.symbolize(plugin))
          end

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

    private

    def self.cmd_install_plugin(plugin_vars, plugin_to_install, command_opts)
      cmd = ''

      plugin_vars.each do |key, val|
        key = key.to_s.upcase
        val = val.to_s

        cmd << "#{key}='#{val}' "
      end

      cmd << "vagrant plugin install #{plugin_to_install}"

      unless command_opts.empty?
        command_opts.each do |key, val|
          key = key.to_s
          val = val.to_s

          if val.empty?
            cmd << " --#{key}"
          else
            cmd << " --#{key}='#{val}'"
          end
        end
      end

      cmd
    end

    def self.install_plugin_by_cmd(plugin, logger)
      logger.info("installing vagrant plugin by command...")
      plugin_to_install = plugin['name']

      unless plugin_to_install.empty?
        command_opts = ''
        command_opts = plugin['command_opts'] if !plugin['command_opts'].nil?

        cmd = cmd_install_plugin(plugin['plugin_vars'], plugin_to_install, command_opts)
        logger.info("Command install: #{cmd}")

        if cmd.empty?
          abort "Installation of plugin has failed. Command is empty..."
        end

        unless system cmd
          abort "Installation of plugin has failed. Aborting..."
        end
      end
    end
  end
end
