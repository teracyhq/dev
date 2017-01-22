# provisioner lib for dynamic settings provision from provided config file
# see: https://www.vagrantup.com/docs/provisioning/

# TODO(hoatle): should loop over and set the key dynamically

# https://www.vagrantup.com/docs/provisioning/file.html
private def file_settings(file, provisioner)
  file.source = provisioner['source']
  file.destination = provisioner['destination']
end

# https://www.vagrantup.com/docs/provisioning/shell.html
private def shell_settings(shell, provisioner)
  shell.inline = provisioner['inline']
  shell.path = provisioner['path']
  shell.args = provisioner['args']
  unless provisioner['env'].nil?
    shell.env = provisioner['env']
  end
  unless provisioner['binary'].nil?
    shell.binary = provisioner['binary']
  end
  unless provisioner['privileged'].nil?
    shell.privileged = provisioner['privileged']
  end
  unless provisioner['upload_path'].nil?
    #shell.upload_path = provisioner['upload_path']
  end
  unless provisioner['keep_color'].nil?
    shell.keep_color = provisioner['keep_color']
  end
  unless provisioner['powershell_args'].nil?
    shell.powershell_args = provisioner['powershell_args']
  end
  unless provisioner['powershell_elevated_interactive'].nil?
    shell.powershell_elevated_interactive = provisioner['powershell_elevated_interactive']
  end
  unless provisioner['md5'].nil?
    shell.md5 = provisioner['md5']
  end
  unless provisioner['sha1'].nil?
    shell.sha1 = provisioner['sha1']
  end
end


# the public function to be used
public def provisioner_settings(type, provision, provisioner)
  # puts provisioner
  case type
  when "file"
    file_settings(provision, provisioner)
  when "shell"
    shell_settings(provision, provisioner)
  else
    puts red("no matching provisioner type for: #{type}")
  end
end
