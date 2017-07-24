Release Steps
=============

vagrant_config.json
-------------------

- set "vm_box_version" limit on the new release when neccessary


README.rst
----------

- change `develop` to the tag version. For example, `develop/` to `v0.5.0`

docs/conf.py
------------

- Update docs version on `docs/conf.py`

docs/getting_started.rst
------------------------

- Change `develop` to the tag version. For example, `develop` to `v0.5.0`
- Keep the tag version for both the git tag and the master branch


CHANGELOG.md
------------

- create release notes from https://github.com/teracyhq/dev/milestones
