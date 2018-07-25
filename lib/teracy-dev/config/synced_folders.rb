require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/synced-folders/
    class SyncedFolders < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          synced_folders_settings = settings['vm']['synced_folders']
        end
        synced_folders_settings ||= []
        @logger.debug("configure #{type}: #{synced_folders_settings}")

        synced_folders_settings.each do |settings|
          options = {}
          host_os = Vagrant::Util::Platform.platform
          host_os_type = ''

          case host_os
          when /^(mswin|mingw).*/
            host_os_type = 'windows'
          when /^(linux|cygwin).*/
            host_os_type = 'linux'
          when /^(mac|darwin).*/
            host_os_type = 'mac'
          end

          # options from http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
          options[:create] = settings['create'] unless settings['create'].nil?
          options[:disabled] = settings['disabled'] unless settings['disabled'].nil?
          options[:owner] = settings['owner'] unless settings['owner'].nil?
          options[:group] = settings['group'] unless settings['group'].nil?
          options[:mount_options] = settings['mount_options'] unless settings['mount_options'].nil?
          options[:type] = settings['type'] unless settings['type'].nil? or settings['type'] == 'virtual_box'

          case settings['type']
          when 'nfs'
            options[:nfs_export] = settings['nfs_export'] if !!settings['nfs_export'] == settings['nfs_export']
            options[:nfs_udp] = settings['nfs_udp'] if !!settings['nfs_udp'] == settings['nfs_udp']
            options[:nfs_version] = settings['nfs_version'] unless settings['nfs_version'].nil?
          when 'rsync'
            options[:rsync__args] = settings['rsync__args'] unless settings['rsync__args'].nil? or settings['rsync__args'].empty?
            options[:rsync__auto] = settings['rsync__auto'] if !!settings['rsync__auto'] == settings['rsync__auto']
            options[:rsync__chown] = settings['rsync__chown'] if !!settings['rsync__chown'] == settings['rsync__chown']
            options[:rsync__exclude] = settings['rsync__exclude'] unless settings['rsync__exclude'].nil? or settings['rsync__exclude'].empty?
          when 'smb'
            options[:smb_host] = settings['smb_host'] unless settings['smb_host'].nil? or settings['smb_host'].empty?
            options[:smb_password] = settings['smb_password'] unless settings['smb_password'].nil? or settings['smb_password'].empty?
            options[:smb_username] = settings['smb_username'] unless settings['smb_password'].nil? or settings['smb_password'].empty?
          end

          if settings['supports'].nil? or settings['supports'].include?(host_os_type)
            config.vm.synced_folder settings['host'], settings['guest'], options
          end
        end
      end
    end
  end
end
