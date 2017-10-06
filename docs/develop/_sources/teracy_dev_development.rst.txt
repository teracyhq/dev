teracy-dev Development
======================

We use ``teracy-dev`` to develop ``teracy-dev``, and use `teracy/dev:dev_develop` Docker image with all development runtime to execute Rake tasks.


Project Setup
-------------

Please follow the document at https://github.com/teracyhq/dev-setup/blob/develop/README.md to set up teracy-dev and dev-setup.

Please follow the document at https://github.com/teracyhq/dev/tree/develop/dev-setup/README.md#setting-up-teracy-dev-setup to set up ``dev`` project.

Get Docker image `teracy/dev:dev_develop` to execute rake tasks

..  code-block:: bash

    $ cd ~/teracy-dev
    $ vagrant ssh
    $ ws
    $ cd workspace/dev
    $ docker-compose pull


CI Setup
--------

Please follow the document at https://github.com/teracyhq/dev/tree/develop/dev-setup/README.md#travis-ci-configuration to set up CI system on travis-ci.org :


Rake Tasks
----------

- ``$ rake`` or ``$ rake list`` to list all `Rake` tasks.

..  code-block:: bash

    $ docker-compose run --rm dev rake list

You will see similiar like this:

..  code-block:: bash

    Creating network "dev_default" with the default driver
    Tasks: 
    - berks_install
    - berks_upload
    - build
    - check
    - chefspec
    - default
    - foodcritic
    - knife_test
    - list
    - new_cookbook


- ``$ rake build`` to check code style and run tests.

..  code-block:: bash

    $ docker-compose run --rm dev rake build

You will see something similar to this:

..  code-block:: bash

    bundle exec knife cookbook test -a -c test/knife.rb
    WARNING: DEPRECATED: Please use ChefSpec or Rubocop to syntax-check cookbooks.
    Running syntax check on teracy-dev
    Validating ruby files
    Validating templates
    bundle exec foodcritic -I test/foodcritic/* -f any main-cookbooks

    bundle exec rspec main-cookbooks
    No examples found.


    Finished in 0.00132 seconds (files took 0.04576 seconds to load)
    0 examples, 0 failures


- ``$ rake berks_install`` to install vendor cookbooks with Berkshelf_.

..  code-block:: bash

    $ docker-compose run --rm dev rake berks_install

You will see something similar to this:

..  code-block:: bash

    bundle exec berks vendor vendor-cookbooks
    Resolving cookbook dependencies...
    Fetching cookbook index from https://supermarket.chef.io...
    Installing compat_resource (12.19.0)
    Installing docker (2.15.6)
    Installing docker_compose (0.1.1)
    Installing magic_shell (1.0.0)
    Installing vim (2.0.2)
    Vendoring compat_resource (12.19.0) to vendor-cookbooks/compat_resource
    Vendoring docker (2.15.6) to vendor-cookbooks/docker
    Vendoring docker_compose (0.1.1) to vendor-cookbooks/docker_compose
    Vendoring magic_shell (1.0.0) to vendor-cookbooks/magic_shell
    Vendoring vim (2.0.2) to vendor-cookbooks/vim


Build teracy/dev Docker image
-----------------------------

When we update the development runtime (for example, change Gemfile or Dockerfile-dev), we need to
build the image with:

..  code-block:: bash

    $ docker-compose build


Base Boxes
----------

We're going to use Bento_ to build base boxes.

#.  `Virtualbox` Installation:

    You could install any versions of Virtualbox that matches the host machine.

    ..  code-block:: bash

        $ cd /tmp
        $ wget http://download.virtualbox.org/virtualbox/5.1.10/virtualbox-5.1_5.1.10-112026~Ubuntu~xenial_amd64.deb
        $ sudo dpkg -i virtualbox-5.1_5.1.10-112026~Ubuntu~xenial_amd64.deb
        $ sudo apt-get install -f -y

    Note: You may encounter some errors. Do not worry, you should install the missing dependencies. After installing, run `/sbin/vboxconfig` as root.

    After that, ``$ VBoxManage --version`` should print out something like:

    ..  code-block:: bash

        $ VBoxManage --version
        5.1.10r112026

#.  `Packer` Installation

    ..  code-block:: bash

        $ ws
        $ mkdir packer
        $ cd packer
        $ wget https://releases.hashicorp.com/packer/1.1.0/packer_1.1.0_linux_amd64.zip
        $ sudo apt-get install unzip -f -y
        $ unzip packer_1.1.0_linux_amd64.zip
        $ echo 'export PATH=~/workspace/packer:$PATH' | sudo tee --append ~/.bash_profile
        $ source ~/.bash_profile

    After that, ``$ packer version`` should print out something like:

    ..  code-block:: bash

        $ packer version
        Packer v1.1.0

#.  `Bento` Repository Clone

    ..  code-block:: bash

        $ ws
        $ git clone https://github.com/chef/bento.git
        $ cd bento

    Note: You may encounter some errors about `public key`. Do not worry, you should add the RSA key to your github and clone the project again.

#.  Base Boxes Build

    ..  tip::

        This is for developers only. Users should just use provided base boxes instead of
        building base boxes from scratch.

    ..  warning::
        Building from "headless" mode is not recommended, it should be used only for ci-system.

    We're going to build `ubuntu-16.04-amd64.json` base box as an example.

    We're working on a headless VM so you need to add ``headless`` option to the json file by
    openning any .json files and append ``"headless":true,`` before ``"boot_wait: "10s",`` line.

    and then:

    ..  code-block:: bash

        $ ws
        $ cd bento
        $ packer build -only=virtualbox-iso ubuntu-16.04-amd64.json

    After that `Packer` will download the Ubuntu iso files and install, package a vagrant base box for
    us to use.


    We should store and share iso files somewhere to save time from downloading iso files then
    put it under `~/workspace/bento/isos/`.

    For example, you put `ubuntu-16.04.3-server-amd64.iso` file under `~/workspace/bento/isos/ubuntu/16.04`
    and you can use the mirror like:

    ..  code-block:: bash

        $ packer build -var="mirror=/home/vagrant/workspace/bento/isos/ubuntu" -only=virtualbox-iso ubuntu-16.04-amd64.json

    It will take a while for the base box to be completed. The base boxe should be available under
    `~/workspace/bento/definitions` path.


References
----------

- http://bundler.io/
- https://www.chef.io/
- http://berkshelf.com/
- https://www.virtualbox.org/
- https://packer.io/
- http://chef.github.io/bento/
- https://github.com/boxcutter


..  _Berkshelf: http://berkshelf.com/
..  _Bento: http://chef.github.io/bento/
