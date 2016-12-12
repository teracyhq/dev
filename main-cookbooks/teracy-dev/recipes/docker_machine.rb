#
# Author:: Hoat Le <hoatle@teracy.com>
# Cookbook Name:: teracy-dev
# Recipe:: docker_machine
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

docker_machine_conf = node['docker_machine']


if docker_machine_conf['enabled'] == true

    def get_install_url
        release = node['docker_machine']['release']
        kernel_name = node['kernel']['name']
        machine_hw_name = node['kernel']['machine']
        "https://github.com/docker/machine/releases/download/#{release}/docker-machine-#{kernel_name}-#{machine_hw_name}"
    end

    def get_docker_machine_autocomplete_url
        release = node['docker_machine']['release']
        "https://raw.githubusercontent.com/docker/machine/#{release}/contrib/completion/bash/docker-machine.bash"
    end

    def get_docker_machine_prompt_autocomplete_url
        release = node['docker_machine']['release']
        "https://raw.githubusercontent.com/docker/machine/#{release}/contrib/completion/bash/docker-machine-prompt.bash"
    end

    def get_docker_machine_wrapper_autocomplete_url
        release = node['docker_machine']['release']
        "https://raw.githubusercontent.com/docker/machine/#{release}/contrib/completion/bash/docker-machine-wrapper.bash"
    end

    command_path = docker_machine_conf['command_path']
    install_url = get_install_url

    package 'curl' do
        action :install
    end


    execute 'install docker-machine' do
        action :run
        command "curl -sSL #{install_url} > #{command_path} && chmod +x #{command_path}"
        creates command_path
        user 'root'
        group 'docker'
        umask '0027'
    end

    # install autocomplete (Ubuntu compatible only)

        # install docker-compose auto complete
    if node['platform'] == 'ubuntu'
        docker_machine_url = get_docker_machine_autocomplete_url

        execute 'install docker-machine autocomplete' do
            action :run
            command "curl -sSL #{docker_machine_url} > /etc/bash_completion.d/docker-machine.bash"
            creates '/etc/bash_completion.d/docker-machine.bash'
            user 'root'
            group 'docker'
        end

        docker_machine_prompt_url = get_docker_machine_prompt_autocomplete_url

        execute 'install docker-machine-prompt autocomplete' do
            action :run
            command "curl -sSL #{docker_machine_prompt_url} > /etc/bash_completion.d/docker-machine-prompt.bash"
            creates '/etc/bash_completion.d/docker-machine-prompt.bash'
            user 'root'
            group 'docker'
        end

        docker_machine_wrapper_url = get_docker_machine_wrapper_autocomplete_url

        execute 'install docker-machine-wrapper autocomplete' do
            action :run
            command "curl -sSL #{docker_machine_wrapper_url} > /etc/bash_completion.d/docker-machine-wrapper.bash"
            creates '/etc/bash_completion.d/docker-machine-wrapper.bash'
            user 'root'
            group 'docker'
        end
    end

end
