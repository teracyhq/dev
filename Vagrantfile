# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'
load File.dirname(__FILE__) + '/lib/utility.rb'
load File.dirname(__FILE__) + '/lib/provisioner.rb'


# Load default setting
file = File.read(File.dirname(__FILE__) + '/vagrant_config.json')
data_hash = JSON.parse(file)
override_hash = nil

# Check and override if exist any match JSON object from vagrant_config_override.json

begin
  if File.exist?(File.dirname(__FILE__) + '/vagrant_config_override.json')
    parsing_file = File.dirname(__FILE__) + '/vagrant_config_override.json'
    override_file = File.read(parsing_file)
    override_hash = JSON.parse(override_file)

    data_hash = overrides(data_hash, override_hash)
  end

  if File.exist?(File.dirname(__FILE__) + '/workspace/dev-setup/vagrant_config_default.json')
    parsing_file = File.dirname(__FILE__) + '/workspace/dev-setup/vagrant_config_default.json'
    org_config_file = File.read(parsing_file)
    org_config_hash = JSON.parse(org_config_file)

    override_config_file_path = parsing_file.gsub(/default\.json$/, "override.json")
    if File.exist?(override_config_file_path)
      override_config_file = File.read(override_config_file_path)
      parsing_file = override_config_file_path
      override_config_hash = JSON.parse(override_config_file)
      org_config_hash = overrides(org_config_hash, override_config_hash)
    end

    if !org_config_hash.nil?
      overrides(data_hash, org_config_hash)
    end
  end

  if data_hash['vagrant'] && data_hash['vagrant']['config_paths']
    data_hash['vagrant']['config_paths'].map do |default_config_file_path|
      override_config_file_path = default_config_file_path.gsub(/default\.json$/, "override.json")

      if File.exist?(File.dirname(__FILE__) + '/' + default_config_file_path)
        default_config_file = File.read(File.dirname(__FILE__) + '/' + default_config_file_path)
        parsing_file = default_config_file_path
        project_config_hash = JSON.parse(default_config_file)
      else
        puts "[teracy-dev][INFO]: #{default_config_file_path} not found, make sure this is intended."
      end

      if File.exist?(File.dirname(__FILE__) + '/' + override_config_file_path)
        override_config_file = File.read(File.dirname(__FILE__) + '/' + override_config_file_path)
        parsing_file = override_config_file_path
        override_config_hash = JSON.parse(override_config_file)
        project_config_hash = overrides(project_config_hash, override_config_hash)
      end
      if !project_config_hash.nil?
        overrides(data_hash, project_config_hash)
      end
    end
  end
rescue Exception => msg
  puts red(msg)
  puts red('from ' + parsing_file)
  ans = prompt yellow("some errors have occured and '" + parsing_file + "' file will not be used, do you want to continue? [y/N]: ")
  if ans.downcase != 'y'
    exit!
  end
end

