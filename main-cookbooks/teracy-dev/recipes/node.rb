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

    # install nvm
    include_recipe 'nvm'

    global_npm_has_phantomjs = false
    node['teracy-dev']['nodejs']['npm']['globals'].each do |pkg|
        if pkg['name'] == 'phantomjs'
            global_npm_has_phantomjs = true
        end
    end

    # PhantomJS need sudo to resolve it dependence https://github.com/ariya/phantomjs/issues/10904
    package 'libfontconfig' do
        action :install
        only_if { global_npm_has_phantomjs }
    end

    node['teracy-dev']['nodejs']['versions'].each do |version|
        nvm_install version  do
            from_source false
            alias_as_default (version == node['teracy-dev']['nodejs']['global_version'])
            action :create
            user_install true
            user 'vagrant'
            group 'vagrant'
        end

        node['teracy-dev']['nodejs']['npm']['globals'].each do |pkg|
            if version.start_with?('0.') and !version.start_with?('0.12.')
                node_path = "/home/vagrant/.nvm/v#{version}"
            else
                node_path = "/home/vagrant/.nvm/versions/node/v#{version}"
            end

            #TODO(hoatle): need to check bin_path to make sure time saving?
            bin_path = "#{node_path}/bin/"
            if pkg['name'] == 'grunt-cli'
                package_path = bin_path + 'grunt'
            else
                package_path = bin_path + pkg['name']
            end

            bash 'install global npm package' do
            code <<-EOF
                source /home/vagrant/.nvm/nvm.sh
                nvm use #{version}
                npm install -g #{pkg['name']}@#{pkg['version']}
                sudo chown vagrant:vagrant #{node_path} -R
            EOF
            environment 'HOME'=>'/home/vagrant', 'USER'=>'vagrant', 
                'NVM_BIN'=>"#{node_path}/bin", 'NVM_DIR'=>'/home/vagrant/.nvm', 'NVM_PATH'=>"#{node_path}/lib/node"
            not_if { ::File.exists?(package_path) }
            user 'vagrant'
            group 'vagrant'
            end
        end
    end

    bash 'clean up tmp dir if need' do
        code <<-EOF
            rm -rf /home/vagrant/tmp
        EOF
        only_if 'ls /home/vagrant/tmp'
    end

end
