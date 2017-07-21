# Author:: Hoat Le <hoatle@teracy.com>
# Cookbook:: teracy-dev
# Recipe:: docker_registry
# Login into the Docker registries

docker_conf = node['docker']

docker_registry_conf = node['docker_registry']

if docker_conf['enabled'] == true
    execute 'rm ~/.docker/config.json' do
        command 'rm /home/vagrant/.docker/config.json || true'
        only_if {
            docker_registry_conf['force'] == true and
            File.exist?('/home/vagrant/.docker/config.json')
        }
    end

    docker_registry_conf['entries'].each.with_index do |entry, index|
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
        command 'cp /root/.docker/config.json /home/vagrant/.docker/config.json'
        only_if {
            File.exist?('/root/.docker/config.json') and (
                docker_registry_conf['force'] == true or
                not File.exist?('/home/vagrant/.docker/config.json')
            )
        }
    end
end
