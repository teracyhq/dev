# nvm

Chef cookbook for setting up NVM from [creationix's github repository](https://github.com/creationix/nvm).

## Requirements

Built to run on Linux distributions. Tested on Ubuntu 12.04.
Depends on the `git` cookbook.

## Usage

Install nvm and node.js version 0.10.5.

```ruby
# install nvm
include_recipe 'nvm'

# install node.js v0.10.5
nvm_install 'v0.10.5'  do
	from_source false
	alias_as_default true
	action :create
end
```

For more usage examples, have a look to the recipes in `test/cookbooks/nvm_test/recipes/`.

## Attributes

* `node['nvm']['directory']` - directory where nvm is cloned, default '/usr/local/src/nvm'
* `node['nvm']['repository']` - url of the git repository, default 'git://github.com/creationix/nvm.git'
* `node['nvm']['reference']` - reference in the repository, default 'master'
* `node['nvm']['source']` - command to source nvm script file, default 'source /etc/profile.d/nvm.sh'
* `node['nvm']['install_deps_to_build_from_source']` - if true install the dependencies to compile node, otherwise not, default true

## LWRPs

### nvm_install

Install a node.js version from source or binaries

#### Actions

- `create` (default)

#### Attributes

- `version` - node.js version, default to the name attribute
- `from_source` - install from source if true, default to false
- `alias_as_default` - alias the current version as the default version, default true

##### Only used for user install
- `user_install` - install nvm for a particular user, default false
- `user` - user to install nvm as, no default
- `group` - group to install nvm as, defaults to user
- `user_nome` - home directory of user for user install if it is a non standard home directory, default /home/$user
- `nvm_directory` -

#### Examples

Install from binary

```ruby
nvm_install '0.10.5'  do
	from_source false
	alias_as_default true
	action :create
end
```

Install from source

```ruby
nvm_install '0.10.5'  do
	from_source true
	alias_as_default true
	action :create
end
```

Install as user

```ruby
nvm_install '0.10.5' do
  user 'myuser'
  group 'mygroup'
  from_source false
  alias_as_default true
  action :create
end
```

Multiple user installs

```ruby
nvm_install 'nvm for userone' do
  version '0.10.5'
  user 'userone'
  group 'userone'
  from_source false
  alias_as_default true
  action :create
end
```

```ruby
nvm_install 'nvm for usertwo' do
  version '0.10.5'
  user 'usertwo'
  group 'usertwo'
  from_source false
  alias_as_default true
  action :create
end
```

Nonstandard user home user install

```ruby
nvm_install '0.10.5' do
  user 'usertwo'
  group 'usertwo'
  user_home '/opt/usertwo'
  from_source false
  alias_as_default true
  action :create
end
```


### nvm_alias_default

Use by default the given node.js version

#### Actions

- `create` (default)

#### Attributes

- `version` - node.js version, default to the name attribute

#### Example

Use by default node.js version 0.10.0

```ruby
nvm_alias_default '0.10.0'  do
	action :create
end
```

## Cookbook development

You will need to do a couple of things to be up to speed to hack on this cookbook.
Everything is explained [here](https://github.com/hipsnip-cookbooks/cookbook-development) have a look.

## Test

```bash
bundle exec rake cookbook:full_test
```

## Licence

Author: Rémy Loubradou

Copyright 2013 HipSnip Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
