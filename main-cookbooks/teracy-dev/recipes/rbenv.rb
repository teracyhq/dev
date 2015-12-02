#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: rbenv
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

if node['teracy-dev']['ruby']['enabled']
    include_recipe 'rbenv::default'
    include_recipe 'rbenv::ruby_build'
    ruby_versions = [] + node['teracy-dev']['ruby']['versions']
    if ruby_versions.empty? 
        if not node['teracy-dev']['ruby']['global_version'].empty?
            ruby_versions.push(node['teracy-dev']['ruby']['global_version'])
        end 
    end

    if ruby_versions.any? 
        ruby_versions.each do |ruby_version|
            if not ruby_version.empty? 
                rbenv_ruby ruby_version.strip() do
                    global true
                end

                node['teracy-dev']['ruby']['globals'].each do |pkg|
                    rbenv_gem pkg['name'] do
                        if !pkg['version'].strip().empty?
                            version pkg['version']
                        end
                    end
                end
            end
        end
        bash 'update ruby version to default' do
            code <<-EOF
                rbenv global #{node['teracy-dev']['ruby']['global_version']}
            EOF
            environment 'HOME'=> node['rbenv']['user_home'], 'USER'=> node['rbenv']['user'] , 'RBENV_ROOT'=>'/opt/rbenv'
            user node['rbenv']['user']
            group node['rbenv']['group']
        end
    end
end
