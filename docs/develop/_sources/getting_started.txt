Getting Started
===============

To get started, you must follow the instruction steps below to set up the development environment.


Prerequisites
-------------

At Teracy, you need to install the tools below:

- ``virtualbox``
- ``vagrant``
- ``git``
- ``rsync``


on Mac
------
//TODO(hoatle)

on Linux
--------
//TODO(hoatle)

on Windows
----------
//TODO(hoatle)

- You MUST install ``cygwin`` to use ``git``, ``rsync``, from now on, it is called ``terminal window``.


Automatic Installation
----------------------

To install required packages automatically, you need run **Ubuntu** 12.04 and newer. If not, you
need to move to the next alternative instruction by installing required packages manually.

Installing ``git``, ``virtualbox``, ``vagrant`` with the provided bash script below:

::

  $ cd /tmp && wget -qO- https://raw.github.com/teracyhq/dev/develop/scripts/setup_working_env_chef.sh | bash

On Windows (Windows 7, Windows 8 & Windows 10), follow these steps:

1. Open: https://raw.github.com/teracyhq/dev/develop/scripts/setup_vagrant_and_virtualbox.bat on Chrome or Firefox.

2. Press ``Ctrl + S``.

3. Select the option ``Save as type: Text document``, with the name "setup_vagrant_and_virtualbox.bat" (notice the double quote).

4. Open it by double-clicking on ``setup_vagrant_and_virtualbox.bat``.

Now you should have ``vagrant`` and ``virtualbox`` installed on your system.


Manual Installation
-------------------

1. Install the latest ``cygwin`` version at https://www.cygwin.com/ and choose to install the
   following packages:

   - bash
   - bash-completion
   - git
   - openssh
   - rsync

2. Install ``virtualbox`` with the exact version of **5.1.8** (or newer) at
   https://www.virtualbox.org/wiki/Downloads.

3. Install ``vagrant`` with the exact version of **1.8.7** (or newer) at
   https://releases.hashicorp.com/vagrant/1.8.7/.

..  note::

    - The 64-bit architecture is used and run every day by us, however, the 32-bit archirecture is
      expected to work, too.

    - The virtualbox has an installation issue which is reported `here
      <https://www.virtualbox.org/ticket/4140>`_. If you `$ vagrant up` but can not start the
      virtual box, please find "VBoxUSBMon.inf" & "VBoxDrv.inf" in your installation directory and
      re-install it to fix the issue.

Git Setup
---------

Complete the following guides to get it work:

- https://help.github.com/categories/ssh/


Environment Up
--------------

1. Open your terminal window and type:
    ::

      $ cd ~/
      $ git clone https://github.com/teracyhq/dev.git teracy-dev
      $ cd teracy-dev
      $ vagrant up

..  note::

    - The home directory on ``Git Bash`` normally should point to your user's directory on windows.
      For example: ``C:\Documents and Settings\<user_name>``, this is the place you will find
      ``teracy-dev`` directory to import projects into your text editor later for coding.

    - You may see the error:

      ..  code-block:: bash

        Vagrant uses the `VBoxManage` binary that ships with VirtualBox, and requires this to be
        available on the PATH. If VirtualBox is installed, please find the `VBoxManage` binary and
        add it to the PATH environmental variable.

      To fix this error, add the path of the **VirtualBox** folder to your environment variable.

      For example: In Windows, add this ``C:\Program Files\Oracle\VirtualBox``.

      If the error still occurs, you have to unistall and re-install VirtualBox, then Vagrant to fix
      this error.

      You should see the following similar messages after ``$ vagrant up`` finishes running:
      ::

      ==> default: [2016-11-25T06:02:16+00:00] INFO: Report handlers complete
      ==> default: Chef Client finished, 9/15 resources updated in 03 minutes 36 seconds
      ==> default: Running provisioner: shell...
      ==> default: Running: inline script
      ==> default: stdin: is not a tty
      ==> default: ip address: 192.168.0.105
      ==> default: vagrant-gatling-rsync is starting the sync engine because you have at least one rsync folder. To disable this behavior, set `config.gatling.rsync_on_startup = false` in your Vagrantfile.
      ==> default: Doing an initial rsync...
      ==> default: Rsyncing folder: /Users/hoatle/teracy-dev-docker/workspace/teracy-dev/workspace/ => /home/vagrant/workspace
      ==> default:   - Exclude: [".vagrant/", ".git", ".idea/", "node_modules/", "bower_components/", ".npm/"]

2. Use the ``$ vagrant ssh`` command to access the virtual machine you have just
installed which runs Ubuntu 12.04 with ssh. You should see the following similar messages:
::

  Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 3.13.0-101-generic x86_64)

  * Documentation:  https://help.ubuntu.com/

  System information as of Fri Nov 25 06:02:18 UTC 2016

  System load:  0.79              Users logged in:        0
  Usage of /:   5.6% of 39.34GB   IP address for eth0:    10.0.2.15
  Memory usage: 10%               IP address for eth1:    192.168.0.105
  Swap usage:   0%                IP address for docker0: 172.17.0.1
  Processes:    89

  Graph this data and manage this system at:
    https://landscape.canonical.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud
