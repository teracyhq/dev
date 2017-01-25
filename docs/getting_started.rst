Getting Started
===============

``teracy-dev`` is created to set up a universal development platform which has the same development
workflow on Mac, Linux and Windows with good developer experience and productivity in mind. 


Please follow the installation instruction below, after that, the instruction step for teracy-dev
`git clone` and `vagrant up` is the same on all the platforms.


..  note::

    - The 64-bit architecture is used and run every day by us, however, the 32-bit architecture is
      expected to work, too.

    - We recommend the following tested and supported platforms:

      + macOS Sierra
      + Ubuntu 16.04
      + Windows 10, Windows 8, Windows 7

      Other platforms are expected to work, but we haven't fully tested them yet.

- If you're using a macOS machine,
  :ref:`click here to jump to macOS installation <manual-installation-on-macos>`.

- If you're using a Linux (Ubuntu) machine,
  :ref:`click here to jump to Linux (Ubuntu) installation <manual-installation-on-linux-ubuntu>`.

- If you're using a Windows machine,
  :ref:`click here to jump to Windows installation <manual-installation-on-windows>`.


Automatic Installation on macOS
-------------------------------

// TODO(hoatle): https://github.com/teracyhq/dev/issues/162

.. _manual-installation-on-macos:

Manual Installation on macOS
----------------------------

Check out the video and follow step by step instructions below:

.. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/htGqh_UyY_I" frameborder="0" allowfullscreen></iframe>

Open the terminal window:

1. Install ``Homebrew`` and ``Homebrew Cask``

   - http://brew.sh/
   - https://caskroom.github.io/

2. Install ``virtualbox`` and ``vagrant``

   - Install ``virtualbox`` (>=5.1):

     .. code-block:: bash

        $ brew cask install virtualbox

   - Install ``vagrant`` (>=1.8.7, >=1.9.1):

     .. code-block:: bash

        $ brew cask install vagrant

     ..  note::
        - // FIXME(hoavt): https://github.com/teracyhq/dev/issues/196
        - // TODO(hoatle): https://github.com/teracyhq/dev/issues/175

Next: :ref:`teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up>`

Automatic Installation on Linux (Ubuntu)
----------------------------------------

// TODO(hoatle): https://github.com/teracyhq/dev/issues/162


.. _manual-installation-on-linux-ubuntu:

Manual Installation on Linux (Ubuntu)
-------------------------------------

Check out the video and follow step by step instructions below:

.. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/MteK5c1r6B8" frameborder="0" allowfullscreen></iframe>

Open the terminal window:

1. Install ``git``

   ..  code-block:: bash

      $ sudo apt-get update
      $ sudo apt-get install -y git

2. Install ``virtualbox`` (>=5.1):

   Find the right installation version file at https://www.virtualbox.org/wiki/Linux_Downloads or
   https://www.virtualbox.org/wiki/Download_Old_Builds

   ..  code-block:: bash

      $ cd /tmp/
      $ wget <download_link>
      $ sudo dpkg -i <downloaded_file>
      $ sudo apt-get install -f -y

3. Install ``vagrant`` (>=1.8.7, >=1.9.1):

   Find the right installation version file at https://releases.hashicorp.com/vagrant/ or
   https://www.vagrantup.com/downloads.html

   ..  code-block:: bash

      $ cd /tmp/
      $ wget <download_link>
      $ sudo dpkg -i <downloaded_file>
      $ sudo apt-get install -f -y

Next: :ref:`teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up>`

Automatic Installation on Windows
---------------------------------

// TODO(hoatle): add this

.. _manual-installation-on-windows:

Manual Installation on Windows
------------------------------

This should be the same on Windows 10, Windows 8 and Windows 7.

Check out the video and follow step by step instructions below:

.. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/SBOoUIVI3Jw" frameborder="0" allowfullscreen></iframe>


1. Install ``chocolatey``

   Run ``Command Prompt`` **as administrator** and paste the Cmd.exe command below copied from
   https://chocolatey.org/install in the **More Options** section.

   .. code-block:: bash

      @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

2. Install ``cyg-get``
   
   Type the command below on the opened ``Command Prompt``:

   ..  code-block:: bash

       > choco install cyg-get -y

  ..  note::

    - If you cannot install the cyg-get due to the checksums file, install this command instead:

      ..  code-block:: bash

          > choco install cyg-get -y --ignore-checksums

    - Or reinstall it:

      ..  code-block:: bash

          > choco install cyg-get -y --ignore-checksums --force

