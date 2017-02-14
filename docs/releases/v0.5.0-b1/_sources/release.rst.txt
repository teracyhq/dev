Release Steps
=============

vagrant_config.json
-------------------

- set "vm_box_version" limit on the new release when neccessary


README.rst
----------

- change `develop` to the tag version. For example, `develop/` to `0.3.0/`

docs/conf.py
------------

- Update docs version on `docs/conf.py`

docs/getting_started.rst
------------------------

- Change `develop` to the tag version. For example, `develop` to `v0.3.0`


scripts/setup_vagrant_and_virtualbox.bat
----------------------------------------

- Change `develop` to the tag version. For example, `develop` to `v0.3.0`


CHANGELOG.md
------------

- create release notes from https://github.com/teracyhq/dev/milestones
