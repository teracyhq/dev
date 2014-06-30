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

    if !node['teracy-dev']['postgresql']['password'].strip().empty?
        node.override['postgresql']['password'] = node['teracy-dev']['postgresql']['password']
    end

    include_recipe 'postgresql::default'

end
