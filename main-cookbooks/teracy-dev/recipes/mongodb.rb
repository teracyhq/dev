#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: mongodb
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['mongodb']['enabled']
    if !node['teracy-dev']['mongodb']['version'].strip().empty?
        node.override['mongodb']['version'] = node['teracy-dev']['mongodb']['version']
        node.override['mongodb']['install_method'] = 'mongodb-org'
    end
    
    include_recipe 'mongodb::default'

end
