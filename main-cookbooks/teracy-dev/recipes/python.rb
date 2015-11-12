#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: python
# Description: Installs Python platform
#
# Copyright 2013, Teracy, Inc.
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

if node['teracy-dev']['python']['enabled']
    node.default['pyenv']['git_ref'] = node['teracy-dev']['python']['pyenv']['git_ref']
    node.default['pyenv']['user_installs'] = [
      { 'user' => 'vagrant',
        'pythons' => node['teracy-dev']['python']['versions'],
        'global' => node['teracy-dev']['python']['global_version']
      }
    ]
    include_recipe 'pyenv::user'

#    %w{libpq-dev python-dev}.each do |pkg|
#        apt_package pkg do
#            action:install
#        end
#    end


    # => git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git /usr/local/pyenv/plugins/pyenv-virtualenvwrapper

    include_recipe 'teracy-dev::virtualenvwrapper'
    include_recipe 'teracy-dev::pip_config'


    bash 'mkdir_user_bin' do
      code <<-EOF
        mkdir /home/vagrant/.bin/
      EOF
      not_if 'ls -la /home/vagrant/.bin/', :user => 'vagrant'
      user 'vagrant'
    end


    # install global packages
    node['teracy-dev']['python']['versions'].each do |version|

        node.default['python']['install_method'] = 'source'
        node.default['python']['prefix_dir'] = "home/vagrant/.pyenv/versions/#{version}"
        node.default['python']['binary'] = '/home/vagrant/.pyenv/shims/python'
        node.default['python']['pip_location'] = '/home/vagrant/.pyenv/shims/pip'

        bash 'change_default_python_version' do
            code <<-EOF
                echo $PYENV_VERSION > /home/vagrant/.pyenv/version
            EOF
            environment 'PYENV_VERSION' => version
            user 'vagrant'
        end

        node['teracy-dev']['python']['pip']['globals'].each do |pkg|
            python_pip "install #{pkg['name']}" do
                package_name pkg['name']
                if !pkg['version'].nil? and !pkg['version'].strip().empty?
                    version pkg['version']
                end
                only_if { pkg['supported_python_versions'].nil? or
                          pkg['supported_python_versions'].empty? or
                          pkg['supported_python_versions'].include?(version)
                        }
                user 'vagrant'
                environment 'PYENV_VERSION' => version
            end
        end
        # Link the the pyenv's to system path
        minor_version = version.split('.')[0,2].join('.')
        link "/home/vagrant/.bin/python#{minor_version}" do
          to "/home/vagrant/.pyenv/versions/#{version}/bin/python"
          user 'vagrant'
        end
    end

    bash 'Restore default python version and update shims' do
        code <<-EOF
            source /etc/profile
            echo $PYENV_VERSION > /home/vagrant/.pyenv/version
            pyenv rehash
        EOF
        environment 'PYENV_VERSION' => node['teracy-dev']['python']['global_version'], 'HOME'=>'/home/vagrant/'
    end
    user 'vagrant'
end
