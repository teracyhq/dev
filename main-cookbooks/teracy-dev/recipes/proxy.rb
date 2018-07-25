#
# Author:: Hoat Le <hoatle@teracy.com>
# Cookbook Name:: teracy-dev
# Recipe:: proxy
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

proxy_conf = node['teracy-dev']['proxy']

if proxy_conf['enabled'] == true
    certs_conf = node['teracy-dev']['proxy']['certs']

    if certs_conf['enabled'] == true

        owner = certs_conf['owner']
        group = certs_conf['group']
        mode = certs_conf['mode']
        sources = certs_conf['sources']
        destination = certs_conf['destination']
        auto_certs = certs_conf['auto_certs']

        # create the destination directory first
        directory destination do
            owner owner
            group group
            mode '0755'
            action :create
            recursive true
        end

        # then copy files
        sources.each do |source|
            source_path = "default/#{source}"
            file_ext_splits = source.split('.')
            file_ext = file_ext_splits[file_ext_splits.length-1]
            destination_path = "#{destination}/#{node.name}.#{file_ext}"

            cookbook_file destination_path do
                source source_path
                owner owner
                group group
                mode mode
                action :create
            end
        end

        auto_certs.each do |cert_domain|
            execute "install certificate for #{cert_domain}" do
                action :run
                command "DNS=$(nslookup #{cert_domain} 8.8.8.8 | grep Address | tail -n1 | awk '{print $2}') && \
                         curl -sSL --resolve \"#{cert_domain}:443:$DNS\" https://#{cert_domain}/privkey.pem -o #{destination}/#{cert_domain}.key && \
                         curl -sSL --resolve \"#{cert_domain}:443:$DNS\" https://#{cert_domain}/fullchain.pem -o #{destination}/#{cert_domain}.crt"
                user owner
                group group
            end
        end
    end

    # start docker nginx-proxy
    # this require that docker must be available implicitly (error will happen if no docker installed)
    container_conf = node['teracy-dev']['proxy']['container']
    if container_conf['enabled'] == true

        docker_image container_conf['repo'] do
            tag container_conf['tag']
            action :pull
            notifies :redeploy, "docker_container[#{container_conf['name']}]"
        end

        docker_container container_conf['name'] do
            repo container_conf['repo']
            tag container_conf['tag']
            volumes container_conf['volumes']
            restart_policy container_conf['restart_policy']
            port container_conf['port']
        end
    end
end
