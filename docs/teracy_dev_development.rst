teracy-dev Development
======================

We use ``teracy-dev`` to develop ``teracy-dev`` itself.

``teracy-dev`` requires about `2048MB` of VM memory, so you need to override 1024 with
2048 here: https://github.com/teracyhq/dev/blob/v0.4.2/vagrant_config.json#L92 on
the `vagrant_config_override.json` file.


Project Setup
-------------

Fork and clone ``teracy-dev`` from https://github.com/teracyhq/dev/

For example, this is my forked repo: https://github.com/hoatle/teracy-dev/

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd personal
    $ git clone git@github.com:hoatle/teracy-dev.git teracy-dev
    $ cd teracy-dev
    $ git submodule update --init --recursive

Notice that you use ``teracy-dev`` directory for the project name.


Install gems with `bundle`:

..  note::

    This step took a white so please prepare with you a cup of coffee and be patient :).

..  code-block:: bash

    $ bundle install


Rake Tasks
----------

- ``$ rake`` or ``$ rake list`` to list all `Rake` tasks.

- ``$ rake build`` to check code style and run tests.

- ``$ rake berks_install`` to install vendor cookbooks with Berkshelf_.


Base Boxes
----------

We're going to use Bento_ to build base boxes.

#.  `Virtualbox` Installation:

    You could install any versions of Virtualbox. As for teracy-dev v0.4.2, we use virtualbox v4.3.20.

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
        $ cd readonly
        $ mkdir packer
        $ cd packer
        $ wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip
        $ sudo apt-get install unzip -f -y
        $ unzip packer_0.7.5_linux_amd64.zip
        $ echo 'export PATH=~/workspace/readonly/packer:$PATH' | sudo tee --append ~/.bash_profile
        $ source ~/.bash_profile

    After that, ``$ packer version`` should print out something like:

    ..  code-block:: bash

        $ packer version
        Packer v0.7.5

#.  `Bento` Repository Clone

    ..  code-block:: bash

        $ ws
        $ cd readonly
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
        $ cd readonly/bento/packer
        $ packer build -only=virtualbox-iso ubuntu-12.04-amd64.json

    After that `Packer` will download the Ubuntu iso files and install, package a vagrant base box for
    us to use.


    We should store and share iso files somewhere to save time from downloading iso files then
    put it under `~/workspace/readonly/bento/isos/`.

    For example, you put `ubuntu-12.04.5-server-amd64.iso` file under `~/workspace/readonly/bento/isos/ubuntu/12.04`
    and you can use the mirror like:

    ..  code-block:: bash

        $ packer build -var="mirror=/home/vagrant/workspace/readonly/bento/isos/ubuntu" -only=virtualbox-iso ubuntu-12.04-amd64.json

    It will take a while for the base box to be completed. The base boxe should be available under
    `~/workspace/readonly/bento/definitions` path.


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

