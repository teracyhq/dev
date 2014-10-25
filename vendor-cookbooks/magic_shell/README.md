magic_shell Cookbook
====================
[![Build Status](https://secure.travis-ci.org/customink-webops/magic_shell.png)](http://travis-ci.org/customink-webops/magic_shell)

Provides utility for adding some syntactic sugar to your shell.

Usage
-----
Update the `metadata.rb` for your cookbook to depend on magic_shell

```ruby
depends 'magic_shell'
```

Use the `magic_shell_alias` resource to create a command alias.

```ruby
magic_shell_alias 'myrailsapp' do
  command 'cd /opt/myrailsapp/current'
end
```

This will alias `myrailsapp` to `cd /opt/myrailsapp/current`.

You can also remove aliases:

```ruby
magic_shell_alias 'myrailsapp' do
  action :remove
end
```

Use the `magic_shell_environment` resource to create a shell environment variable.

```ruby
magic_shell_environment 'EDITOR' do
  value 'vim'
end
```

This will export an `EDITOR` environment variable with a value of `vim`.

You can also remove environment variables:

```ruby
magic_shell_environment 'EDITOR' do
  action :remove
end
```

Contributing
------------
1. Fork the repo
2. Create a feature branch
3. Code, document, write specs, test
4. Submit a PR


License & Authors
-----------------
- Author: Nathen Harvey <nharvey@customink.com>
- Author: Seth Vargo <sethvargo@gmail.com>

```text
Copyright 2012-2014 CustomInk, LLC.

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
