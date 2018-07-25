require_relative '../plugin'
require_relative 'configurator'

module TeracyDev
  module Config
    class Plugins < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          plugins_settings = settings['vagrant']['plugins']
        when 'node'
          plugins_settings = settings['plugins']
        end
        plugins_settings ||= []
        @logger.debug("configure #{type}: #{plugins_settings}")
        Plugin.sync(plugins_settings)
        set_options(plugins_settings, config)
      end

      private

      def set_options(plugins_settings, config)
        plugins_settings.each do |plugin|
          next if !can_proceed(plugin)
          if plugin.key?('config_key')
            config_key = plugin['config_key']
            options = plugin['options']
            @logger.debug("configuring `#{plugin['name']}` with options: #{options}")
            pluginConfig = config.send(config_key.to_sym)
            pluginConfig.set_options(options)
            @logger.debug("configured for #{config_key}: #{pluginConfig.inspect}")
          end
        end
      end

      # check if plugin is installed and enabled to proceed
      def can_proceed(plugin)
          plugin_name = plugin['name']

          if !Plugin.installed?(plugin_name)
            @logger.warn("#{plugin_name} is not installed")
            return false
          end

          if plugin['enabled'] != true
            @logger.info("#{plugin_name} is installed but not enabled so its settings is ignored")
            return false
          end
          return true
      end
    end
  end
end
