teracy-dev Development
======================

We use Docker (or better ``teracy-dev``) to develop ``teracy-dev``.
We use `teracy/dev:dev_develop` Docker image with all development runtime to execute Rake tasks.


Project Setup
-------------

Fork and clone ``teracy-dev`` from https://github.com/teracyhq/dev/

For example, this is my forked repo: https://github.com/hoatle/teracy-dev/

..  code-block:: bash

    $ mkdir -p ~/teracy-dev/workspace
    $ cd ~/teracy-dev/workspace
    $ git clone git@github.com:hoatle/teracy-dev.git teracy-dev
    $ cd teracy-dev
    $ git submodule update --init --recursive
    $ docker-compose pull

Notice that you use ``teracy-dev`` directory for the project name.


CI Setup
--------

After forking the project, you should set up the CI system on travis-ci.org:

- register an account at travis-ci.org
- register an account at hub.docker.com
- enable `teracy-dev` repository on travis-ci.org
- add travis-ci settings with these variables:
    + ``DOCKER_USERNAME``: Fill with your Docker username account
    + ``DOCKER_PASSWORD``: Fill with your Docker password account
    + ``DEV_DOCKER_IMAGE``: Fill with `<your_docker_username>/teracy-dev`
    + ``DOCS_DOCKER_IMAGE``: Fill with `<your_docker_username>/teracy-dev-docs`
    + ``GH_REPO``: Fill with `<your_github_username>/teracy-dev>` to git push on your repo
    + ``GH_TOKEN``: Fill with `<your_github_personal_access_token>` to git push on your repo


Rake Tasks
----------

- ``$ rake`` or ``$ rake list`` to list all `Rake` tasks.

..  code-block:: bash

    $ docker-compose run --rm dev rake list
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
    bundle exec knife cookbook test -a -c test/knife.rb
    WARNING: DEPRECATED: Please use ChefSpec or Rubocop to syntax-check cookbooks.
    Running syntax check on teracy-dev
    Validating ruby files
    Validating templates
    bundle exec foodcritic -I test/foodcritic/* -f any main-cookbooks

    bundle exec rspec main-cookbooks
    No examples found.


    Finished in 0.00089 seconds (files took 0.10198 seconds to load)
    0 examples, 0 failures

- ``$ rake berks_install`` to install vendor cookbooks with Berkshelf_.

..  code-block:: bash

    $ docker-compose run --rm dev rake berks_install
    bundle exec berks vendor vendor-cookbooks
    Resolving cookbook dependencies...
    Fetching cookbook index from https://supermarket.chef.io...
    Installing compat_resource (12.16.2)
    Installing docker (2.11.0)
    Installing docker_compose (0.1.1)
    Installing magic_shell (1.0.0)
    Installing vim (2.0.2)
    Vendoring compat_resource (12.16.2) to vendor-cookbooks/compat_resource
    Vendoring docker (2.11.0) to vendor-cookbooks/docker
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

    You could install any versions of Virtualbox that matched the host machine.

    ..  code-block:: bash

        $ cd /tmp
        $ wget http://download.virtualbox.org/virtualbox/4.3.20/virtualbox-4.3_4.3.20-96996~Ubuntu~precise_amd64.deb
        $ sudo dpkg -i virtualbox-4.3_4.3.20-96996~Ubuntu~precise_amd64.deb
        $ sudo apt-get install -f -y

    After that, ``$ VBoxManage --version`` should print out something like:

    ..  code-block:: bash

        $ VBoxManage --version
        4.3.20r96996

#.  `Packer` Installation

    ..  code-block:: bash

        $ ws
        $ mkdir packer
        $ cd packer
        $ wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip
        $ sudo apt-get install unzip -f -y
        $ unzip packer_0.7.5_linux_amd64.zip
        $ echo 'export PATH=~/workspace/packer:$PATH' | sudo tee --append ~/.bash_profile
        $ source ~/.bash_profile

    After that, ``$ packer version`` should print out something like:

    ..  code-block:: bash

        $ packer version
        Packer v0.7.5

#.  `Bento` Repository Clone

    ..  code-block:: bash

        $ ws
        $ git clone git@github.com:chef/bento.git
        $ cd bento

#.  Base Boxes Build

    ..  tip::

        This is for developers only. Users should just use provided base boxes instead of
        building base boxes from scratch.

    ..  warning::
        Building from "headless" mode is not recommended, it should be used only for ci-system.

    We're going to build `ubuntu-12.04-amd64.json` base box as an example.

    We're working on a headless VM so you need to add ``headless`` option to the json file by
    openning any .json files and append ``"headless":true,`` before ``"boot_wait: "10s",`` line.

    and then:

    ..  code-block:: bash

        $ ws
        $ cd bento/packer
        $ packer build -only=virtualbox-iso ubuntu-12.04-amd64.json

    After that `Packer` will download the Ubuntu iso files and install, package a vagrant base box for
    us to use.


    We should store and share iso files somewhere to save time from downloading iso files then
    put it under `~/workspace/bento/isos/`.

    For example, you put `ubuntu-12.04.5-server-amd64.iso` file under `~/workspace/bento/isos/ubuntu/12.04`
    and you can use the mirror like:

    ..  code-block:: bash

        $ packer build -var="mirror=/home/vagrant/workspace/bento/isos/ubuntu" -only=virtualbox-iso ubuntu-12.04-amd64.json

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
