# provisioner lib for dynamic settings provision from provided config file
# see: https://www.vagrantup.com/docs/provisioning/

# TODO(hoatle): should loop over and set the key dynamically

# https://www.vagrantup.com/docs/provisioning/file.html
private def file_settings(file, config)
  file.source = config['source']
  file.destination = config['destination']
end

# https://www.vagrantup.com/docs/provisioning/shell.html
private def shell_settings(shell, config)
  shell.inline = config['inline']
  shell.path = config['path']
  shell.args = config['args']
  unless config['env'].nil?
    shell.env = config['env']
  end
  unless config['binary'].nil?
    shell.binary = config['binary']
  end
  unless config['privileged'].nil?
    shell.privileged = config['privileged']
  end
  unless config['upload_path'].nil?
    #shell.upload_path = config['upload_path']
  end
  unless config['keep_color'].nil?
    shell.keep_color = config['keep_color']
  end
  unless config['powershell_args'].nil?
    shell.powershell_args = config['powershell_args']
  end
  unless config['powershell_elevated_interactive'].nil?
    shell.powershell_elevated_interactive = config['powershell_elevated_interactive']
  end
  unless config['md5'].nil?
    shell.md5 = config['md5']
  end
  unless config['sha1'].nil?
    shell.sha1 = config['sha1']
  end
end


# https://www.vagrantup.com/docs/provisioning/ansible_common.html
private def ansible_common(ansible, config) 
  ansible.playbook = config['playbook']

  unless config['config_file'].nil?
    ansible.config_file = config['config_file']
  end
  unless config['extra_vars'].nil?
    ansible.extra_vars = config['extra_vars']
  end
  unless config['galaxy_command'].nil?
    ansible.galaxy_command = config['galaxy_command']
  end
  unless config['galaxy_role_file'].nil?
    ansible.galaxy_role_file = config['galaxy_role_file']
  end
  unless config['galaxy_roles_path'].nil?
    ansible.galaxy_roles_path = config['galaxy_roles_path']
  end
  unless config['groups'].nil?
    ansible.groups = config['groups']
  end
  unless config['host_vars'].nil?
    ansible.host_vars = config['host_vars']
  end
  unless config['inventory_path'].nil?
    ansible.inventory_path = config['inventory_path']
  end
  unless config['limit'].nil?
    ansible.limit = config['limit']
  end
  unless config['playbook_command'].nil?
    ansible.playbook_command = config['playbook_command']
  end
  unless config['raw_arguments'].nil?
    ansible.raw_arguments = config['raw_arguments']
  end
  unless config['skip_tags'].nil?
    ansible.skip_tags = config['skip_tags']
  end
  unless config['start_at_task'].nil?
    ansible.start_at_task = config['start_at_task']
  end
  unless config['sudo'].nil?
    ansible.sudo = config['sudo']
  end
  unless config['sudo_user'].nil?
    ansible.sudo_user = config['sudo_user']
  end
  unless config['tags'].nil?
    ansible.tags = config['tags']
  end
  unless config['vault_password_file'].nil?
    ansible.vault_password_file = config['vault_password_file']
  end
  unless config['verbose'].nil?
    ansible.verbose = config['verbose']
  end

end

# https://www.vagrantup.com/docs/provisioning/ansible.html
private def ansible_settings(ansible, config)
  ansible_common(ansible, config)
  unless config['ask_sudo_pass'].nil?
    ansible.ask_sudo_pass = config['ask_sudo_pass']
  end
  unless config['ask_valt_pass'].nil?
    ansible.ask_valt_pass = config['ask_valt_pass']
  end
  unless config['force_remote_user'].nil?
    ansible.force_remote_user = config['force_remote_user']
  end
  unless config['host_key_checking'].nil?
    ansible.host_key_checking = config['host_key_checking']
  end
  unless config['raw_ssh_args'].nil?
    ansible.raw_ssh_args = config['raw_ssh_args']
  end
end

# https://www.vagrantup.com/docs/provisioning/ansible_local.html
private def ansible_local_settings(ansible, config)
  ansible_common(ansible, config)
  unless config['install'].nil?
    ansible.install = config['install']
  end
  unless config['install_mode'].nil?
    ansible.install_mode = config['install_mode'].to_sym
  end
  unless config['provisioning_path'].nil?
    ansible.provisioning_path = config['provisioning_path']
  end
  unless config['tmp_path'].nil?
    ansible.tmp_path = config['tmp_path']
  end
  unless config['version'].nil?
    ansible.version = config['version']
  end
