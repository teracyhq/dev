#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: node
#

if node['teracy-dev']['nodejs']['enabled']

    if !node['teracy-dev']['nodejs']['version'].strip().empty?
        node.override['nodejs']['version'] = node['teracy-dev']['nodejs']['version']
        node.override['nodejs']['checksum'] = node['teracy-dev']['nodejs']['checksum']
        node.override['nodejs']['install_method'] = 'source'
    end

    include_recipe 'nodejs'

    if !node['teracy-dev']['nodejs']['npm']['version'].strip().empty?
        node.override['nodejs']['npm'] = node['teracy-dev']['nodejs']['npm']['version']
        include_recipe 'nodejs::npm'
    end


    node['teracy-dev']['nodejs']['npm']['globals'].each do |pkg|
        #TODO(hoatle): need to check bin_path to make sure time saving?
        bin_path = '/usr/local/bin/'
        if pkg['name'] == 'grunt-cli'
            bin_path += 'grunt'
        else
            bin_path += pkg['name']
        end
        npm_package pkg['name'] do
            version pkg['version']
            action :install
            not_if { ::File.exists?(bin_path) }
        end
    end
 
end
