Description
===========

Installs apt repositories of [dotdeb](http://www.dotdeb.org/instructions/)

Requirements
============

Platform
--------

* Debian

Cookbooks
---------

* apt (leverages apt_repository LWRP)

The `apt_repository` LWRP is used from this cookbook to create the proper repository entries.

Attributes
==========

* `node['dotdeb']['php54']` - whether PHP 5.4 repository should be used

Usage
=====

Simply include the recipe where you want the repositories to be used.

License and Author
==================

Author:: Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)

Copyright:: 2013, Achim Rosenhagen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
