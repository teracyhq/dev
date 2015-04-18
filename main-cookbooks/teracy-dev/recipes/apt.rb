#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: apt
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


bash 'backup_sources.list' do
    code <<-EOF
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
    EOF
    not_if { ::File.exist?('/etc/apt/sources.list.bak') or node['teracy-dev']['apt']['mirror'].strip().empty? }
end


template '/etc/apt/sources.list' do
    source 'source.list.erb'
    owner 'root'
    group 'root'
    mode '0644'
    not_if { node['teracy-dev']['apt']['mirror'].strip().empty? }
end

bash 'restore_backup_sources.list' do
    code <<-EOF
        cp /etc/apt/sources.list.bak /etc/apt/sources.list
    EOF
    only_if { ::File.exist?('/etc/apt/sources.list.bak') and node['teracy-dev']['apt']['mirror'].strip().empty? }
end


if !node['teracy-dev']['apt']['repositories'].empty?
    Chef::Log.info 'repositories management'
    # see: https://github.com/opscode-cookbooks/apt/blob/v2.6.0/README.md
    node['teracy-dev']['apt']['repositories'].each do |repo|
        attributes = repo['attributes']

        apt_repository repo['name'].strip() do

            if attributes and !attributes.empty?
                if attributes['repo_name'] and !attributes['repo_name'].strip().empty?
                    repo_name attributes['repo_name'].strip()
                end

                if attributes['uri'] and !attributes['uri'].strip().empty?
                    uri attributes['uri'].strip()
                end

                if attributes['distribution'] and !attributes['distribution'].strip().empty?
                    distribution attributes['distribution'].strip()
                end

                if attributes['components'] and !attributes['components'].empty?
                    components attributes['components']
                end

                if attributes['arch'] and !attributes['arch'].strip().empty?
                    arch attributes['arch'].strip()
                end

                if attributes['trusted'] == true
                    trusted attributes['trusted']
                end

                if attributes['deb_src'] == true
                    deb_src attributes['deb_src']
                end

                if attributes['keyserver'] and !attributes['keyserver'].strip().empty?
                    keyserver attributes['keyserver'].strip()
                end

                if attributes['key'] and !attributes['key'].strip().empty?
                    key attributes['key'].strip()
                end

                if attributes['key_proxy'] and !attributes['key_proxy'].strip().empty?
                    key_proxy attributes['key_proxy'].strip()
                end

                if attributes['cookbook'] and !attributes['cookbook'].strip().empty?
                    cookbook attributes['cookbook'].strip()
                end
            end

            if repo['action'] and !repo['action'].strip().empty?
                action repo['action']
            else
                action :add
            end
        end
    end
end

include_recipe 'apt'

if !node['teracy-dev']['apt']['packages'].empty?
    Chef::Log.info 'packages management'
    # see: https://docs.chef.io/resource_apt_package.html
    node['teracy-dev']['apt']['packages'].each do |pkg|
        attributes = pkg['attributes']

        apt_package pkg['name'].strip() do
            if attributes and !attributes.empty?
                # if attributes['arch'] and !attributes['arch'].strip().empty?
                #     arch attributes['arch'].strip()
                # end

                if attributes['options'] and !attributes['options'].strip().empty?
                    options attributes['options'].strip()
                end

                if attributes['package_name'] and !attributes['package_name'].strip().empty?
                    package_name attributes['package_name'].strip()
                end

                if attributes['provider'] and !attributes['provider'].strip().empty?
                    provider attributes['provider'].strip()
                end

                if attributes['response_file'] and !attributes['response_file'].strip().empty?
                    response_file attributes['response_file'].strip()
                end

                if attributes['source'] and !attributes['source'].strip().empty?
                    source attributes['source'].strip()
                end

                if attributes['version'] and !attributes['version'].strip().empty?
                    version attributes['version']
                end
            end

            if pkg['action'] and !pkg['action'].strip().empty?
                action pkg['action']
            else
                action :install
            end
        end
    end
end
