#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: php
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['php']['enabled']    	    
    include_recipe 'chef-dotdeb'
    include_recipe 'chef-dotdeb::php54'
    include_recipe 'php'
end
