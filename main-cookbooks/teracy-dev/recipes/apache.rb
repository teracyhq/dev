#
# Author:: Phuong <phuonglm@teracy.com>
# Cookbook Name:: dev
# Recipe:: nginx
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['apache']['enabled']
    node.default['apache']['default_site_enabled'] = false
    node.default['apache']['docroot_dir'] = node['teracy-dev']['apache']['default_root']
    node.default['apache']['listen_ports'] = [node['teracy-dev']['apache']['listen_port']]
    node.default['apache']['user'] = 'vagrant'
    node.default['apache']['group'] = 'vagrant'
    node.default['apache']['version'] = node['teracy-dev']['apache']['version']

    apache_installed = Mixlib::ShellOut.new('which apache2').run_command.stdout
    apache_version =  Mixlib::ShellOut.new('apache2 -v | grep -o "[0-9]\.[0-9]"').run_command.stdout
    if apache_installed == '' or apache_version != node['teracy-dev']['apache']['version']
        bash 'clean up previous install apapche' do
            code <<-EOF
                apt-get purge apache2 -y -f
                apt-get purge apache2* -y -f
                apt-get purge apache2 apache2-utils apache2.2-bin apache2-common -y -f
                apt-get install -y python-software-properties
                apt-get autoremove
                rm -rf /etc/apache2 && rm -rf /usr/lib/apache2
            EOF
            user 'root'
        end
        if node['teracy-dev']['apache']['version'] == '2.2'
            bash 'remove apache 2.4 ppa' do
                code <<-EOF
                    add-apt-repository -y --remove ppa:ondrej/apache2
                    apt-get update
                EOF
                user 'root'
            end
        else
            bash 'add apache 2.4 ppa' do
                code <<-EOF
                    add-apt-repository -y ppa:ondrej/apache2
                    apt-get update
                EOF
                user 'root'
            end
        end
        Mixlib::ShellOut.new('apt-get update').run_command

        include_recipe 'apache2'
    end

    file "#{node['apache']['dir']}/sites-available/default.conf" do
      action :delete
    end

    file "#{node['apache']['dir']}/sites-available/default-ssl" do
      action :delete
    end

    link "#{node['apache']['dir']}/sites-enabled/000-default" do
      action :delete
    end

    template "#{node['apache']['dir']}/sites-available/default.conf" do
        source 'apache_site.erb'
        owner 'vagrant'
        group 'vagrant'
        mode '0664'
    end
    link "#{node['apache']['dir']}/sites-enabled/default.conf" do
      to "#{node['apache']['dir']}/sites-available/default.conf"
    end

    directory '/var/lock/apache2' do
        owner 'vagrant'
        group 'vagrant'
        mode '0755'
    end

    bash 'clean up apache mess' do
        code <<-EOF
            a2dismod php5 || true;
            a2enmod vhost_alias || true;
            a2enmod proxy_fcgi || true;
            a2enmod proxy || true;
            cat /etc/apache2/apache2.conf | grep "EnableSendfile Off" || echo -e "EnableSendfile Off\nEnableMMAP Off" >> /etc/apache2/apache2.conf;
            ln -s /usr/sbin/apache2 /usr/sbin/httpd
            service apache2 stop || killall apache2
            service apache2 start;
        EOF
        user 'root'
    end
end
