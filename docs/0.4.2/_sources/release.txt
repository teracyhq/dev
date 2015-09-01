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

docs/teracy_dev_development.rst
-------------------------------

- Change `develop` to the tag version. For example, `develop` to `v0.3.0`

scripts/setup_vagrant_and_virtualbox.bat
----------------------------------------

- Change `develop` to the tag version. For example, `develop` to `v0.3.0`


CHANGELOG.md
------------

- Copy release notes from dev project on issues.teracy.org, for example:

https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=10002

- Note: Only copy the main issues that is worth mentioning and change the format to Markdown instead.
