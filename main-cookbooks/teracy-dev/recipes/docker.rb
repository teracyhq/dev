#
# Author:: Hoat Le <hoatle@teracy.com>
# Cookbook Name:: teracy-dev
# Recipe:: docker
#
# Copyright 2013 - current, Teracy, Inc.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
#        to endorse or promote products derived from this software without
#        specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

docker_conf = node['docker']

def get_docker_compose_release
    release = node['docker_compose']['version']

    if release.empty?
        result = Mixlib::ShellOut.new('curl -s https://api.github.com/repos/docker/compose/releases/latest | grep "tag_name" | cut -d\" -f4')

        result.run_command

        result.error!

        release = result.stdout.strip

        # TODO(hoatle): what if error or empty result? need to handle this case
    end
    node.override['docker_compose']['release'] = release
    Chef::Log.info("get_docker_compose_release::release: #{release}")
    release
end

def existing_docker_compose_version
    existing_docker_compose_version_cmd = Mixlib::ShellOut.new("docker-compose version | head -1 | grep -o -E '[0-9].*' | cut -d ',' -f1")

    existing_docker_compose_version_cmd.run_command

    existing_version = ''

    existing_version = existing_docker_compose_version_cmd.stdout.strip if existing_docker_compose_version_cmd.stderr.empty? && !existing_docker_compose_version_cmd.stdout.empty?
    Chef::Log.debug("existing_docker_compose_version_cmd.stderr: #{existing_docker_compose_version_cmd.stderr}")
    Chef::Log.debug("existing_docker_compose_version_cmd.stdout: #{existing_docker_compose_version_cmd.stdout}")
    existing_version
end

def get_docker_compose_autocomplete_url
    "https://raw.githubusercontent.com/docker/compose/#{get_docker_compose_release}/contrib/completion/bash/docker-compose"
end

if docker_conf['enabled'] == true

    act = :create
    if docker_conf['action'] == 'delete'
        act = :delete
    end

    if !docker_conf['version'].empty?
        # to make sure docker-engine is added into the package
        # see: https://github.com/teracyhq/dev/issues/278
        docker_installation 'default' do
            repo docker_conf['repo']
            action act
            not_if 'which docker'
        end

        # TODO(hoatle): better to uninstall only if the 2 versions mismatch
        docker_installation 'default' do
            repo docker_conf['repo']
            action :delete
        end

        docker_installation_package 'default' do
            version docker_conf['version']
            action act
            package_options docker_conf['package_options']
        end
    else
        docker_installation 'default' do
            repo docker_conf['repo']
            action act
        end
    end

    group 'docker' do
        action :modify
        members docker_conf['members']
        append true
    end


    if node['docker_compose']['enabled'] == true
        release = get_docker_compose_release()

        existing_docker_compose_version = existing_docker_compose_version()
        docker_compose_path = node['docker_compose']['command_path']
        docker_compose_autocomplete_path = '/etc/bash_completion.d/docker-compose'
        Chef::Log.debug("existing_docker_compose_version: #{existing_docker_compose_version}")
        # empty could mean broken installation, it's safe to do clean up.
        if existing_docker_compose_version.empty? or existing_docker_compose_version != release
            file docker_compose_path do
              action :delete
              only_if { File.exist?(docker_compose_path) }
            end

            file docker_compose_autocomplete_path do
                action :delete
                only_if { File.exist?(docker_compose_autocomplete_path) }
            end
        end

        if !File.exist?(docker_compose_path)
            # TODO(hoatle): get the cache file here
            include_recipe 'docker_compose::installation'
            # put the cache file here
        end

        if !File.exist?(docker_compose_autocomplete_path)
            # TODO(hoatle): get the cache file here
            autocomplete_url = get_docker_compose_autocomplete_url
            # install docker-compose auto complete
            execute 'install docker-compose autocomplete' do
                action :run
                command "curl -sSL #{autocomplete_url} > /etc/bash_completion.d/docker-compose"
                creates docker_compose_autocomplete_path
                user 'root'
                group 'docker'
                only_if { node['platform'] == 'ubuntu' }
            end
            # put the cache file here
        end
    end
end
