require_relative '../util'
require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/ssh_settings.html
    class SSH < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          ssh_settings = settings['ssh']
        end
        ssh_settings ||= {}
        @logger.debug("configure #{type}: #{ssh_settings}")

        config.ssh.username = ssh_settings['username'] if Util.exist?(ssh_settings['username'])
        config.ssh.password = ssh_settings['password'] if Util.exist?(ssh_settings['password'])
        config.ssh.host = ssh_settings['host'] if Util.exist?(ssh_settings['host'])
        config.ssh.port = ssh_settings['port'] if Util.exist?(ssh_settings['port'])
        config.ssh.guest_port = ssh_settings['guest_port'] if Util.exist?(ssh_settings['guest_port'])
        config.ssh.private_key_path = ssh_settings['private_key_path'] if Util.exist?(ssh_settings['private_key_path'])
        # FIXME: boolean check here
        config.ssh.keys_only = ssh_settings['keys_only'] if Util.exist?(ssh_settings['keys_only'])
        config.ssh.verify_host_key = ssh_settings['verify_host_key'] if Util.exist?(ssh_settings['verify_host_key'])
        config.ssh.forward_agent = ssh_settings['forward_agent'] if Util.exist?(ssh_settings['forward_agent'])
        config.ssh.forward_x11 = ssh_settings['forward_x11'] if Util.exist?(ssh_settings['forward_x11'])
        config.ssh.forward_env = ssh_settings['forward_env'] if Util.exist?(ssh_settings['forward_env'])
        config.ssh.insert_key = ssh_settings['insert_key'] if Util.exist?(ssh_settings['insert_key'])
        config.ssh.proxy_command = ssh_settings['proxy_command'] if Util.exist?(ssh_settings['proxy_command'])
        config.ssh.pty = ssh_settings['pty'] if Util.exist?(ssh_settings['pty'])
        config.ssh.keep_alive = ssh_settings['keep_alive'] if Util.exist?(ssh_settings['keep_alive'])
        config.ssh.shell = ssh_settings['shell'] if Util.exist?(ssh_settings['shell'])
        config.ssh.epxort_command_template = ssh_settings['epxort_command_template'] if Util.exist?(ssh_settings['epxort_command_template'])
        config.ssh.sudo_command = ssh_settings['sudo_command'] if Util.exist?(ssh_settings['sudo_command'])
        config.ssh.compression = ssh_settings['compression'] if Util.exist?(ssh_settings['compression'])
        config.ssh.dsa_authentication = ssh_settings['dsa_authentication'] if Util.exist?(ssh_settings['dsa_authentication'])
        config.ssh.extra_args = ssh_settings['extra_args'] if Util.exist?(ssh_settings['extra_args'])
      end
    end
  end
end
