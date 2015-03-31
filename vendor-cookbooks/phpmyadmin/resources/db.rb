#
# Cookbook Name:: phpmyadmin
# Resource:: db
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

default_action :create

actions :create, :delete

attribute :name,	 		:kind_of => String, :required => true, :name_attribute => true
attribute :host,			:regex => /[a-z0-9\.\-]+/, :required => true
attribute :port,			:kind_of => Fixnum, :default => 3306
attribute :username,		:kind_of => String, :required => true
attribute :password,		:kind_of => String, :required => true
attribute :hide_dbs,		:kind_of => [ Array, String ], :default => []
attribute :pma_username,	:kind_of => String, :default => ''
attribute :pma_password,	:kind_of => String, :default => ''
attribute :pma_database,	:kind_of => String, :default => ''
attribute :auth_type,       :kind_of => String, :default => 'config'
