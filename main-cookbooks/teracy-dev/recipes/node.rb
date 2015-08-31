#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: node
#

if node['teracy-dev']['nodejs']['enabled']

    node_version = ''
    npm_version = ''
    begin
        node_version = Mixlib::ShellOut.new('node -v').run_command.stdout
        node_version = node_version[1..node_version.length-2]
        npm_version = Mixlib::ShellOut.new('npm -v').run_command.stdout
        npm_version = npm_version[0..npm_version.length-2]
    rescue Exception => e
        node_version = ''
        npm_version = ''
    end

    if !node['teracy-dev']['nodejs']['version'].strip().empty?
        if node_version != node['teracy-dev']['nodejs']['version'].strip()
            node.override['nodejs']['version'] = node['teracy-dev']['nodejs']['version']
            node.override['nodejs']['source']['checksum'] = node['teracy-dev']['nodejs']['checksum']
            node.override['nodejs']['install_method'] = 'source'
            include_recipe 'nodejs'
        end
    else
        include_recipe 'nodejs'
    end


    if !node['teracy-dev']['nodejs']['npm']['version'].strip().empty? and
            npm_version != node['teracy-dev']['nodejs']['npm']['version'].strip()
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

    bash 'clean up tmp dir if need' do
        code <<-EOF
            rm -rf /home/vagrant/tmp
        EOF
        only_if 'ls /home/vagrant/tmp'
    end
    bash 'clean up ~/.npm if need' do
        code <<-EOF
            rm -rf /home/vagrant/.npm
        EOF
        only_if 'ls /home/vagrant/.npm'
    end
end
