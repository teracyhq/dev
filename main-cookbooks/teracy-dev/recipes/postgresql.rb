#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: postgresql
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['postgresql']['enabled']

    node.override['postgresql']['config']['listen_addresses'] = '*'

    node.override['postgresql']['pg_hba'] = [
      {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
      {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
      {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'md5'},
      {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
    ]

    node.override['postgresql']['password'] = node['teracy-dev']['postgresql']['password']

    if node['teracy-dev']['postgresql']['postgis_enabled']
      if node['postgresql']['version'].to_f > 9.3
        # currently assume postgis-2.1 for postgresql version > 9.3
        node.override['postgis']['package'] = "postgresql-#{node['postgresql']['version']}-postgis-2.1"
      end
      include_recipe 'postgresql::default'
      include_recipe 'postgis::default'
    else
      include_recipe 'postgresql::default'
      include_recipe 'postgresql::server'
    end
end
