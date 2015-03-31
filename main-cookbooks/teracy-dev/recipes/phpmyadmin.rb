#
# Author:: PhuongLM <phuonglm@teracy.com>
# Cookbook Name:: dev
# Recipe:: phpmyadmin
#
# Copyright 2015, Teracy, Inc.
#
if node['teracy-dev']['phpmyadmin']['enabled']
    node.override['phpmyadmin']['home'] = node['teracy-dev']['phpmyadmin']['install_dir']
    node.override['phpmyadmin']['fpm'] = false
    include_recipe 'phpmyadmin::default'

    if node['teracy-dev']['apache']['enabled']
        template "#{node['apache']['dir']}/sites-available/phpMyAdmin.conf" do
            source 'phpmyadmin_apache_site.erb'
            owner 'root'
            group 'root'
            mode '0664'
        end

        link "#{node['apache']['dir']}/sites-enabled/phpMyAdmin.conf" do
            to "#{node['apache']['dir']}/sites-available/phpMyAdmin.conf"
        end
        bash 'restart Apache' do
            code <<-EOF
                service apache2 restart;
            EOF
            user 'root'
        end
    elsif node['teracy-dev']['nginx']['enabled']
        template "#{node['nginx']['dir']}/sites-available/phpMyAdmin.conf" do
            source 'phpmyadmin_nginx_site.erb'
            owner 'root'
            group 'root'
            mode '0664'
        end

        link "#{node['nginx']['dir']}/sites-enabled/phpMyAdmin.conf" do
            to "#{node['nginx']['dir']}/sites-available/phpMyAdmin.conf"
        end
        bash 'restart Apache' do
            code <<-EOF
                service nginx restart;
            EOF
            user 'root'
        end
    end
end