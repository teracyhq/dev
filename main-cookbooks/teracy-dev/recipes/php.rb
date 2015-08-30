#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: php
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['php']['enabled']
  if !node['teracy-dev']['php']['version'].strip().empty?

      package 'apache2-dev' do
        action :install
        only_if {node['teracy-dev']['apache']['enabled']}
      end

      bash 'remove php version if need' do
        code <<-EOF
          php_binary=$(which php);
          php_version=$(php -r '@phpinfo();' | grep 'PHP Version' -m 1 | awk '{print $4}');

          if [ "$php_version" != "#{node['teracy-dev']['php']['version']}" ] || [ ! -f /usr/lib/apache2/modules/mod_php5.so ]; then
              rm -R `ls -1 -d /var/chef/cache/php*/`
              apt-get remove php5* -f || true
              rm $php_binary -rf || true
              rm /usr/lib/apache2/modules/libphp5.so -rf || true
              rm /usr/lib/apache2/modules/mod_php5.so -rf || true
          fi
        EOF
        only_if 'which php'
        user 'root'
      end

      node.override['php']['version'] = node['teracy-dev']['php']['version']
      node.override['php']['checksum'] = node['teracy-dev']['php']['checksum']
      node.override['php']['install_method'] = 'source'

      if node['teracy-dev']['apache']['enabled']
        node.override['php']['configure_options'] = ['--with-apxs2=/usr/bin/apxs2'] + node['php']['configure_options']
      end

     	include_recipe 'php'

      if node['teracy-dev']['apache']['enabled']
        bash 'update apache2 php modules to source' do
          code <<-EOF
            mv /usr/lib/apache2/modules/libphp5.so /usr/lib/apache2/modules/mod_php5.so
            echo 'LoadModule php5_module        /usr/lib/apache2/modules/mod_php5.so' > /etc/apache2/mods-available/php5.load
          EOF
          user 'root'
          only_if 'ls -la /usr/lib/apache2/modules/libphp5.so'
        end
      end

      package 'apache2-dev' do
        action :install
        only_if {node['teracy-dev']['apache']['enabled']}
      end

  else
  	include_recipe 'php'
    if  node['teracy-dev']['mysql']['enabled']
		  include_recipe 'php::module_mysql'
    end
  end

  bash 'clean up apache mess' do
      code <<-EOF
          a2enmod php5 || true;
          service apache2 restart;
      EOF
      user 'root'
      only_if {node['teracy-dev']['apache']['enabled']}
  end

  if node['teracy-dev']['nginx']['enabled']
    apt_package 'php5-fpm' do
      action :install
    end
    bash 'add php fpm' do
      code <<-EOF
        rm -rf /etc/php5/conf.d/pdo.ini
        rm -rf /etc/php5/*/conf.d/pdo.ini
        sed -i 's/NAME=php5-fpm/NAME=php-fpm/' /etc/init.d/php5-fpm
        sed -i 's/DAEMON=\\/usr\\/sbin/DAEMON=\\/usr\\/local\\/sbin/' /etc/init.d/php5-fpm
        killall php5-fpm
        killall php-fpm
        /etc/init.d/php5-fpm start
      EOF
    end
  end
  %w(cli fpm).each do |conf_type|
    bash "update php timezone for php #{conf_type}" do
      code <<-EOF
        sed -i 's/;date.timezone =/date.timezone = "UTC"/' /etc/php5/#{conf_type}/php.ini
      EOF
      user 'root'
      only_if {File.exist?("/etc/php5/#{conf_type}/php.ini")}
    end

    bash "update php mysql_socket_path for php #{conf_type}" do
      code <<-EOF
        sed -i 's/^mysql.default_socket =$/mysql.default_socket = \\/var\\/run\\/mysqld\\/mysqld.sock/' /etc/php5/#{conf_type}/php.ini
      EOF
      user 'root'
      only_if {File.exist?("/etc/php5/#{conf_type}/php.ini")}
    end
  end

  bash 'add_laravel_executable_to_path' do
      code <<-EOF
        echo 'export PATH=~/.composer/vendor/bin/:$PATH' | tee --append ~/.bash_profile
      EOF
      environment 'HOME'=>'/home/vagrant/'
      not_if 'grep -q ".composer" /home/vagrant/.bash_profile'
      user 'vagrant'
  end
end
