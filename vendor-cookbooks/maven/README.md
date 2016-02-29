# maven Cookbook
[![Build Status](https://travis-ci.org/chef-cookbooks/maven.svg?branch=master)](http://travis-ci.org/chef-cookbooks/maven) [![Cookbook Version](https://img.shields.io/cookbook/v/maven.svg)](https://supermarket.chef.io/cookbooks/maven)

Install and configure Apache Maven from the binaries provided by the Maven project.

Provides the `maven` LWRP for pulling a maven artifact from a mave repository and placing it in an arbitrary location.

Note:  This cookbook does not handle the installation of Java, but Maven requires a working JDK 8 release. You'll need to use the Java cookbook to install OpenJDK or Oracle's JRE depending on your platform.

## Requirements
### Platforms
- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- Fedora
- Windows

### Chef
- Chef 11+

### Cookbooks
- java - java_ark LWRP used by the Maven LWRP
- ark - used to unpack the maven tarball

## Attributes
- `node['maven']['version']` - specifies the version of maven to install.
- `node['maven']['m2_home']` - defaults to  '/usr/local/maven/'
- `node['maven']['url']` - the download url for maven
- `node['maven']['checksum']` - the checksum, which you will have to recalculate if you change the download url using shasum -a 256 <file>
- `node['maven']['repositories']` - an array of maven repositories to use; must be specified as an array. Used in the maven LWRP.
- `node['maven']['setup_bin']` - Whether or not to put mvn on your system path, defaults to false
- `node['maven']['mavenrc']['opts']` - Value of `MAVEN_OPTS` environment variable exported via `/etc/mavenrc` template, defaults to `-Dmaven.repo.local=$HOME/.m2/repository -Xmx384m`

## Recipes
### default
Installs maven according to the version specified by the `node['maven']['version']` attribute.

### settings
Installs gems required to parse settings.xml to ruby and hash and back to xml

## Usage
Install a working Java 8 JRE (Oracle or OpenJDK) either using the Java cookbook or your own cookbooks

Include the recipe where you want Apache Maven installed.

The maven lwrp has two actions, `:install` and `:put`. They are essentially the same accept that the install action will name the the downloaded file `artifact_id-version.packaging`. For example, the mysql jar would be named mysql-5.1.19.jar.

Use the put action when you want to explicitly control the name of the downloaded file. This is useful when you download an artifact and then want to have Chef resources act on files within that the artifact. The put action will creat a file named `name.packaging` where name corresponds to the name attribute.

## Providers/Resources
## maven\_settings
Resource provider for modifying the maven settings.

### Actions

Action | Description                                    | Default
------ | ---------------------------------------------- | -------
update | Updates a global maven setting to a new value. | Yes

### Attributes

Attribute | Description                                                                       | Type                                | Default
--------- | --------------------------------------------------------------------------------- | ----------------------------------- | -------
path      | Period '.' delimited path to element of the settings that is going to be changed. | String                              | name
value     | The new value to update the path to.                                              | String, TrueClass, FalseClass, Hash |

In order to use this resource you first need to run `settings` recipe which will installed required bury gems for you. Find below exampl on how to update proxy in settings.xml

```ruby
maven_settings "settings.proxies" do
  value "proxy" => {
    "active" => true,
    "protocaol" => "http",
    "host" => "proxy.myorg.com",
    "port" => 80,
    "nonProxyHosts" => ".myorg.com"
  }
end
```

### maven
- `artifact_id` - if this is not specified, the resource's name is used
- `group_id` - group_id for the artifact
- `version` - version of the artifact
- `dest` - the destination folder for the jar and its dependencies
- `packaging` - defaults to 'jar'
- `classifier` - distinguishes artifacts that were built from the same POM but differ in context
- `repositories` - array of maven repositories to use, defaults to ["[http://repo1.maven.apache.org/maven2](http://repo1.maven.apache.org/maven2)"]
- `owner` - the owner of the resulting file, default is root
- `group` - the group of the resulting file, default is root's group
- `mode` - integer value for file permissions, default is 0644
- `transitive` - whether to resolve dependencies transitively, defaults to false. Please note: Event true will only place one artifact in dest. All others are downloaded to the local repository.

#### Examples

```ruby
maven 'mysql-connector-java' do
  group_id 'mysql'
  version  '5.1.19'
  dest     '/usr/local/tomcat/lib/'
end
# The artifact will be downloaded to /usr/local/tomcat/lib/mysql-connector-java-5.1.19.jar

maven 'solr' do
  group_id  'org.apache.solr'
  version   '3.6.1'
  packaging 'war'
  dest      '/usr/local/tomcat/webapps/'
  action    :put
end
# The artifact will be downloaded to /usr/local/tomcat/webapps/solr.war

maven 'custom-application' do
  group_id   'com.company.name'
  version    '2.0.0'
  dest       '/usr/local/tomcat/lib'
  classifier 'client'
  action     :put
end
# The artifact will be downloaded to /usr/local/tomcat/lib/custom-application-2.0.0-client.jar
```

## License & Authors
**Author:** Seth Chisamore ([schisamo@chef.io](mailto:schisamo@chef.io))

**Author:** Bryan W. Berry ([bryan.berry@gmail.com](mailto:bryan.berry@gmail.com))

**Author:** Leif Madsen ([lmadsen@thinkingphones.com](mailto:lmadsen@thinkingphones.com))

**Copyright:** 2008-2015, Chef Software, Inc.

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