end

# https://www.vagrantup.com/docs/provisioning/cfengine.html
private def cfengine_settings(cf, config)
  unless config['am_policy_hub'].nil?
    cf.am_policy_hub = config['am_policy_hub']
  end
  unless config['extra_agent_args'].nil?
    cf.extra_agent_args = config['extra_agent_args']
  end
  unless config['classes'].nil?
    cf.classes = config['classes']
  end
  unless config['deb_repo_file'].nil?
    cf.deb_repo_file = config['deb_repo_file']
  end
  unless config['deb_repo_line'].nil?
    cf.deb_repo_file = config['deb_repo_line']
  end
  unless config['files_path'].nil?
    cf.files_path = config['files_path']
  end
  unless config['force_bootstrap'].nil?
    cf.force_bootstrap = config['force_bootstrap']
  end
  unless config['install'].nil?
    install = config['install']
    if !!install == install
      # boolean
      cf.install = install
    else
      # string => to_sym
      cf.install = install.to_sym
    end
  end
  unless config['mode'].nil?
    cf.mode = config['mode'].to_sym
  end
  unless config['policy_server_address'].nil?
    cf.policy_server_address = config['policy_server_address']
  end
  unless config['repo_gpg_key_url'].nil?
    cf.repo_gpg_key_url = config['repo_gpg_key_url']
  end
  unless config['run_file'].nil?
    cf.run_file = config['run_file']
  end
  unless config['upload_path'].nil?
    cf.upload_path = config['upload_path']
  end
  unless config['yum_repo_file'].nil?
    cf.yum_repo_file = config['yum_repo_file']
  end
  unless config['yum_repo_url'].nil?
    cf.yum_repo_url = config['yum_repo_url']
  end
  unless config['package_name'].nil?
    cf.package_name = config['package_name']
  end
end

# https://www.vagrantup.com/docs/provisioning/chef_common.html
private def chef_common(chef, config)
  unless config['binary_path'].nil?
    chef.binary_path = config['binary_path']
  end
  unless config['binary_env'].nil?
    chef.binary_env = config['binary_env']
  end
  unless config['install'].nil?
    chef.install = config['install']
  end
  unless config['installer_download_path'].nil?
    chef.installer_download_path = config['installer_download_path']
  end
  unless config['log_level'].nil?
    chef.log_level = config['log_level']
  end
  unless config['product'].nil?
    chef.product = config['product']
  end
  unless config['channel'].nil?
    chef.channel = config['channel']
  end
  unless config['version'].nil?
    chef.version = config['version']
  end
  unless config['arguments'].nil?
    chef.arguments = config['arguments']
  end
  unless config['attempts'].nil?
    chef.attempts = config['attempts']
  end
  unless config['custom_config_path'].nil?
    chef.custom_config_path = config['custom_config_path']
  end
  unless config['encrypted_data_bag_secret_key_path'].nil?
    chef.encrypted_data_bag_secret_key_path = config['encrypted_data_bag_secret_key_path']
  end
  unless config['environment'].nil?
    chef.environment = config['environment']
  end
  unless config['formatter'].nil?
    chef.formatter = config['formatter']
  end
  unless config['http_proxy'].nil?
    chef.http_proxy = config['http_proxy']
  end
  unless config['http_proxy_user'].nil?
    chef.http_proxy_user = config['http_proxy_user']
  end
  unless config['http_proxy_pass'].nil?
    chef.http_proxy_pass = config['http_proxy_pass']
  end
  unless config['no_proxy'].nil?
    chef.no_proxy = config['no_proxy']
  end
  unless config['json'].nil?
    chef.json = config['json']
  end
  unless config['node_name'].nil?
    chef.node_name = config['node_name']
  end
  unless config['provisioning_path'].nil?
    chef.provisioning_path = config['provisioning_path']
  end
  unless config['run_list'].nil?
    chef.run_list = config['run_list']
  end
  unless config['file_cache_path'].nil?
    chef.file_cache_path = config['file_cache_path']
  end
  unless config['file_backup_path'].nil?
    chef.file_backup_path = config['file_backup_path']
  end
  unless config['verbose_logging'].nil?
    chef.verbose_logging = config['verbose_logging']
  end
  unless config['enable_reporting'].nil?
    chef.enable_reporting = config['enable_reporting']
  end
