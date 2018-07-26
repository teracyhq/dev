# -*- mode: ruby -*-
# vi: set ft=ruby :

# steps:
# - init # teracy-dev init
# - build_settings
# - load_extensions
# - process_settings (plugin via TeracyDev.register_processor)
# - configure (plugin via TeracyDev.register_configurator)

# # add ./lib to ruby load path
lib_dir = File.expand_path('./lib', __dir__)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'teracy-dev/logging'
require 'teracy-dev/plugin'

$logger = TeracyDev::Logging.logger_for("main")

def init()
  settings = YAML.load_file(File.join(File.dirname(__FILE__), '/system.yaml'))
  # versions requirements
  Vagrant.require_version settings['vagrant']['require_version']

  TeracyDev::Plugin.sync(settings['vagrant']['plugins'])
end

init()


# when init_system() succeeds, we're good to proceed because teracy-dev can require
# other gems via plugins config to work
require 'teracy-dev'

# extend
require 'teracy-dev/ext'
# register custom configurator
TeracyDev.register_configurator(TeracyDev::Ext::PluginsConfig.new)


settings = TeracyDev.build_settings()

TeracyDev.require_version settings['teracy-dev']['require_version']

TeracyDev.load_extensions(settings)

settings = TeracyDev.process(settings).freeze

Vagrant.configure("2") do |common|

  TeracyDev.configure(settings, common, type: 'common')

  settings['nodes'].each do |node_settings|
    primary = node_settings['primary'] ||= false
    autostart = node_settings['autostart'] === false ? false : true
    # NOTE: the next line is async
    common.vm.define node_settings['name'], primary: primary, autostart: autostart do |node|
      $logger.debug("node_settings: #{node_settings}")

      node_settings['provisioners'] ||= []
      ## system provisioners

      # fix hosts file on the guest machine
      # see: https://github.com/devopsgroup-io/vagrant-hostmanager/issues/203
      # NOTE: seems that there's bug with 2nd machine on 2 machines setup
      fix_hosts_command = "sed -i \"s/\\(127.0.1.1\\)\\(.*\\)#{node_settings['vm']['hostname']}\\(.*\\)/\\1\\3/\" /etc/hosts"
      $logger.debug("fix_hosts_command: #{fix_hosts_command}")

      node_settings['provisioners'].unshift({
        "type" => "shell",
        "name" => "fix-hosts",
        "enabled" => true,
        "inline" => fix_hosts_command
      })

      # save the MAC address if the file /vagrant/.vagrant/.public_mac_address exists
      node_settings['provisioners'] << {
        "type" => "shell",
        "name" => "save_mac_address",
        "enabled" => true,
        "path" => "provisioners/shells/save_mac_address.sh",
        "run" => "always"
      }

      # append ip shell as the last item to always display the ip address
      node_settings['provisioners'] << {
        "type" => "shell",
        "name" => "ip",
        "enabled" => true,
        "path" => "provisioners/shells/ip.sh",
        "run" => "always"
      }

      TeracyDev.configure(node_settings, node, type: 'node')
    end
  end
end
