#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: node
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

if node['teracy-dev']['nodejs']['enabled']

    node_version = ''
    npm_version = ''
    begin
        node_version = Mixlib::ShellOut.new('node -v').run_command.stdout
        node_version = node_version[1..node_version.length-2]
        npm_version = Mixlib::ShellOut.new('npm -v').run_command.stdout
        npm_version = npm_version[0..npm_version.length-2]
    rescue Exception => e
        node_version = ''
        npm_version = ''
    end

    if !node['teracy-dev']['nodejs']['version'].strip().empty?
        if node_version != node['teracy-dev']['nodejs']['version'].strip()
            node.override['nodejs']['version'] = node['teracy-dev']['nodejs']['version']
            node.override['nodejs']['source']['checksum'] = node['teracy-dev']['nodejs']['checksum']
            node.override['nodejs']['install_method'] = 'source'
            include_recipe 'nodejs'
        end
    else
        include_recipe 'nodejs'
    end


    if !node['teracy-dev']['nodejs']['npm']['version'].strip().empty? and
            npm_version != node['teracy-dev']['nodejs']['npm']['version'].strip()
        node.override['nodejs']['npm'] = node['teracy-dev']['nodejs']['npm']['version']
        include_recipe 'nodejs::npm'
    end


    node['teracy-dev']['nodejs']['npm']['globals'].each do |pkg|
        #TODO(hoatle): need to check bin_path to make sure time saving?
        bin_path = '/usr/local/bin/'
        if pkg['name'] == 'grunt-cli'
            bin_path += 'grunt'
        else
            bin_path += pkg['name']
        end
        npm_package pkg['name'] do
            version pkg['version']
            action :install
            not_if { ::File.exists?(bin_path) }
        end
    end

    bash 'clean up tmp dir if need' do
        code <<-EOF
            rm -rf /home/vagrant/tmp
        EOF
        only_if 'ls /home/vagrant/tmp'
    end

end
