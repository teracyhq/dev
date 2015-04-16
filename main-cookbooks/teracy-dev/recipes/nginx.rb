#
# Author:: Phuong <phuonglm@teracy.com>
# Cookbook Name:: dev
# Recipe:: nginx
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['nginx']['enabled']
    node.override['nginx']['default_site_enabled'] = false
    node.override['nginx']['source']['use_existing_user'] = true
    node.override['nginx']['sendfile'] = 'off'
    node.override['nginx']['install_method'] = 'source'
    node.override['nginx']['init_style'] = 'upstart'

    node.override['nginx']['version'] = node['teracy-dev']['nginx']['version']
    node.override['nginx']['source']['checksum'] = node['teracy-dev']['nginx']['checksum']
    node.override['nginx']['default_root'] = node['teracy-dev']['nginx']['default_root']
    node.override['nginx']['source']['prefix'] = '/opt/nginx'
    node.override['nginx']['prefix'] = '/opt/nginx'

    node.override['nginx']['user'] = 'vagrant'
    node.override['nginx']['group'] = 'vagrant'

    nginx_version = Mixlib::ShellOut.new('/opt/nginx/sbin/nginx -v 2>/dev/stdout | grep -o "[0-9]*\.[0-9]*\.[0-9]*"').run_command.stdout.gsub("\n","")

    if nginx_version != node['teracy-dev']['nginx']['version']
        bash 'clean up previous installed nginx' do
            code <<-EOF
                killall nginx || true
                rm /opt/nginx* -rf
                rm /etc/init.d/nginx* -rf
                rm /etc/nginx/ -rf
            EOF
            user 'root'
        end
        node.from_file(run_context.resolve_attribute('nginx', 'source'))
        include_recipe 'nginx'
    end
    template "#{node['nginx']['dir']}/sites-available/default.conf" do
        source 'nginx_site.erb'
        owner 'vagrant'
        group 'vagrant'
        mode '0664'
    end
    link "#{node['nginx']['dir']}/sites-enabled/default.conf" do
      to "#{node['nginx']['dir']}/sites-available/default.conf"
    end
end