Vagrant.configure("2") do |config|

  vm_hash = data_hash["vm"]

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = vm_hash["box"]

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = vm_hash['box_url']

  # Other configs: https://docs.vagrantup.com/v2/vagrantfile/machine_settings.html

  if !vm_hash["box_version"].nil? and !vm_hash["box_version"].strip().empty?
    config.vm.box_version = vm_hash['box_version']
  end

  if !vm_hash["boot_timeout"].nil?
    config.vm.boot_timeout = vm_hash['boot_timeout']
  end

  if !vm_hash["box_check_update"].nil?
    config.vm.box_check_update = vm_hash['box_check_update']
  end

  if !vm_hash["box_download_checksum"].nil? and !vm_hash["box_download_checksum"].strip().empty?
    config.vm.box_download_checksum = vm_hash['box_download_checksum']

    # box_download_checksum_type must be specified if box_download_checksum is specified
    config.vm.box_download_checksum_type = vm_hash['box_download_checksum_type']
  end

  if !vm_hash["box_download_client_cert"].nil? and !vm_hash["box_download_client_cert"].strip().empty?
    config.vm.box_download_client_cert = vm_hash['box_download_client_cert']
  end

  if !vm_hash["box_download_ca_cert"].nil? and !vm_hash["box_download_ca_cert"].strip().empty?
    config.vm.box_download_ca_cert = vm_hash['box_download_ca_cert']
  end

  if !vm_hash["box_download_ca_path"].nil? and !vm_hash["box_download_ca_path"].strip().empty?
    config.vm.box_download_ca_path = vm_hash['box_download_ca_path']
  end

  if !vm_hash["box_download_insecure"].nil?
    config.vm.box_download_insecure = vm_hash['box_download_insecure']
  end

  if !vm_hash["communicator"].nil? and !vm_hash["communicator"].strip().empty?
    config.vm.communicator = vm_hash['communicator']
  end

  if !vm_hash["graceful_halt_timeout"].nil?
    config.vm.graceful_halt_timeout = vm_hash['graceful_halt_timeout']
  end

  if !vm_hash["guest"].nil? and !vm_hash["guest"].strip().empty?
    config.vm.guest = vm_hash['guest']
  end

  if !vm_hash["hostname"].nil? and !vm_hash["hostname"].strip().empty?
    config.vm.hostname = vm_hash['hostname']
  end

  if !vm_hash["post_up_message"].nil? and !vm_hash["post_up_message"].strip().empty?
    config.vm.post_up_message = vm_hash['post_up_message']
  end

  if !vm_hash["usable_port_range"].nil? and !vm_hash["usable_port_range"].strip().empty?
    ranges = vm_hash['usable_port_range'].split('..').map{|d| Integer(d)}
    config.vm.usable_port_range = ranges[0]..ranges[1]
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  vm_networks = vm_hash['networks']
  vm_networks.each do |vm_network|
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

        bridge_interface = ""
        bridge_interface = vm_network['bridge'] unless vm_network['bridge'].nil? or vm_network['bridge'].empty?
        bridge_interface = get_default_nic() if bridge_interface.empty? and vm_network['auto_bridge_default_network']
        options[:bridge] = bridge_interface unless bridge_interface.empty?
      end

      config.vm.network vm_network['mode'], options

    end
  end


  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  vm_hash['synced_folders'].each do |item|
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
    options[:create] = item['create'] unless item['create'].nil?
    options[:disabled] = item['disabled'] unless item['disabled'].nil?
    options[:owner] = item['owner'] unless item['owner'].nil?
    options[:group] = item['group'] unless item['group'].nil?
    options[:mount_options] = item['mount_options'] unless item['mount_options'].nil?
    options[:type] = item['type'] unless item['type'].nil? or item['type'] == 'virtual_box'

    case item['type']
    when 'nfs'
      options[:nfs_export] = item['nfs_export'] if !!item['nfs_export'] == item['nfs_export']
      options[:nfs_udp] = item['nfs_udp'] if !!item['nfs_udp'] == item['nfs_udp']
      options[:nfs_version] = item['nfs_version'] unless item['nfs_version'].nil?
    when 'rsync'
      options[:rsync__args] = item['rsync__args'] unless item['rsync__args'].nil? or item['rsync__args'].empty?
      options[:rsync__auto] = item['rsync__auto'] if !!item['rsync__auto'] == item['rsync__auto']
      options[:rsync__chown] = item['rsync__chown'] if !!item['rsync__chown'] == item['rsync__chown']
      options[:rsync__exclude] = item['rsync__exclude'] unless item['rsync__exclude'].nil? or item['rsync__exclude'].empty?
    when 'smb'
      options[:smb_host] = item['smb_host'] unless item['smb_host'].nil? or item['smb_host'].empty?
      options[:smb_password] = item['smb_password'] unless item['smb_password'].nil? or item['smb_password'].empty?
      options[:smb_username] = item['smb_username'] unless item['smb_password'].nil? or item['smb_password'].empty?
    end

    if item['supports'].nil? or item['supports'].include?(host_os_type)
      config.vm.synced_folder item['host'], item['guest'], options
    end
  end

  # plugins config
  plugins_hash = data_hash['plugins']

  plugins_hash.each do |plugin|
    plugin_name = plugin['name']
    if plugin['required'] == true
      # thanks to http://matthewcooper.net/2015/01/15/automatically-installing-vagrant-plugin-dependencies/
      exec "vagrant plugin install #{plugin_name} && vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin?(plugin_name) || ARGV[0] == 'plugin'

      unless Vagrant.has_plugin?(plugin_name)
        puts red("required: '$ vagrant plugin install #{plugin_name}'")
        exit!
      end
    end

    # this is current fixed config, not dynamic plugins config
    # FIXME(hoatle): #186 should fix this
    if Vagrant.has_plugin?(plugin_name) and plugin['enabled'] == true and plugin.key?('config_key')
      config_key = plugin['config_key']
      options = plugin['options']
      if 'gatling' == config_key

        unless options['latency'].nil?
          config.gatling.latency = options['latency']
        end

        unless options['time_format'].nil? or options['time_format'].empty?
          config.gatling.time_format = options['time_format']
        end

        unless options['rsync_on_startup'].nil?
          config.gatling.rsync_on_startup = options['rsync_on_startup']
        end

      elsif 'hostmanager' == config_key
        if Vagrant.has_plugin?('vagrant-hostsupdater')
          puts red('recommended: $ vagrant plugin uninstall vagrant-hostsupdater')
        end

        unless options['enabled'].nil?
          config.hostmanager.enabled = options['enabled']
        end

        unless options['manage_host'].nil?
          config.hostmanager.manage_host = options['manage_host']
        end

        unless options['manage_guest'].nil?
          config.hostmanager.manage_guest = options['manage_guest']
        end

        unless options['ignore_private_ip'].nil?
          config.hostmanager.ignore_private_ip = options['ignore_private_ip']
        end

        unless options['include_offline'].nil?
          config.hostmanager.include_offline = options['include_offline']
        end

        unless options['aliases'].nil?
          config.hostmanager.aliases = options['aliases']
        end

        # workaround for :public_network
        # maybe this will not work with :private_network
        config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
          read_ip_address(vm)
        end
      end
    end

    # if plugin.key?('config_key')
    #   config_key = plugin['config_key']
    #   if Vagrant.has_plugin?(plugin_name) and !config_key.nil? and !config_key.empty?
    #     puts red(config[config_key.to_sym])
    #     # TODO(hoatle): remove config_key and required keys?
    #     #config.instance_variable_set("@#{config_key}", plugin)
    #     # new_config = Vagrant::Config::V2::Root.new({
    #     #   config_key => plugin
    #     # })
    #     # config.merge(config, new_config)
    #   end
    # end
  end

  # ssh configuration
  config.ssh.forward_agent = vm_hash['forward_agent']

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  # View the documentation for the provider you're using for more
  # information on available options.
  config.vm.provider :virtualbox do |vb|

    vb_hash = data_hash['vb']

    # Don't boot with headless mode
    if vb_hash['gui']  == true
      vb.gui = true
    end

    # general settings for modifyvm: https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
    # TODO(hoatle): add support for key<1-N> type
    # TODO(hoatle): add support for other settings

    # FIXME(hoatle): there were 3 loops here, why?
    # puts vb_hash

    general_settings_keys = ['name', 'groups', 'description', 'ostype', 'memory', 'vram', 'acpi',
      'ioapic', 'hardwareuuid', 'cpus', 'rtcuseutc', 'cpuhotplug', 'plugcpu', 'unplugcpu',
      'cpuexecutioncap', 'pae', 'longmode', 'synthcpu', 'hpet', 'hwvirtex', 'triplefaultreset',
      'nestedpaging', 'largepages', 'vtxvpid', 'vtxux', 'accelerate3d', 'bioslogofadein',
      'bioslogodisplaytime', 'bioslogoimagepath', 'biosbootmenu', 'snapshotfolder', 'firmware',
      'guestmemoryballoon', 'defaultfrontend'
    ]

    vb_hash.each do |key, val|
      if general_settings_keys.include?(key) and !vb_hash[key].nil?
        val = val.to_s.strip()
        if !val.empty?
          vb.customize ["modifyvm", :id, "--" + key, val]
        end
      end
    end

  end

  # provisoners settings
  provisioners = data_hash['provisioners']
  chef_hash = data_hash['chef']

  if !chef_hash.nil?
    puts red("You're using deprecated setting for chef, will be removed by v0.5.0-b2, please update it now, see more: https://github.com/teracyhq/dev/issues/166")

    # chef_hash should override the default provisioner chef_solo
    provisioners.each do |provisioner|
      if provisioner['type'] == 'chef_solo'
        chef_hash = overrides(provisioner, chef_hash)
      end
    end

    if chef_hash['enabled'].nil? or chef_hash['enabled'] == true
      config.vm.provision "chef_solo" do |chef|
        chef.log_level = chef_hash['log_level']
        chef.cookbooks_path = chef_hash['cookbooks_path']
        chef.data_bags_path = chef_hash['data_bags_path']
        chef.environments_path = chef_hash['environments_path']
        chef.environment = chef_hash['environment']
        chef.nodes_path = chef_hash['nodes_path']
        chef.recipe_url = chef_hash['recipe_url']
        chef.roles_path = chef_hash['roles_path']
        chef.synced_folder_type = chef_hash['synced_folder_type']

        unless chef_hash['roles'].nil?
          chef_hash['roles'].each do |role|
            chef.add_role role
          end
        end

        unless chef_hash['recipes'].nil?
          chef_hash['recipes'].each do |recipe|
            chef.add_recipe recipe
          end
        end

        chef.json = chef_hash['json']
      end
      # empty provisioners to work as backward compatible
      provisioners = []
    end
  end

  # fix hosts file on the guest machine
  # see: https://github.com/devopsgroup-io/vagrant-hostmanager/issues/203
  fix_hosts_command = "sed -i \"s/\\(127.0.0.1\\)\\(.*\\)#{config.vm.hostname}\\(.*\\)/\\1\\3/\" /etc/hosts"

  provisioners.unshift({
    "type" => "shell",
    "name" => "fix-hosts",
    "inline" => fix_hosts_command
  })

  # append ip shell as the last item to always display the ip address
  provisioners << {
    "type" => "shell",
    "name" => "ip",
    "path" => "provisioners/shells/ip.sh",
    "run" => "always"
  }

  provisioners.each do |provisioner|
    type = provisioner['type']
    run = 'once'
    preserve_order = false
    if !provisioner['run'].nil?
      run = provisioner['run'] # one of: once, always, or never
    end
    if provisioner['preserve_order'] == true
      preserve_order = true
    end

    if provisioner['name'].nil?
      config.vm.provision "#{type}", run: run, preserve_order: preserve_order do |provision|
        provision_settings(type, provision, provisioner)
      end
    else
      config.vm.provision provisioner['name'], type: type, run: run, preserve_order: preserve_order do |provision|
        provision_settings(type, provision, provisioner)
      end
    end
  end
end

begin
  extension_paths = data_hash['vagrant']['extension_paths']
  extension_paths.each do |path|
    ext_file_path = File.dirname(__FILE__) + '/' + path
    if File.file?(ext_file_path)
      load ext_file_path
    else
      # warnings if override vagrant:extension_paths
      if !override_hash.nil? and !override_hash['vagrant'].nil? and !override_hash['vagrant']['extension_paths'].nil?
        puts red(ext_file_path + ' is missing!')
      end
    end
  end
rescue Exception => msg
  puts red(msg)
end
