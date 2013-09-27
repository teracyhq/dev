teracy-dev - get development fun!
=================================

This ``teracy-dev`` repository was created for developing software at Teracy with ease and fun.
We're going to use ``virtualbox`` for running as a VM box, ``chef`` and ``vagrant`` for
installing and configuring any necessary packages.

By using this approach, we can work in a consistent development environment. We don't have to
install tons of development stuff on the host machine **manually** to get started.

Before getting started, please see the "Frequently asked question" to know some of the common
problems you could meet with proposed solutions.

Usage
-----

- ``$ vagrant up`` to boot the VM

- ``$ vagrant ssh`` to access the VM via SSH

More commands: http://docs.vagrantup.com/v2/cli/index.html


Installation
------------

Follow the guide at: http://dev.teracy.org/docs/develop/getting_started.html


Configuration
-------------

All configuration is on ``Vagrantfile`` file.


``workspace`` directory
-----------------------

The ``workspace`` directory was created under ``teracy-dev``. This ``workspace`` directory is the
location where you will store all your work, after ``$ vagrant up``, the following sub directories
will be created if they do not exist yet.

``workspace/personal``: the location to store all your stuffs which you have full control of it
(your own projects).

``workspace/readonly``: the location to store all the stuffs that you could read only (open source
projects).

``workspace/teracy``: the location to store all the official stuffs of teracy's at
https://github.com/teracy-official

The ``teracy-dev/workspace`` directory from host machine was mapped to ``~/workspace`` directory
on the virtual machine. So you could access this ``workspace`` directory from the virtual machine
(``$ cd ~/workspace`` or alias ``$ ws``).

From now on, we will ``$ vagrant ssh`` and run command lines on the virtual machine if not
explicitly mentioning about running command lines on the host machine.


Training
--------

We offered free training for recruiting newcomers.

- For Django development, please head to: http://dev.teracy.org/docs/develop/django_training.html


Learn more
----------

- Teracy's projects

    + https://github.com/teracy-official

- Vagrant

    + http://www.vagrantup.com/

- Sublime Text

    + http://www.sublimetext.com/

- Django

    + https://docs.djangoproject.com/en/1.5/

    + http://www.djangobook.com/en/2.0/index.html

    + http://www.deploydjango.com/

    + ``pip``: http://www.pip-installer.org/en/latest/

    + ``virtualenv``: http://www.virtualenv.org/en/latest/

    + ``virtualenvwrapper``: http://virtualenvwrapper.readthedocs.org/en/latest/

- Python

    + http://python.org/doc/

    + http://www.diveintopython.net/

    + http://learnpythonthehardway.org/book/

- Git

    + http://git-scm.com/book

- Vim

    + http://www.openvim.com/tutorial.html

    + https://www.shortcutfoo.com/app/tutorial/vim

- Linux

    + http://www.quora.com/Linux/What-are-the-good-online-resources-for-a-linux-newbie

    + http://www.quora.com/Linux/What-are-some-time-saving-tips-that-every-Linux-user-should-know

    + http://kernelnewbies.org/


Frequently asked questions
--------------------------

**1. My internet speed is slow, ``$ vagrant up`` took a lot of time and reset to 0% after reaching
more than 50%?**

For slow internet connection (~200KB/s or lower), you could use a download accelerator to
download .box file (400-500MB) first with the link:
https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04-i386_chef-11.4.4.box

And before ``$ vagrant up``, you must execute the command below:
::
    $ vagrant box add opscode-ubuntu-1204 path_to_the_downloaded_file.box

If you're on Windows and downloaded the ``.box`` file to your ``Desktop``, then:
::
    $ vagrant box add opscode-ubuntu-1204 ~/Desktop/opscode_ubuntu-12.04-i386_chef-11.4.4.box

The output could be something similar like this:
::
    Downloading or copying the box...
    Extracting box...te: 66.3M/s, Estimated time remaining: 0:00:01)
    Successfully added box 'opscode-ubuntu-1204' with provider 'virtualbox'!

**2. What OS should I use for best development environment?**

You could use any OS to start development (Windows XP, Windows 7, Windows 8, Mac,
Ubuntu, etc.)

However, Windows is NOT recommended for best development experience. It's better to work on any
*nix compatible OS (Mac OSX, Ubuntu, Fedora, Redhat, etc,.)

Ubuntu 12.04 is a **strongly** recommended OS for development, get it now at:
http://www.ubuntu.com/download/desktop

**3. After ``$ vagrant up``, there is an error saying that ``virtualbox`` has error, can't run and
quit immediately?**

Make sure you install the exact version **4.2.10** of ``virtualbox``.

**4. How could I update ``teracy-dev``?**

We're trying to make the update as painless as possible so that we don't have to ``detroy`` and
``up`` again as it is time consuming. We try to make the update with ``provision``, acceptable
``reload``. If we have to ``destroy`` and ``up`` again, it will be the next major release version.

- Have ``git`` installed:

Follow these commands below:
::
    $ git stash
    $ git fetch origin
    $ git merge origin/master
    $ git stash apply

When ``$ git stash apply``, you could get conflicts on ``Vagrantfile``, please resolve it.

- No ``git`` installed:

    + You need to move all your work under ``home`` and ``workspace`` directory to outside of
    ``teracy-dev``

    + Delete ``teracy-dev``

    + Download the repository at https://github.com/teracy-official/teracy-dev/archive/master.zip and
    unzip with named ``teracy-dev`` at ``~/`` (*unix) or ``C:\Documents and Settings\<user_name>``
    (Windows).

    + Move all your work under ``home`` and ``workspace`` back to ``teracy-dev`` and start working
    as normal.

**5. How to use ssh keys on the virtual machine**?

``teracy-dev/home/.ssh`` on the host machine and ``~/.ssh`` on the virtual machine are in sync. You
could copy your existing ssh keys into one location and it will be available in the other location.

5.1. It's easier to use the host machine to forward ssh access. Just enable it on ``Vagrantfile``
::
    config.ssh.forward_agent = true

It seems that Windows is having problem with ``forward_agent``, Windows users should move to 5.2.

5.2. Or to use existing ssh keys, type the following commands on the host machine
terminal window:
::
    $ cd teracy-dev
    $ cp ~/.ssh/id_rsa* home/.ssh

5.3. Or to create new ssh keys on the virtual machine, just create it and these keys will be copied
into ``teracy-dev/home/.ssh``.
