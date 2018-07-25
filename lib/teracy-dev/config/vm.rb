require_relative 'configurator'

module TeracyDev
  module Config
    # set configuration for VM from the vm provided vm settings hash
    # see: https://www.vagrantup.com/docs/vagrantfile/machine_settings.html
    class VM < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          vm_settings = settings['vm']
        end
        vm_settings ||= {}
        @logger.debug("configure #{type}: #{vm_settings}")

        config.vm.box = vm_settings["box"]
        config.vm.box_url = vm_settings["box_url"]
        if !vm_settings["box_version"].nil? and !vm_settings["box_version"].strip().empty?
          config.vm.box_version = vm_settings['box_version']
        end

        if !vm_settings["boot_timeout"].nil?
          config.vm.boot_timeout = vm_settings['boot_timeout']
        end

        if !vm_settings["box_check_update"].nil?
          config.vm.box_check_update = vm_settings['box_check_update']
        end

        if !vm_settings["box_download_checksum"].nil? and !vm_settings["box_download_checksum"].strip().empty?
          config.vm.box_download_checksum = vm_settings['box_download_checksum']

          # box_download_checksum_type must be specified if box_download_checksum is specified
          config.vm.box_download_checksum_type = vm_settings['box_download_checksum_type']
        end

        if !vm_settings["box_download_client_cert"].nil? and !vm_settings["box_download_client_cert"].strip().empty?
          config.vm.box_download_client_cert = vm_settings['box_download_client_cert']
        end

        if !vm_settings["box_download_ca_cert"].nil? and !vm_settings["box_download_ca_cert"].strip().empty?
          config.vm.box_download_ca_cert = vm_settings['box_download_ca_cert']
        end

        if !vm_settings["box_download_ca_path"].nil? and !vm_settings["box_download_ca_path"].strip().empty?
          config.vm.box_download_ca_path = vm_settings['box_download_ca_path']
        end

        if !vm_settings["box_download_insecure"].nil?
          config.vm.box_download_insecure = vm_settings['box_download_insecure']
        end

        if !vm_settings["communicator"].nil? and !vm_settings["communicator"].strip().empty?
          config.vm.communicator = vm_settings['communicator']
        end

        if !vm_settings["graceful_halt_timeout"].nil?
          config.vm.graceful_halt_timeout = vm_settings['graceful_halt_timeout']
        end

        if !vm_settings["guest"].nil? and !vm_settings["guest"].strip().empty?
          config.vm.guest = vm_settings['guest']
        end

        if !vm_settings["hostname"].nil? and !vm_settings["hostname"].strip().empty?
          config.vm.hostname = vm_settings['hostname']
        end

        if !vm_settings["post_up_message"].nil? and !vm_settings["post_up_message"].strip().empty?
          config.vm.post_up_message = vm_settings['post_up_message']
        end

        if !vm_settings["usable_port_range"].nil? and !vm_settings["usable_port_range"].strip().empty?
          ranges = vm_settings['usable_port_range'].split('..').map{|d| Integer(d)}
          config.vm.usable_port_range = ranges[0]..ranges[1]
        end
      end
    end
  end
end