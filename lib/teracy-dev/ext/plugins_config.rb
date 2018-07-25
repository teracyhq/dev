require_relative '../logging'
require_relative '../plugin'
require_relative '../util'
require_relative '../config/configurator'

module TeracyDev
  module Ext
    # some workaround that should not be in core
    class PluginsConfig < TeracyDev::Config::Configurator


      def configure(settings, config, type:)
        case type
        when 'common'
          plugins_settings = settings['vagrant']['plugins']
        when 'node'
          # ignore
        end
        plugins_settings ||= []
        @logger.debug("configure #{type}: #{plugins_settings}")

        plugins_settings.each do |plugin|

          next if !can_proceed(plugin)

          if plugin.key?('config_key')
            config_key = plugin['config_key']
            options = plugin['options']

            case config_key
            when "hostmanager"
              configure_hostmanager(options, config)
            end
          end
        end
      end


      private

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


      def configure_hostmanager(options, config)
        @logger.debug("configure_common_hostmanager: #{options}")
        # conflict potential
        if Plugin.installed?('vagrant-hostsupdater')
          @logger.warn('conflict potential, recommended: $ vagrant plugin uninstall vagrant-hostsupdater')
        end

        # workaround for :public_network
        # maybe this will not work with :private_network
        config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
          #FIXME: make this work with different network settings instead
          read_ip_address(vm)
        end
      end


      # thanks to https://github.com/devopsgroup-io/vagrant-hostmanager/issues/121#issuecomment-69050265
      def read_ip_address(machine)
        command = "LANG=en ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1 }'"
        result  = ""

        @logger.debug("_read_ip_address: #{machine.name}... ")

        begin
          # sudo is needed for ifconfig
          machine.communicate.sudo(command) do |type, data|
            result << data if type == :stdout
          end
          @logger.debug("_read_ip_address: #{machine.name}... success")
        rescue
          result = "# NOT-UP"
          @logger.warn("_read_ip_address: #{machine.name}... not running")
        end
        # the second inet is more accurate
        result.chomp.split("\n").last
      end
    end
  end
end
