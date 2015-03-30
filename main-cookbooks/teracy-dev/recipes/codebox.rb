#
# Author:: Dat Phan <datphan@teracy.com>
# Cookbook Name:: teracy-dev
# Recipe:: codebox
#
# Copyright 2013 - 2015, Teracy, Inc.
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

# ref: https://github.com/brtz/chef-codebox
if node['teracy-dev']['codebox']['enabled']

    # Encoding: UTF-8
    # Copyright (c) 2014, Nils Bartels, see LICENSE for details

    user = node['teracy-dev']['codebox']['user']
    install_path = '/usr/local/lib'

    # npm install codebox
    bash 'install codebox for user: ' + user do
        code <<-EOH
            sudo npm install -g codebox -f
            EOH
        not_if { ::File.exists?(install_path + '/node_modules/codebox/bin/codebox.js') }
    end


    config = {}
    config['user'] = user
    config['install_path'] = install_path
    config['sync_dir'] = node['teracy-dev']['codebox']['sync_dir']
    config['port'] = node['teracy-dev']['codebox']['port']
    config['script_name'] = '/etc/init.d/codebox'

    # rubocop:disable HashSyntax
    template config['script_name'] do
        source 'codebox.init.erb'
        mode 0755
        owner 'root'
        group 'root'
        variables(:config => config)
        action :create
    end


    service 'codebox' do
        supports :status => true, :restart => true
        stop_command config['script_name'] + ' stop'
        action [:stop]
    end

    service 'codebox' do
        supports :status => true, :restart => true
        start_command config['script_name'] + ' start'
        action [:enable, :start]
    end
end
