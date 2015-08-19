#
# Cookbook Name:: phpmyadmin
# Attributes:: default
#
# Copyright 2012, Panagiotis Papadomitsos
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['phpmyadmin']['version'] = '4.3.13.1'
default['phpmyadmin']['checksum'] = '2e5c2ca358d9510c793bb709338f0836c56f4c151018ad36a74da1d32df9fcd3'
default['phpmyadmin']['mirror'] = 'https://files.phpmyadmin.net/phpMyAdmin/'
default['phpmyadmin']['server_name'] = node['fqdn']

default['phpmyadmin']['fpm'] = true
default['phpmyadmin']['stand_alone'] = true

default['phpmyadmin']['home'] = '/opt/phpmyadmin'
default['phpmyadmin']['user'] = 'phpmyadmin'
default['phpmyadmin']['group'] = 'phpmyadmin'
default['phpmyadmin']['socket'] = '/tmp/phpmyadmin.sock'

if Chef::Config[:solo]
  default['phpmyadmin']['blowfish_secret'] = '7654588cf9f0f92f01a6aa361d02c0cf038'
end

case node['platform_family']
when 'debian'
  default['phpmyadmin']['upload_dir'] = '/var/lib/php5/uploads'
  default['phpmyadmin']['save_dir'] = '/var/lib/php5/uploads'
when 'rhel'
  default['phpmyadmin']['upload_dir'] = '/var/lib/php/uploads'
  default['phpmyadmin']['save_dir'] = '/var/lib/php/uploads'
end
default['phpmyadmin']['maxrows'] = 100
default['phpmyadmin']['protect_binary'] = 'blob'
default['phpmyadmin']['default_lang'] = 'en'
default['phpmyadmin']['default_display'] = 'horizontal'
default['phpmyadmin']['query_history'] = true
default['phpmyadmin']['query_history_size'] = 100

default['phpmyadmin']['config_template'] = 'config.inc.php.erb'
default['phpmyadmin']['config_template_cookbook'] = 'phpmyadmin'

default['phpmyadmin']['force_ssl'] = false

