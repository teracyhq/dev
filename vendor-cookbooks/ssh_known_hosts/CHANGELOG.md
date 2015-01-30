v2.0.0 (2014-12-02)
-------------------
- [#36] Fix the way keys are rendered
- [#22] Update to README
- [#32] Clean up logging
- [#23] Do not hash public keys
- [#34] Serverspec updates
- [#28] Add data bag caching option
- [#20] Add checspec matchers
- [#33] Add test to verify chefspec matcher

v1.3.2 (2014-04-23)
-------------------
- [COOK-4579] - Do not use ssh-keyscan stderr


v1.3.0 (2014-04-09)
-------------------
- [COOK-4489] Updated ssh-keyscan to include -t type


v1.2.0 (2014-02-18)
-------------------
### Bug
- **[COOK-3453](https://tickets.opscode.com/browse/COOK-3453)** - ssh_known_hosts cookbook ruby block executes on every chef run


v1.1.0
------
[COOK-3765] - support ssh-keyscan using an alternative port number


v1.0.2
------
### Bug
- **[COOK-3113](https://tickets.opscode.com/browse/COOK-3113)** - Use empty string when result is `nil`

v1.0.0
------
This is a major release because it requires a server that supports the partial search feature.

- Opscode Hosted Chef
- Opscode Private Chef
- Open Source Chef 11

### Improvement

- [COOK-830]: uses an inordinate amount of RAM when running exception handlers

v0.7.4
------
- [COOK-2440] - `ssh_known_hosts` fails to use data bag entries, doesn't grab items

v0.7.2
------
- [COOK-2364] - Wrong LWRP name used in recipe

v0.7.0
------
- [COOK-2320] - Merge `known_host` LWRP into `ssh_known_hosts`

v0.6.0
------
- [COOK-2268] - Allow to run with chef-solo

v0.5.0
------
- [COOK-1077] - allow adding arbitrary host keys from a data bag

v0.4.0
------
- COOK-493: include fqdn
- COOK-721: corrected permissions
