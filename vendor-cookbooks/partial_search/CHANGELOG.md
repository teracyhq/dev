partial_search Cookbook CHANGELOG
=================================
This file is used to list changes made in each version of the partial_search cookbook.

v1.0.9 (2015-10-21)
-------------------
-------------------
* Updated description to clarify that this cookbook is no longer needed for chef-client 12.0
* Updated .gitignore file
* Added .foodcritic file to exclude rules that don't apply
* Added Test Kitchen config
* Added Chef standard Rubocop config
* Added Travis CI testing to use Chef DK
* Added Berksfile
* Added Gemfile with the latest development dependencies
* Updated contributing and testing docs
* Added maintainers.md and maintainers.toml files
* Added Travis and cookbook version badges to the readme
* Updated Opscode -> Chef Software
* Added a Rakefile for simplified testing
* Added a Chefignore file
* Resolved Rubocop warnings
* Added source_url and issues_url to the metadata
* Added basic convergence Chefspec test

v1.0.8 (2014-02-25)
-------------------
- [COOK-4260] Update compatibility in README.md

v1.0.6
------
- **Hotfix** - Revert client-side caching bug

v1.0.4
------
### New Feature
- **[COOK-2584](https://tickets.chef.io/browse/COOK-2584)** - Add client-side result cache

v1.0.2
------
### Bug
- [COOK-3164]: `partial_search` should use
  `Chef::Config[:chef_server_url]` instead of `search_url`

v1.0.0
------
- Initial release
