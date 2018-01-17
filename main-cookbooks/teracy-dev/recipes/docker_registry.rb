# Author:: Hoat Le <hoatle@teracy.com>
# Cookbook:: teracy-dev
# Recipe:: docker_registry
# Login into the Docker registries

docker_conf = node['docker']

docker_registry_conf = node['docker_registry']

docker_config_path = docker_registry_conf['config_path']


if docker_conf['enabled'] == true
    execute 'rm ~/.docker/config.json' do
        command "rm #{docker_config_path} || true"
        only_if {
            docker_registry_conf['force'] == true and
            File.exist?(docker_config_path)
        }
    end

    docker_registry_conf['entries'].each do |entry|
        # private registry login

        username = entry['username'] ? entry['username'] : ''

        password = entry['password'] ? entry['password'] : ''

        if not username.empty? and not password.empty?
            opt = [
                "-u #{username}",
                "-p #{password}"
            ].join(' ');

            execute 'docker login' do
                command "docker login #{entry['host']} #{opt}"
                # because we need root to execute docker-compose, not 'vagrant'
                only_if {
                    docker_registry_conf['force'] == true or
                    not File.exist?('/root/.docker/config.json')
                }
            end
        end
    end


    execute 'copy /root/.docker/config.json to ~/.docker/config.json' do
        command "cp /root/.docker/config.json #{docker_config_path}"
        only_if {
            File.exist?('/root/.docker/config.json') and (
                docker_registry_conf['force'] == true or
                not File.exist?(docker_config_path)
            )
        }
    end
end
