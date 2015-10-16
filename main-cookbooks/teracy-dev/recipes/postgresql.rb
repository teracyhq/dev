#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: postgresql
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['postgresql']['enabled']
    if !node['teracy-dev']['postgresql']['version'].strip().empty?
        node.override['postgresql']['version'] = node['teracy-dev']['postgresql']['version']
    end

    node.override['postgresql']['config']['listen_addresses'] = '*'

    node.override['postgresql']['pg_hba'] = [
      {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
      {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
      {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'md5'},
      {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
    ]

    node.override['postgresql']['password'] = node['teracy-dev']['postgresql']['password']

    if node['teracy-dev']['postgresql']['install_postgis']
      include_recipe 'postgresql::default'
      include_recipe 'postgresql::server'
      include_recipe 'postgis::default'
    else
      include_recipe 'postgresql::default'
      include_recipe 'postgresql::server'
    end
end
