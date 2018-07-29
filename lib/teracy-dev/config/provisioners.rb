require_relative 'provision_settings'
require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/provisioning/
    class Provisioners < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          provisioners_settings = settings['provisioners']
        end
        provisioners_settings ||= []
        @logger.debug("configure #{type}: #{provisioners_settings}")

        provisioners_settings.each do |provisioner_settings|
          @logger.info("provisioner ignored: #{provisioner_settings}") if provisioner_settings['enabled'] != true
          next if provisioner_settings['enabled'] != true

          type = provisioner_settings['type']
          run = 'once'
          preserve_order = false
          if !provisioner_settings['run'].nil?
            run = provisioner_settings['run'] # one of: once, always, or never
          end
          if provisioner_settings['preserve_order'] == true
            preserve_order = true
          end

          if provisioner_settings['name'].nil?
            config.vm.provision "#{type}", run: run, preserve_order: preserve_order do |provision|
              ProvisionSettings.configure(type, provision, provisioner_settings)
            end
          else
            config.vm.provision provisioner_settings['name'], type: type, run: run, preserve_order: preserve_order do |provision|
              ProvisionSettings.configure(type, provision, provisioner_settings)
            end
          end
        end
      end
    end
  end
end