3. Install ``bash-completion``, ``git``, ``virtualbox`` and ``vagrant``

  Run ``Cygwin Terminal`` **as administrator** with the following commands:

  - Install ``bash-completion``:

     .. code-block:: bash

        $ cyg-get.bat bash-completion

     ..  note::

        - If you encounter the following error, fix it and run the command again:

         ..  code-block:: bash

            C:\ProgramData\chocolatey\lib\cyg-get\tools\cyg-get.ps1 : Please ensure you have Cygwin installed.
            To install please call 'choco install cygwin' (optionally add -y to autoconfirm).
            ERROR: This command cannot be run due to the error: The system cannot find the file specified.
            At line:1 char:1

         Fix it by going to http://cygwin.com/install.html and save the *setup-x86_64.exe* file with the new name *cygwinsetup.exe* into the *cygwin* folder (Details with https://github.com/chocolatey/chocolatey-coreteampackages/issues/176#issuecomment-212939458.)

         You are recommended to see the instruction video above for more details.


  - Install ``git``:

     .. code-block:: bash

        $ cyg-get.bat git

  - Install ``virtualbox`` (>=5.1):

     .. code-block:: bash

        $ choco install virtualbox -y

  - Install ``vagrant`` (>=1.8.7, >=1.9.1):

     .. code-block:: bash

        $ choco install vagrant -y

  - After finishing the vagrant installation, you are suggested to restart your machine. 


  Next: :ref:`teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up>`


.. _teracy-dev-git-clone-and-vagrant-up:

teracy-dev Git Clone and Vagrant Up
-----------------------------------

1. Open your ``Cygwin Terminal`` window **as administrator** and type:

    ..  code-block:: bash

      $ cd ~/
      $ git clone https://github.com/teracyhq/dev.git teracy-dev
      $ cd teracy-dev
      $ git checkout develop
      $ vagrant up

    ..  note::

          We check out the `develop` branch here to use the latest development version of teracy-dev.
          When it is released, we will use the `master` branch - the latest stable version instead.

    You could see the error message saying that `vagrant-gatling-rsync` and `vagrant-rsync-back`
    plugins are required, so install them:

    ..  code-block:: bash

        $ vagrant plugin install vagrant-gatling-rsync
        $ vagrant plugin install vagrant-rsync-back


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
      ==> default: Rsyncing folder: /Users/hoatle/teracy-dev/workspace/ => /home/vagrant/workspace
      ==> default:   - Exclude: [".vagrant/", ".git", ".idea/", "node_modules/", "bower_components/", ".npm/"]


    ..  note::

      - You may see the error:
          ::

            vagrant uses the VBoxManage binary that ships with VirtualBox and requires this to be
            available on the PATH. If VirtualBox is installed, please find the VBoxManage binary and
            add it to the PATH environmental variable.

          To fix this error, add the path of the **VirtualBox** folder to your environment variable.

          For example: In Windows, add this ``C:\Program Files\Oracle\VirtualBox``.

          If the error still occurs, you have to uninstall and re-install ``virtualbox``, then
          ``vagrant`` to fix this error.

      - If you ``$ vagrant up`` but cannot start the VirtualBox, please find "VBoxUSBMon.inf" and
        "VBoxDrv.inf" in your installation directory then re-install it to fix the issue. The VirtualBox
        has an installation issue which was reported `here <https://www.virtualbox.org/ticket/4140>`_


2. Open another ``Cygwin Terminal`` window **as administrator**, and use the ``$ vagrant ssh`` command to access the virtual machine you have just  provisioned.

    ..  code-block:: bash

      $ cd teracy-dev
      $ vagrant ssh

  You should see the following similar messages:

   .. code-block:: bash

      Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-51-generic x86_64)

        * Documentation:  https://help.ubuntu.com
        * Management:     https://landscape.canonical.com
        * Support:        https://ubuntu.com/advantage

      1 package can be updated.
      1 update is a security update.


      Last login: Tue Dec  6 14:19:56 2016 from 10.0.2.2

3. Check if docker and docker-composed are already installed

After vagrant ssh, use the following commands:

  .. code-block:: bash

      $ docker --version
      $ docker-compose --version

  .. note::
    In case the docker command is not found, you should ``$ vagrant destroy``, then ``vagrant up`` again or ``vagrant reload --provision``

Git Setup
---------

To work with ``git``, complete the following guides to set up ssh keys:
https://help.github.com/categories/ssh/

*Congratulations, you’ve all set now!*
