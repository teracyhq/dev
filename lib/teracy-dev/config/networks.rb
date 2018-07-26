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
        end
        networks_settings ||= []
        @logger.debug("configure #{type}: #{networks_settings}")
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

              bridge_interface = ''
              bridge_interface = vm_network['bridge'] unless vm_network['bridge'].nil? or vm_network['bridge'].empty?
              bridge_interface = get_default_nic() if bridge_interface.empty? and vm_network['auto_bridge_default_network']
              options[:bridge] = bridge_interface unless bridge_interface.empty?

              if vm_network['reuse_mac_address']
                public_mac_address_path = File.join(File.dirname(__FILE__), '../../../', '.vagrant/.public_mac_address')
                if File.exist?(public_mac_address_path)
                  options[:mac] = File.read(public_mac_address_path).gsub(/[\s:\n]/,'')
                else
                  FileUtils::touch public_mac_address_path
                end
              else
                if File.exist? public_mac_address_path
                  FileUtils.rm public_mac_address_path
                end
              end
            end

            config.vm.network vm_network['mode'], options
          end
        end
      end

      private

      def get_default_nic()
        default_interface = ""
        if Vagrant::Util::Platform.windows?
            default_interface = %x[wmic.exe nic where "NetConnectionStatus=2" get NetConnectionID | more +1]
            default_interface = default_interface.strip
        elsif Vagrant::Util::Platform.linux?
            default_interface = %x[route | grep '^default' | grep -o '[^ ]*$']
            default_interface = default_interface.strip
        elsif Vagrant::Util::Platform.darwin?
            nicName = %x[route -n get 8.8.8.8 | grep interface | awk '{print $2}']
            default_interface = nicName.strip
            nicString = %x[networksetup -listnetworkserviceorder | grep 'Hardware Port' | grep #{default_interface} | awk -F'[:,]' '{print $2}']
            extension = nicString.strip == "Wi-Fi" ? " (AirPort)" : ""
            default_interface = default_interface + ': ' + nicString.strip + extension
        end
        return default_interface
      end
    end
  end
end
