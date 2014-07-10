# pyenv Chef Cookbook

Manages installation of multiple Python versions via
[pyenv](https://github.com/yyuu/pyenv). Also provides a set of lightweight
resources and providers.

If you've used [rbenv][rbenv] before, this is a port of that concept for
Python.

## pyenv Installed System-Wide with Pythons

Most likely, this is the typical case. Include `recipe[pyenv::system]` in your
run\_list and override the defaults you want changed. See [below](#attributes)
for more details.

## pyenv Installed For A Specific User with Pythons

If you want a per-user install (like on a Mac/Linux workstation for
development, CI, etc.), include `recipe[pyenv::user]` in your run\_list and
add a user hash to the `user_installs` attribute list. For example:

```ruby
node.default['pyenv']['user_installs'] = [
  {
    'user'     => 'archie',
    'pythons'  => ['2.7.6', '3.3.2'],
    'global'   => '2.7.6',
  }
]
```

See [below](#attributes) for more details.

## pyenv Installed System-Wide and LWRPs Defined

If you want to manage your own pyenv environment with the provided
LWRPs, then include `recipe[pyenv::system_install]` in your run\_list
to prevent a default pyenv Ruby being installed. See the
[Resources and Providers](#lwrps) section for more details.

## pyenv Installed For A Specific User and LWRPs Defined

If you want to manage your own pyenv environment for users with the provided
LWRPs, then include `recipe[pyenv::user_install]` in your run\_list and add a
user hash to the `user_installs` attribute list. For example:

```ruby
node.default['pyenv']['user_installs'] = [
  { 'user' => 'archie' }
]
```

See the [Resources and Providers](#lwrps) section for more details.

### Ultra-Minimal Access To LWRPs

Simply include `recipe[pyenv]` in your run\_list and the LWRPs will be
available to use in other cookbooks. See the [Resources and Providers](#lwrps)
section for more details.

## Requirements

### Chef

Tested on 11.8.2 but newer and older version should work just
fine. File an [issue][issues] if this isn't the case.

### Platform

The following platforms have been tested with this cookbook, meaning that
the recipes and LWRPs run on these platforms without error:

* ubuntu (10.04/12.04)
* debian (6.0)
* freebsd
* redhat
* centos
* fedora
* amazon
* scientific
* suse
* mac\_os\_x

Please [report][issues] any additional platforms so they can be added.

### Cookbooks

There are **no** external cookbook dependencies.

## Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

### Using Berkshelf

[Berkshelf][berkshelf] is a cookbook dependency manager and development
workflow assistant. To install Berkshelf:

```bash
cd chef-repo
gem install berkshelf
berks init
```

### Using Librarian-Chef

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks.
To install Librarian-Chef:

```bash
cd chef-repo
gem install librarian
librarian-chef init
```

## Recipes

### default

Initializes Chef to use the Lightweight Resources and Providers
([LWRPs][lwrp]).

Use this recipe explicitly if you only want access to the LWRPs provided.

### system_install

Installs the `pyenv` codebase system-wide (that is, into `/usr/local/pyenv`). This
recipe includes *default*.

Use this recipe by itself if you want `pyenv` installed system-wide but want
to handle installing Pythons, invoking LWRPs, etc..

### system

Installs the `pyenv` codebase system-wide (that is, into `/usr/local/pyenv`) and
installs Pythons driven off attribute metadata. This recipe includes *default*
and *system_install*.

Use this recipe by itself if you want `pyenv` installed system-wide with
Pythons installed.

### user_install

Installs the `pyenv` codebase for a list of users (selected from the
`node['pyenv']['user_installs']` hash). This recipe includes *default*.

Use this recipe by itself if you want `pyenv` installed for specific users in
isolation but want each user to handle installing Pythons, invoking LWRPs, etc.

### user

Installs the pyenv codebase for a list of users (selected from the
`node['pyenv']['user_installs']` hash) and installs Pythons driven off
attribute metadata. This recipe includes *default* and *user_install*.

Use this recipe by itself if you want `pyenv` installed for specific users in
isolation with Pythons installed.

## Attributes

### git_url

The Git URL which is used to install pyenv.

The default is `"git://github.com/yyuu/pyenv.git"`.

### git_ref

A specific Git branch/tag/reference to use when installing `pyenv`. For
example, to pin `pyenv` to a specific release:

    node.default['pyenv']['git_ref'] = "v0.4.0-20130613"

The default is `"v0.4.0-20140110.1"`.

### upgrade

Determines how to handle installing updates to the `pyenv`. There are currently
2 valid values:

* `"none"`, `false`, or `nil`: will not update `pyenv` and leave it in its
  current state.
* `"sync"` or `true`: updates `pyenv` to the version specified by the
  `git_ref` attribute or the head of the master branch by default.

The default is `"none"`.

### root_path

The path prefix to `pyenv` in a system-wide installation.

The default is `/usr/local/pyenv`.

### pythons

A list of additional system-wide Python versions to be built and installed.
For example:

```ruby
node.default['pyenv']['pythons'] = [ "2.7.7", "3.3.2" ]
```

The default is an empty array: `[]`.

### user_pythons

A list of additional system-wide Python versions to be built and installed
per-user when not explicitly set. For example:

```ruby
node.default['pyenv']['user_pythons'] = [ "2.7.5" ]
```

The default is an empty array: `[]`.

### create_profiled

The user's shell needs to know about pyenv's location and set up the
`PATH` environment variable. This is handled in the
[system_install](#recipes-system_install) and
[user_install](#recipes-user_install) recipes by dropping off
`/etc/profile.d/pyenv.sh`. However, this requires root privilege,
which means that a user cannot use a "user install" for only their
user.

Set this attribute to `false` to skip creation of the
`/etc/profile.d/pyenv.sh` template. For example:

```ruby
node.default['pyenv']['create_profiled'] = false
```

The default is `true`.

## Resources and Providers

### pyenv_global

This resource sets the global version of Python to be used in all shells.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Sets the global version of Python to be used in all shells.
      </td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>pyenv_version</td>
      <td>
        <b>Name attribute:</b> a version of Python being managed by pyenv.
        <b>Note:</b> the version of Python must already be installed--this LWRP
        will not install it automatically.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated pyenv installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide pyenv
        installation is being targeted. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to pyenv installation, for example:
        <code>/opt/pyenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Set A Python As Global

```ruby
pyenv_global "2.7.6"
```

##### Set System Python As Global

```ruby
pyenv_global 'system'
```

##### Set A Python As Global For A User

```ruby
pyenv_global '3.3.2' do
  user 'archie'
end
```

### pyenv_script

This resource is a wrapper for the `script` resource which wraps the code block
in an `pyenv`-aware environment. See the Opscode
[script resource][script_resource] documentation for more details.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>run</td>
      <td>Run the script</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>nothing</td>
      <td>Do not run this command</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

Use `action :nothing` to set a command to only run if another resource
notifies it.

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>name</td>
      <td>
        <b>Name attribute:</b> Name of the command to execute.
      </td>
      <td>name</td>
    </tr>
    <tr>
      <td>pyenv_version</td>
      <td>
        A version of Python being managed by pyenv.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to pyenv installation, for example:
        <code>/opt/pyenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>code</td>
      <td>
        Quoted script of code to execute.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>creates</td>
      <td>
        A file this command creates - if the file exists, the command will not
        be run.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>cwd</td>
      <td>
        Current working directory to run the command from.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>
        A has of environment variables to set before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>group</td>
      <td>
        A group or group ID that we should change to before running this
        command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>path</td>
      <td>
        An array of paths to use when searching for the command.
      </td>
      <td><code>nil</code>, uses system path</td>
    </tr>
    <tr>
      <td>returns</td>
      <td>
        The return value of the command (may be an array of accepted values) -
        this resource raises an exception if the return value(s) do not match.
      </td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td>timeout</td>
      <td>
        How many seconds to let the command run before timing out.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated pyenv installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide pyenv
        installation is being targeted. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>umask</td>
      <td>
        Umask for files created by the command.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Run A Rake Task

```ruby
pyenv_script 'migrate_rails_database' do
  pyenv_version '2.7.6'
  user          'deploy'
  group         'deploy'
  cwd           '/srv/webapp/current'
  code          %{python manage.py syncdb}
end
```

### pyenv_rehash

This resource installs shims for all Python binaries known to `pyenv`.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>run</td>
      <td>Run the script</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>nothing</td>
      <td>Do not run this command</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

Use `action :nothing` to set a command to only run if another resource
notifies it.

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>name</td>
      <td>
        <b>Name attribute:</b> Name of the command to execute.
      </td>
      <td>name</td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated pyenv installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide pyenv
        installation is being targeted. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to pyenv installation, for example:
        <code>/opt/pyenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Rehash A System-Wide pyenv

```ruby
pyenv_rehash 'Doing the rehash dance'
```

##### Rehash A User's pyenv

```ruby
pyenv_rehash "Rehashing archie's pyenv" do
  user 'archie'
end
```

### pyenv_python

This resource installs a specified version of Python.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>install</td>
      <td>
        Build and install a Python version.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>reinstall</td>
      <td>
        Force a recompiliation of the Python version from source. The
        `:install` action will skip a build if the target install directory
        already exists.
      </td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>version</td>
      <td>
        <b>Name attribute:</b> the name of a Python version (e.g. `2.7.6`)
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated pyenv installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide pyenv
        installation is being targeted. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to pyenv installation, for example:
        <code>/opt/pyenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Install Python 2.7.6

```ruby
pyenv_python '2.7.6' do
  action :install
end
```

```ruby
pyenv_python '2.7.6'
```

**Note:** the install action is default, so the second example is a more common
usage.

##### Reinstall Python

```ruby
pyenv_python '2.7.6' do
  action :reinstall
end
```

## System-Wide Mac Installation Note

This cookbook takes advantage of managing profile fragments in an
`/etc/profile.d` directory, common on most Unix-flavored platforms.
Unfortunately, Mac OS X does not support this idiom out of the box,
so you may need to [modify][mac_profile_d] your user profile.

## License and Author

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[berkshelf]:        http://berkshelf.com/
[chef_repo]:        https://github.com/opscode/chef-repo
[librarian]:        https://github.com/applicationsonline/librarian#readme
[lwrp]:             http://docs.opscode.com/lwrp_custom.html
[mac_profile_d]:    http://hints.macworld.com/article.php?story=20011221192012445
[script_resource]:  http://docs.opscode.com/resource_script.html
[rbenv]:            https://github.com/sstephenson/rbenv
