#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: php
#
# Copyright 2013 - current, Teracy, Inc.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
#        to endorse or promote products derived from this software without
#        specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

if node['teracy-dev']['php']['enabled']
  if !node['teracy-dev']['php']['version'].strip().empty?

      package 'apache2-dev' do
        action :install
        only_if {node['teracy-dev']['apache']['enabled']}
      end

      apt_package 'libgmp-dev' do
        action :install
      end
      apt_package 'libicu-dev' do
        action :install
      end
      link '/usr/include/gmp.h' do
        to '/usr/include/x86_64-linux-gnu/gmp.h'
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
        node.override['php']['configure_options'] = ['--enable-intl'] + ['--with-apxs2=/usr/bin/apxs2'] + node['php']['configure_options']
      end

     	include_recipe 'php'

      if node['teracy-dev']['apache']['enabled']
        bash 'update apache2 php modules to source' do
          code <<-EOF
            mv /usr/lib/apache2/modules/libphp5.so /usr/lib/apache2/modules/mod_php5.so
            echo 'LoadModule php5_module        /usr/lib/apache2/modules/mod_php5.so' > /etc/apache2/mods-available/php5.load
            sed -i 's/#AddType application\\/x-gzip .tgz/AddType application\\/x-httpd-php .php\\n  AddType application\\/x-httpd-php-source .phps\\n/' /etc/apache2/mods-available/mime.conf
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
    apt_package 'php5-intl' do
      action :install
    end
  end

  bash 'clean up apache mess' do
      code <<-EOF
          a2enmod php5 || true;
          a2dismod mpm_event || true
          a2enmod mpm_prefork || true
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
        rm -rf /etc/php5/conf.d/*-pdo.ini /etc/php5/conf.d/*-json.ini /etc/php5/conf.d/*-opcache.ini
        rm -rf /etc/php5/*/conf.d/*-pdo.ini /etc/php5/*/conf.d/*-json.ini /etc/php5/*/conf.d/*-opcache.ini
        rm -rf /etc/php5/mods-available
        sed -i 's/NAME=php5-fpm/NAME=php-fpm/' /etc/init.d/php5-fpm
        sed -i 's/DAEMON=\\/usr\\/sbin/DAEMON=\\/usr\\/local\\/sbin/' /etc/init.d/php5-fpm
        sed -i 's/exec \\/usr\\/sbin\\/php5-fpm/exec \\/usr\\/local\\/sbin\\/php-fpm/' /etc/init/php5-fpm.conf
        sed -i 's/;listen.mode = 0660/listen.mode = 0666/' /etc/php5/fpm/pool.d/www.conf
        service stop php5-fpm
        killall php5-fpm
        killall php-fpm
        /etc/init.d/php5-fpm start || true
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
        sed -i 's/^mysql.default_socket =$/mysql.default_socket=\\/run\\/mysql-default\\/mysqld.sock/' /etc/php5/#{conf_type}/php.ini
        sed -i 's/^pdo_mysql.default_socket=$/pdo_mysql.default_socket=\\/run\\/mysql-default\\/mysqld.sock/' /etc/php5/#{conf_type}/php.ini
        sed -i 's/^mysqli.default_socket =$/mysqli.default_socket=\\/run\\/mysql-default\\/mysqld.sock/' /etc/php5/#{conf_type}/php.ini
      EOF
      user 'root'
      only_if {File.exist?("/etc/php5/#{conf_type}/php.ini")}
    end
  end

  include_recipe 'composer'

  bash 'add composer executable to path' do
      code <<-EOF
        echo 'export PATH=~/.composer/vendor/bin/:$PATH' | tee --append ~/.bash_profile
      EOF
      environment 'HOME'=>'/home/vagrant/'
      only_if 'grep -q ".composer" /home/vagrant/.bash_profile'
      user 'vagrant'
  end
end