end

# https://www.vagrantup.com/docs/provisioning/chef_solo.html
private def chef_solo_settings(chef, config)
  chef_common(chef, config)
  unless config['cookbooks_path'].nil?
    chef.cookbooks_path = config['cookbooks_path']
  end
  unless config['roles_path'].nil?
    chef.roles_path = config['roles_path']
  end
  unless config['roles'].nil?
    config['roles'].each do |role|
      chef.add_role(role)
    end
  end
  unless config['data_bags_path'].nil?
    chef.data_bags_path = config['data_bags_path']
  end
end

# https://www.vagrantup.com/docs/provisioning/chef_zero.html
private def chef_zero_settings(chef, config)
  chef_common(chef, config)
  unless config['cookbooks_path'].nil?
    chef.cookbooks_path = config['cookbooks_path']
  end
  unless config['data_bags_path'].nil?
    chef.data_bags_path = config['data_bags_path']
  end
  unless config['environments_path'].nil?
    chef.environments_path = config['environments_path']
  end
  unless config['nodes_path'].nil?
    chef.nodes_path = config['nodes_path']
  end
  unless config['roles_path'].nil?
    chef.roles_path = config['roles_path']
  end
  unless config['roles'].nil?
    config['roles'].each do |role|
      chef.add_role role
    end
  end
  unless config['synced_folder_type'].nil?
    config.synced_folder_type = config['synced_folder_type']
  end
end

# https://www.vagrantup.com/docs/provisioning/chef_client.html
private def chef_client_settings(chef, config)
  chef_common(chef, config)
  unless config['chef_server_url'].nil?
    chef.chef_server_url = config['chef_server_url']
  end
  unless config['validation_key_path'].nil?
    chef.validation_key_path = config['validation_key_path']
  end
  unless config['recipes'].nil?
    config['recipes'].each do |recipe|
      chef.add_recipe recipe
    end
  end
  unless config['roles'].nil?
    config['roles'].each do |role|
      chef.add_role role
    end
  end
  unless config['client_key_path'].nil?
    chef.client_key_path = config['client_key_path']
  end
  unless config['validation_client_name'].nil?
    chef.validation_client_name = config['validation_client_name']
  end
  unless config['delete_node'].nil?
    chef.delete_node = config['delete_node']
  end
  unless config['delete_client'].nil?
    chef.delete_client = config['delete_client']
  end
end

# https://www.vagrantup.com/docs/provisioning/chef_apply.html
private def chef_apply_settings(chef, config)
  chef_common(chef, config)
  unless config['recipe'].nil?
    chef.recipe = config['recipe']
  end
  unless config['upload_path'].nil?
    chef.upload_path = config['upload_path']
  end
end

# https://www.vagrantup.com/docs/provisioning/docker.html
private def docker_settings(docker, config)
  unless config['images'].nil?
    docker.images = config['images']
  end
  unless config['build_images'].nil?
    config['build_images'].each do |build_image|
      path = build_image['path']
      args = ''
      unless build_image['args'].nil?
        args = build_image['args']
      end
      docker.build_image path args
    end
  end
  # TODO(hoatle): add support for run
end

# https://www.vagrantup.com/docs/provisioning/puppet_apply.html
private def puppet_apply(puppet, config)
  unless config['binary_path'].nil?
    puppet.binary_path = config['binary_path']
  end
  unless config['facter'].nil?
    puppet.facter = config['facter']
  end
  unless config['hiera_config_path'].nil?
    puppet.hiera_config_path = config['hiera_config_path']
  end
  unless config['manifest_file'].nil?
    puppet.manifest_file = config['manifest_file']
  end
  unless config['manifest_path'].nil?
    puppet.manifest_path = config['manifest_path']
  end
  unless config['module_path'].nil?
    puppet.module_path = config['module_path']
  end
  unless config['environment'].nil?
    puppet.environment = config['environment']
  end
  unless config['environment_path'].nil?
    puppet.environment_path = config['environment_path']
  end
  unless config['environment_variables'].nil?
    puppet.environment_variables = config['environment_variables']
  end
  unless config['options'].nil?
    puppet.options = config['options']
  end
  unless config['synced_folder_type'].nil?
    puppet.synced_folder_type = config['synced_folder_type']
  end
  unless config['synced_folder_args'].nil?
    puppet.synced_folder_args = config['synced_folder_args']
  end
  unless config['temp_dir'].nil?
    puppet.temp_dir = config['temp_dir']
  end
  unless config['working_directory'].nil?
    puppet.working_directory = config['working_directory']
  end
