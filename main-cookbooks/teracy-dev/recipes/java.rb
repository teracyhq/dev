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
end
