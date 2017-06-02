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
    release = node['docker_compose']['release']

    if release.empty?
        release = `curl -s https://api.github.com/repos/docker/compose/releases/latest | sed 's/[{}]//g' | awk -v k=text '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w 'tag_name' | awk '{print $2}' | awk 1 ORS=''`

        node.override['docker_compose']['release'] = release
    end

    release
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
        release = node['docker_compose']['release']

        if release.empty?
            bash 'clean up previous installed docker-compose' do
                code <<-EOF
                    docker_compose_binary=$(which docker-compose);
                    rm -rf $docker_compose_binary || true;
                EOF
                only_if 'which docker-compose'
                user 'root'
            end
        else
            bash 'clean up the mismatched docker-compose version' do
                # docker-compose version 1.10.0, build 4bd6f1a => docker_compose_version: 1.10.0
                code <<-EOF
                    docker_compose_binary=$(which docker-compose);
                    docker_compose_version=$(docker-compose -v | awk '{print $3}');
                    docker_compose_version=${docker_compose_version::-1};
                    if [ "$docker_compose_version" != "#{release}" ]; then
                        rm -rf $docker_compose_binary || true;
                    fi
                EOF
                only_if 'which docker-compose'
                user 'root'
            end
        end

        autocomplete_url = get_docker_compose_autocomplete_url

        include_recipe 'docker_compose::installation'

        # install docker-compose auto complete
        if node['platform'] == 'ubuntu'
            execute 'install docker-compose autocomplete' do
                action :run
                command "curl -sSL #{autocomplete_url} > /etc/bash_completion.d/docker-compose"
                creates '/etc/bash_completion.d/docker-compose'
                user 'root'
                group 'docker'
            end
        end
    end
end

