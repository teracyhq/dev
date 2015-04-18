name             'teracy-dev'
maintainer       'Teracy, Inc.'
maintainer_email 'hoatlevan@gmail.com'
license          'All rights reserved'
description      'Installs/Configures teracy-dev'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

%w{ magic_shell nodejs npm rbenv ark python java maven php mongodb mysql postgresql git ssh_known_hosts pyenv apache2 nginx phpmyadmin apt}.each do |dep|
    depends dep
end

recipe 'teracy::alias', "Installs useful alias for teracy's project development."
recipe 'teracy-dev::apt', "Installs required packages for teracy' project development."
recipe 'teracy-dev::workspace', 'Creates workspace directory for teraciers.'
recipe 'teracy-dev::virtualenvwrapper', 'Installs virtualenvwrapper using the python_pip resource and configure it.'
recipe 'teracy-dev::env', 'Configures environment.'
recipe 'teracy-dev::git', 'Configures and installs global git.'
recipe 'teracy-dev::pip_config', 'Configures global pip.'
recipe 'teracy-dev::rbenv', 'Installs rbenv and related packages.'
recipe 'teracy-dev::node', 'Installs node and related packages.'
recipe 'teracy-dev::apache2', 'Installs apache2 and related packages.'
recipe 'teracy-dev::php', 'Installs php and related packages.'
recipe 'teracy-dev::mongodb', 'Installs mongodb and related packages.'
recipe 'teracy-dev::mysql', 'Installs mysql and related packages.'
recipe 'teracy-dev::postgresql', 'Installs postgresql and related packages.'
recipe 'teracy-dev::nginx', 'configure and install nginx'
recipe 'teracy-dev::codebox', 'Installs codebox IDE.'
recipe 'teracy-dev::phpmyadmin', 'Install phpmyadmin and configure with apache, nginx'