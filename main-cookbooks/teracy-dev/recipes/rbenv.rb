#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: rbenv
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

if node['teracy-dev']['ruby']['enabled']

    node.default['rbenv']['user']           = 'vagrant'
    node.default['rbenv']['group']          = 'vagrant'
    node.default['rbenv']['user_home']      = '/home/vagrant'

    include_recipe 'rbenv::default'
    include_recipe 'rbenv::ruby_build'

    node_version = node['teracy-dev']['ruby']['version']

    if node_version.strip().empty?
        begin
            versions = []
            list_versions = Mixlib::ShellOut.new('rbenv install -l').run_command.stdout

            list_versions.each_line.each do |line|
                if !line.include? 'dev'
                    versions.push(line.strip())
                end
            end

            node_version = versions.max {
                |a,b| a.split('.').map { |e| e.to_i } <=> b.split('.').map { |e| e.to_i }
            }
        rescue
            node_version = '2.1.2'
        end
    end



    rbenv_ruby node_version.strip() do
        global true
        only_if { !node_version.strip().empty? }
    end

    node['teracy-dev']['ruby']['globals'].each do |pkg|
        rbenv_gem pkg['name'] do
        	if !pkg['version'].strip().empty?
                version pkg['version']
            end
        end
    end

end
