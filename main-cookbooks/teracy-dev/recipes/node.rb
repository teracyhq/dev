#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: node
#

if node['teracy-dev']['nodejs']['enabled']

    include_recipe 'nodejs'

    node['teracy-dev']['nodejs']['npm'].each do |pkg|
        bin_path = '/usr/local/bin/'
        if pkg == 'grunt-cli'
            bin_path += 'grunt'
        else
            bin_path += pkg
        end
        npm_package pkg do
            action :install
            not_if { ::File.exists?(bin_path) }
        end
    end

end
