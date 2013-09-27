magic_shell Cookbook
====================
[![Build Status](https://secure.travis-ci.org/customink-webops/magic_shell.png)](http://travis-ci.org/customink-webops/magic_shell)

Provides utility for adding some syntactic sugar to your shell.

Requirements
------------
None

Attributes
----------
None

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

License and Authors
-------------------
Author: [Nathen Harvey](https://github.com/nathenharvey) ([@nathenharvey](https://twitter.com/nathenharvey))

Copyright 2012, CustomInk, LLC
