Change Log
==========


[0.3.5][] (2014-12-28)
----------------------

bug fixes and improvements

- Bug
    + [DEV-116] - problems related to virtualbox guest addition
    + [DEV-154] - 'open_loop': redirection forbidden caused by berkshelf


- Improvement
    + [DEV-156] - Add options to specify base box version



[0.3.4][] (2014-09-18)
----------------------

bug fixes

- Bug
    + [DEV-116] - problems related to virtualbox guest addition
    + [DEV-121] - No "source" of install_method for mongodb recipe


[0.3.3][] (2014-09-05)
----------------------

provide teracy/dev basebox v0.3.3 with 64 bit

provide teracy/dev-all basebox v0.3.3 with 64 bit and all options enabled


- New Feature
    + [DEV-100] - Provision Ubuntu 12.04 64bit instead of 32 bit


- Task
    + [DEV-108] - Create dev-all base box



[0.3.2][] (2014-07-28)
----------------------

bug fix on windows: .virtualenvs permission denied

- Bug
    + [DEV-109] - permission denied of .virtualenvs on windows


[0.3.1][] (2014-07-22)
----------------------

bug fixes to reduce provision time and make sure nosetest works well.

- Bug
    + [DEV-101] - nosetests does not work well on vagrantbox

- Improvement
    + [DEV-99] - Reduce the provision time of base box v0.3.0 on v0.3.0


[0.3.0][] (2014-07-16)
----------------------

The next milestone release includes:

- Use teracy base box
- Support overriding vagrant configuration that is ignored by git
- Update workspace layout: `workspace/personal` and `workspace/readonly`
- Bat script to install virtualbox and vagrant automatically for Windows
- More dev platform support: Ruby, Node.js, Java, PHP
- Database support: mysql, mongodb, postgreSQL
- docs updated

Details:

- Bug
    + [DEV-6]  - vm.ssh.forward_agent does not work on windows host
    + [DEV-63] - failed to vagrant up at child directory of teracy-dev
    + [DEV-75] - Fix Doc Syntax Error
    + [DEV-81] - update code.teracy.org instead of teracy.com to ssh known hosts
    + [DEV-93] - virtualenvwrapper not work

- Improvement
    + [DEV-7]  - Don't mess custom configuration into managed versioned file
    + [DEV-45] - automatic docs deploy of 0.2.0 instead of v0.2.0
    + [DEV-57] - Update workspace layout
    + [DEV-60] - Vagrant Config override instead of overwrite
    + [DEV-62] - Update some vagrant config attributes
    + [DEV-64] - warning when vagrant_config_override.json is malformed
    + [DEV-65] - Support deep key override
    + [DEV-77] - Make sure consistent recipe file names (use _ instead of -)
    + [DEV-80] - Make sure git usage from vagrant box and host work well together
    + [DEV-82] - Add support for ruby.globals
    + [DEV-84] - Support ruby.version config
    + [DEV-88] - Support apt package installer configuration

- New Feature
    + [DEV-49] - node.js dev support
    + [DEV-56] - Create .bat file to install vagrant and virtualbox automatically on Windows
    + [DEV-61] - Support PHP
    + [DEV-85] - Support mongodb
    + [DEV-86] - Support mysql db development
    + [DEV-87] - Support postgreSQL development

- Task
    + [DEV-47] - review and update docs
    + [DEV-51] - Improve and Create visual guide for workflow
    + [DEV-54] - Upgrade support for vagrant and virtualbox
    + [DEV-55] - Create Teracy base boxes for v0.3.0
    + [DEV-59] - install "bower" by default for node.js support
    + [DEV-66] - upgrade git
    + [DEV-69] - Upgrade npm for teracy-dev
    + [DEV-71] - Update docs to make sure it's the most up to date
    + [DEV-72] - remove known_hosts file
    + [DEV-73] - remove system-python recipe


[0.2.0][] (2013-11-20)
----------------------

The next milestone release: extend CHEF, better support for python platform development

- Migration from v0.1.0 to v0.2.0
    + Vagrantfile: https://github.com/teracy-official/dev/commit/f8906c9d5d24951028a41f524e68463ea0bf32f8

- Sub-task
    + [DEV-25] - Define Python Coding Standards

- Bug
    + [DEV-5] - Bug when determining ubuntu

- New Feature
    + [DEV-31] - extend CHEF
    + [DEV-39] - Make sure gettext is available on demand
    + [DEV-42] - optional add pip index-url of teracy's public pypi

- Task
    + [DEV-1] - Project migration
    + [DEV-14] - define software semantic versioning
    + [DEV-16] - update the latest development of sphinx-deployment
    + [DEV-17] - update docs, resources after github issues migration
    + [DEV-18] - update workflow
    + [DEV-19] - update project-template
    + [DEV-20] - release process documentation
    + [DEV-22] - upgrade setuptools to 1.0
    + [DEV-26] - add interesting resources section
    + [DEV-28] - upgrade vagrant
    + [DEV-30] - use nature theme for docs instead of default one
    + [DEV-35] - upgrade to sphinx-deployment v0.2.0


[0.1.0][] (2013-08-17)
----------------------

Release the first milestone

- Sub-task
    + [DEV-2] - release current deprecated teracy-dev to be 0.1.0

[0.1.0]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=10000

[0.2.0]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=10002

[0.3.0]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=10702

[0.3.1]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=11201

[0.3.2]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=11203

[0.3.3]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=11300

[0.3.4]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=11400

[0.3.5]: https://issues.teracy.org/secure/ReleaseNote.jspa?projectId=10400&version=11900
