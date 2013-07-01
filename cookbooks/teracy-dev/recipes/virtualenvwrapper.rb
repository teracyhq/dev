#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: virtualenvwrapper
#
# Copyright 2013, Teracy Inc.
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

python_pip 'virtualenvwrapper' do
  action :install
end

bash 'configure_virtualenvwrapper' do
	code <<-EOF
		echo 'export PROJECT_HOME=/vagrant/workspace/personal' >> /home/vagrant/.profile
		echo 'source /usr/local/bin/virtualenvwrapper.sh' >> /home/vagrant/.profile && source /home/vagrant/.profile
	EOF
    not_if 'grep -q /usr/local/bin/virtualenvwrapper.sh /home/vagrant/.profile'
end


