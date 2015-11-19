#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: java
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

if node['teracy-dev']['java']['enabled']
    node.default['java']['accept_license_agreement'] = true
    node.default['java']['jdk_version'] = node['teracy-dev']['java']['version']

    if node['teracy-dev']['java']['flavor'] == 'oracle'
        node.default['java']['oracle']['accept_oracle_download_terms'] = true
    end

    node.default['java']['install_flavor'] = node['teracy-dev']['java']['flavor']

    include_recipe 'java::default'

    if node['teracy-dev']['java']['maven']['enabled']
        node.default['maven']['install_java'] = false
        maven_version = node['teracy-dev']['java']['maven']['version']
        maven_checksum = node['teracy-dev']['java']['maven']['checksum']

        if maven_version.nil? or maven_version.strip().empty?
            Chef::Log.warn('maven_version is nil or empty, set to install 3.2.5 as default')
            maven_version = '3.2.5'
            maven_checksum = '8c190264bdf591ff9f1268dc0ad940a2726f9e958e367716a09b8aaa7e74a755'
        end

        mirror = 'http://www.us.apache.org/dist/'
        specified_mirror = node['teracy-dev']['java']['maven']['mirror']
        if !specified_mirror.nil? and !specified_mirror.strip().empty?
            mirror = specified_mirror
            #TODO(hoatle): add the trailing slash if missing?
        end

        enabled_to_install = false

        if !/^3\.\d+\.\d+$/.match(maven_version).nil?
            enabled_to_install = true
            maven_url = "#{mirror}maven/maven-3/#{maven_version}/binaries/apache-maven-#{maven_version}-bin.tar.gz"
            node.default['maven']['version'] = 3
            node.default['maven']['3']['version'] = maven_version
            node.default['maven']['3']['url'] = maven_url
            node.default['maven']['3']['checksum'] = maven_checksum
        elsif !/^2\.\d+\.\d+$/.match(maven_version).nil?
            enabled_to_install = true
            maven_url = "#{mirror}maven/maven-2/#{maven_version}/binaries/apache-maven-#{maven_version}-bin.tar.gz"
            node.default['maven']['version'] = 2
            node.default['maven']['2']['version'] = maven_version
            node.default['maven']['2']['url'] = maven_url
            node.default['maven']['2']['checksum'] = maven_checksum
        else
            Chef::Log.error('maven 2.x.x and 3.x.x are only supported. Specified version: ' + maven_version)
        end

        if enabled_to_install
            m2_home = node['teracy-dev']['java']['maven']['m2_home']
            repositories = node['teracy-dev']['java']['maven']['repositories']
            setup_bin = node['teracy-dev']['java']['maven']['setup_bin']
            mavenrc_opts = node['teracy-dev']['java']['maven']['maverc_opts']

            if !m2_home.nil? and !m2_home.strip().empty?
                node.default['maven']['m2_home'] = m2_home
            end

            if repositories.kind_of?(Array) and !repositories.empty?
                node.default['maven']['repositories'] = repositories
            end

            # false by default
            if !setup_bin.nil? and setup_bin
                node.default['maven']['setup_bin'] = true
            else
                node.default['maven']['setup_bin'] = false
            end

            if !mavenrc_opts.nil? and !mavenrc_opts.strip().empty?
                node.default['maven']['mavenrc']['opts'] = mavenrc_opts
            end

            include_recipe 'maven::default'
        end
    end
end
