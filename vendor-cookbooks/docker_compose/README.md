# Docker Compose Cookbook

The Docker Compose Cookbook is a library cookbook that provides custom
resources for use in recipes.


## Requirements

- Working Docker installation. You might want to use the excellent
[docker Cookbook](https://supermarket.chef.io/cookbooks/docker) to provision
Docker.


## Usage

Place a dependency on the docker-compose cookbook in your cookbook's
metadata.rb 

```ruby
depends 'docker_compose', '~> 0.0'
```

Create a [Docker Compose file](https://docs.docker.com/compose/compose-file/)
for the application you want to provision. A simple Compose file that uses the
[official nginx Docker image](https://hub.docker.com/_/nginx/) looks like this:

```
version: '2'
services:
  web_server:
    image: nginx
    ports:
      - "80:80"
```

Then, in a recipe:

```ruby
include_recipe 'docker_compose::installation'

# Provision Compose file
cookbook_file '/etc/docker-compose_nginx.yml' do
  source 'docker-compose_nginx.yml'
  owner 'root'
  group 'root'
  mode 0640
  notifies :up, 'docker_compose_application[nginx]', :delayed
end

# Provision Compose application
docker_compose_application 'nginx' do
  action :up
  compose_files [ '/etc/docker-compose_nginx.yml' ]
end
```

## Attributes

- `node['docker_compose']['release']` - The release version of Docker Compose
 to install. Defaults to a sane, current default.

- `node['docker_compose']['command_path']` - The path under which the
 `docker-compose` command should be installed.
 Defaults to `/usr/local/bin/docker-compose`


## Recipes

### default

The `default` recipe is simply an alias for the `installation` recipe.

### installation

The `installation` recipe installs the `docker-compose` binary by downloading
it from the vendor's servers, as described in the
[official Docker Compose documentation](https://docs.docker.com/compose/install/).

The path to which the `docker-compose` command is installed can be configured
via the `node['docker_compose']['command_path']` attribute.


## Resources
 
### docker_compose_application

The `docker_compose_application` provisions a Docker application (that usually
consists of several services) using a Docker Compose file.

#### Example

```ruby
docker_compose_application 'nginx' do
  action :up
  compose_files [ '/etc/docker-compose_nginx.yml', '/etc/docker-compose_nginx.additional.yml' ]
end
```

#### Parameters

- `project_name` - A string to identify the Docker Compose application.
 Defaults to the resource name.

- `compose_files` - The list of Compose files that makes up the Docker Compose
 application. The specified file names are passed to the `docker-compose`
 command in the order in which they appear in the list.
 
- `remove_orphans` - Remove containers for services not defined in the
 Compose file
 
#### Actions

- `:up` - Create and start containers.
  Equivalent to calling `docker-compose up` with the Compose files specified
  using the `compose_files` parameter.
 
- `:down` - Stop and remove containers, networks, images, and volumes.
  Equivalent to calling `docker-compose down` with the Compose files specified
  using the `compose_files` parameter.


## License & Authors

### Authors

- Sebastian Boschert (<sebastian@2007.org>)

### License

Copyright (c) 2016 Sebastian Boschert.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