end

# https://www.vagrantup.com/docs/provisioning/puppet_agent.html
private def puppet_server(puppet, config)
  unless config['binary_path'].nil?
    puppet.binary_path = config['binary_path']
  end
  unless config['client_cert_path'].nil?
    puppet.client_cert_path = config['client_cert_path']
  end
  unless config['client_private_key_path'].nil?
    puppet.client_private_key_path = config['client_private_key_path']
  end
  unless config['facter'].nil?
    puppet.facter = config['facter']
  end
  unless config['options'].nil?
    puppet.options = config['options']
  end
  unless config['puppet_node'].nil?
    puppet.puppet_node = config['puppet_node']
  end
  unless config['puppet_server'].nil?
    puppet.puppet_server = config['puppet_server']
  end
end

# https://www.vagrantup.com/docs/provisioning/salt.html
private def salt_settings(salt, config)
  unless config['install_master'].nil?
    salt.install_master = config['install_master']
  end
  unless config['no_minion'].nil?
    salt.no_minion = config['no_minion']
  end
  unless config['install_syndic'].nil?
    salt.install_syndic = config['install_syndic']
  end
  unless config['install_type'].nil?
    salt.install_type = config['install_type']
  end
  unless config['install_args'].nil?
    salt.install_args = config['install_args']
  end
  unless config['always_install'].nil?
    salt.always_install = config['always_install']
  end
  unless config['bootstrap_script'].nil?
    salt.bootstrap_script = config['bootstrap_script']
  end
  unless config['bootstrap_options'].nil?
    salt.bootstrap_options = config['bootstrap_options']
  end
  unless config['version'].nil?
    salt.version = config['version']
  end
  unless config['minion_config'].nil?
    salt.minion_config = config['minion_config']
  end
  unless config['minion_key'].nil?
    salt.minion_key = config['minion_key']
  end
  unless config['minion_id'].nil?
    salt.minion_id = config['minion_id']
  end
  unless config['minion_pub'].nil?
    salt.minion_pub = config['minion_pub']
  end
  unless config['grains_config'].nil?
    salt.grains_config = config['grains_config']
  end
  unless config['masterless'].nil?
    salt.masterless = config['masterless']
  end
  unless config['master_config'].nil?
    salt.master_config = config['master_config']
  end
  unless config['master_key'].nil?
    salt.master_key = config['master_key']
  end
  unless config['master_pub'].nil?
    salt.master_pub = config['master_pub']
  end
  unless config['seed_master'].nil?
    salt.seed_master = config['seed_master']
  end
  unless config['run_highstate'].nil?
    salt.run_highstate = config['run_highstate']
  end
  unless config['run_overstate'].nil?
    salt.run_overstate = config['run_overstate']
  end
  unless config['orchestrations']
    salt.orchestrations = config['orchestrations']
  end
  unless config['colorize'].nil?
    salt.colorize = config['colorize']
  end
  unless config['log_level'].nil?
    salt.log_level = config['log_level']
  end
  unless config['pillars'].nil?
    config['pillars'].each do |pillar|
      salt.pillar(pillar)
    end
  end
end

# the public function to be used
public def provision_settings(type, provision, config)
  # puts config
  case type
  when "file"
    file_settings(provision, config)
  when "shell"
    shell_settings(provision, config)
  when "ansible"
    ansible_settings(provision, config)
  when "ansible_local"
    ansible_local_settings(provision, config)
  when "cfengine"
    cfengine_settings(provision, config)
  when "chef_solo"
    chef_solo_settings(provision, config)
  when "chef_zero"
    chef_zero_settings(provision, config)
  when "chef_client"
    chef_client_settings(provision, config)
  when "chef_apply"
    chef_apply_settings(provision, config)
  when "docker"
    docker_settings(provision, config)
  when "puppet_apply"
    puppet_apply(provision, config)
  when "puppet_server"
    puppet_server(provision, config)
  when "salt"
    salt_settings(provision, config)
  else
    puts red("no matching config type for: #{type}")
  end
end
