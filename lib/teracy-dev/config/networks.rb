require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/networking/
    class Networks < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          networks_settings = settings['vm']['networks']
          configure_networks(networks_settings)
        end
      end

      def configure_networks(networks_settings)
        networks_settings ||= []
        @logger.debug("configure_networks: #{networks_settings}")
        networks_settings.each do |vm_network|
          if vm_network['mode'] == 'forwarded_port'
            vm_network['forwarded_ports'].each do |item|
              config.vm.network :forwarded_port, guest: item['guest'], host: item['host']
            end
          else
            options = {}
            case vm_network['mode']
            when 'private_network'
              options[:ip] = vm_network['ip'] unless vm_network['ip'].nil? or vm_network['ip'].strip().empty?
              if options[:ip].nil? or options[:ip].empty?
                # make `type: 'dhcp'` default when `ip` is not defined (nil or empty)
                options[:type] = 'dhcp'
              else
                options[:auto_config] = !(vm_network['auto_config'] == false)
              end
            when 'public_network'
              options[:ip] = vm_network['ip'] unless vm_network['ip'].nil? or vm_network['ip'].strip().empty?
              options[:bridge] = vm_network['bridge'] unless vm_network['bridge'].nil? or vm_network['bridge'].empty?
            end
            config.vm.network vm_network['mode'], options
          end
        end
      end

    end
  end
end
