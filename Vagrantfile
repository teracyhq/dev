# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  require 'json'
  # Load default setting
  file = File.read('Vagrant_Config.json')  
  data_hash = JSON.parse(file)

  # Check and override if exist any match JSON object from Vagrant_Config_Override.json
  if File.exist? ('Vagrant_Config_Override.json')
    override_file = File.read('Vagrant_Config_Override.json')  

    begin      
      JSON.parse(override_file).each do |key, value|
        if data_hash.has_key?(key)
          data_hash[key] = value
        end
      end
    rescue
    end
  end
  
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = data_hash["box"]

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = data_hash['box_url']

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  
  data_hash['forwarded_port'].each do |x|
    config.vm.network :forwarded_port, guest: x["guest"], host: x["host"]
  end
  #default for developing django applications

  # config.vm.network :forwarded_port, guest: 4000, host: 4000 # octopress preview
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

  data_hash['synced_folder'].each do |x|
    
    if x[2].nil? or x[3].nil?
      config.vm.synced_folder x[0], x[1]
    else
      config.vm.synced_folder x[0], x[1], :mount_options => [x[2], x[3]]
    end

  end

  # ssh configuration
  config.ssh.forward_agent = data_hash['forward_agent']

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/.virtualenvs", "1"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    # chef.log_level = :debug
    chef.cookbooks_path = data_hash['chef_cookbooks']
    chef.roles_path = data_hash['chef_role']
    chef.data_bags_path = data_hash['chef_bags_path']

    data_hash['chef_recipe'].each do |x|
      chef.add_recipe x
    end
  # custom JSON attributes for chef-solo, see more at http://docs.vagrantup.com/v2/provisioning/chef_solo.html
    chef.json = {
      "teracy-dev" => {
        "workspace" => data_hash['workspace'],
        "git" => data_hash['git'],
        "nodejs" => data_hash['nodejs'],
        "python" => data_hash['python'],
        "ruby" => data_hash['ruby'],
        "java" => data_hash['java'],
        "php" => data_hash['php'],
        "gettext" => data_hash['gettext']
      },
    }
  end
  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = ENV['KNIFE_CHEF_SERVER']
  #   chef.validation_key_path = "#{ENV['KNIFE_VALIDATION_KEY_FOLDER']}/#{ENV['OPSCODE_ORGNAME']}-validator.pem"
  #   chef.validation_client_name = "#{ENV['OPSCODE_ORGNAME']}-validator"
  #   chef.node_name = "#{ENV['OPSCODE_USER']}-vagrant"
  #   chef.run_list = [
  #     'motd',
  #     'minitest-handler'
  #   ]
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
