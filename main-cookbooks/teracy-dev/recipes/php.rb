#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: php
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['php']['enabled']
    if !node['teracy-dev']['php']['version'].strip().empty?
        node.override['php']['version'] = node['teracy-dev']['php']['version']
        node.override['php']['checksum'] = node['teracy-dev']['php']['version']
        node.override['php']['install_method'] = 'source'
    end
    include_recipe 'php'
end
