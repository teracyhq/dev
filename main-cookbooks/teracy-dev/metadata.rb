name             'teracy-dev'
maintainer       'Teracy, Inc.'
maintainer_email 'hoatlevan@gmail.com'
license          'All rights reserved'
description      'Installs/Configures teracy-dev'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'
issues_url 'https://github.com/teracyhq/issues'
source_url 'https://github.com/teracyhq/issues'

%w{ magic_shell docker docker_compose }.each do |dep|
    depends dep
end

recipe 'teracy::aliases', "Installs useful aliases for teracy's project development."
recipe 'teracy-dev::directories', 'Manage directories.'
recipe 'teracy-dev::env_vars', 'Configures environment variables.'
recipe 'teracy-dev::docker', 'Installs Docker, docker-compose'
recipe 'teracy-dev::docker_registry', "Docker registry's tasks: login, ..."
recipe 'teracy-dev::docker_machine', 'Installs docker-machine'
recipe 'teracy-dev::inotify', 'Modify inotify, useful for development watching a lot of files'
recipe 'teracy-dev::proxy', 'Create a reverse proxy with nginx'
