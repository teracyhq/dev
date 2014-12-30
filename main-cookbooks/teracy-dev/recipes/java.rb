#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: java
#
# Copyright 2014, Teracy, Inc.
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
