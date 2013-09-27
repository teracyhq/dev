chef
====

chef based common project that other chef-specific projects should extend.


Continuous Integration
----------------------


Usage
-----

** 1. Create a new cookbook **

```
$ rake new_cookbook
```

For example:

```
$ rake new_cookbook[test]
```
This will create a `test` cookbook into `main-cookbooks` path.

```
$ rake new_cookbook[test, main-cookbooks]
```
This will create a `test` cookbook into `main-cookbooks` path.

** 2. Build cookbooks **

```
$ rake build
```
This will check all cookbooks under `main-cookbooks` path with: `knife_test`, `foodcritic` and
`chefspec`

For more tasks, refer to `Rakefile`.


Installation
------------

- Ruby 1.9.3
- `$ git submodule update --init --recursive`
- `$ gem install bundle`
- `$ bundle install`


Configuration
-------------

- To work as a chef workstation, configure environment on `environment.sh` and then
`$ . ./environment.sh`, after that `$ rake check` to make sure all required environment variables
are set.


Contributing
------------

- File issues at https://issues.teracy.org/browse/CHEF

- Follow Teracy's workflow at http://dev.teracy.org/docs/develop/workflow.html


Discussions
-----------

Join us:

- https://groups.google.com/forum/#!forum/teracy

- https://www.facebook.com/groups/teracy

Get our news:

- https://www.facebook.com/teracy.official

- https://twitter.com/teracy_official


Author and contributors
-----------------------

See more details at `AUTHORS.md` and `CONTRIBUTORS.md` files.


License
-------

BSD License

```
Copyright (c) Teracy, Inc. and individual contributors.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
       to endorse or promote products derived from this software without
       specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
