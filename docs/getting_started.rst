Getting Started
===============

``teracy-dev`` is created to set up a universal development platform which has the same development
workflow on Mac, Linux and Windows with good developer experience and productivity in mind.


Please follow the installation instruction below, after that, the instruction step for teracy-dev
`git clone` and `vagrant up` is the same on all the platforms.


..  note::

    - The 64-bit architecture is used and run every day by us, however, the 32-bit architecture is
      expected to work, too.

    - By default, we're using a Ubuntu 64-bit guest OS, so you need to enable VT-x/AMD-v in the host PC BIOS.
      Remember to reboot your host PC after making BIOS changes. Please refer to https://forums.virtualbox.org/viewtopic.php?f=1&t=62339 for more details.

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

Open the terminal window:

1. Install ``Homebrew`` and ``Homebrew Cask``

   - http://brew.sh/
   - https://caskroom.github.io/

2. Install ``virtualbox`` and ``vagrant``

   - Install ``virtualbox``:

     .. code-block:: bash

        $ brew cask install virtualbox

   - Install ``vagrant``:

     .. code-block:: bash

        $ brew cask install vagrant

     ..  note::

         - If you encounter the following similar error:

           ..  code-block:: bash

              ==> default: Box 'bento/ubuntu-16.04' could not be found. Attempting to find and install...
                  default: Box Provider: virtualbox
                  default: Box Version: >= 0
              The box 'bento/ubuntu-16.04' could not be found or
              could not be accessed in the remote catalog. If this is a private
              box on HashiCorp's Atlas, please verify you're logged in via
              `vagrant login`. Also, please double-check the name. The expanded
              URL and error message are shown below:

              URL: ["https://atlas.hashicorp.com/bento/ubuntu-16.04"]

           then fix it with ``$ sudo rm -rf /opt/vagrant/embedded/bin/curl`` (Details at
           https://github.com/mitchellh/vagrant/issues/7969#issuecomment-258878970)

         - // TODO(hoatle): https://github.com/teracyhq/dev/issues/175


Next: :ref:`teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up>`

Automatic Installation on Linux (Ubuntu)
----------------------------------------

// TODO(hoatle): https://github.com/teracyhq/dev/issues/162


.. _manual-installation-on-linux-ubuntu:

Manual Installation on Linux (Ubuntu)
-------------------------------------


Open the terminal window:

1. Install ``git``

   ..  code-block:: bash

      $ sudo apt-get update
      $ sudo apt-get install -y git

2. Install ``virtualbox``:

   ..  code-block:: bash

      $ sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" \
      && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc -O- | sudo apt-key add - \
      && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add - \
      && sudo apt-get update && sudo apt-get install virtualbox-5.2 -y

3. Install ``vagrant``:

   ..  code-block:: bash

      $ version=2.1.2 && cd /tmp \
      && wget $(if [ `uname -m` == "x86_64" ]; then echo "https://releases.hashicorp.com/vagrant/$version/vagrant_${version}_x86_64.deb"; else echo "https://releases.hashicorp.com/vagrant/$version/vagrant_${version}_i686.deb"; fi;) \
      && sudo dpkg -i vagrant_${version}* && rm vagrant_${version}* && cd --


Please check out the instruction video below for more details:

  .. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/MteK5c1r6B8" frameborder="0" allowfullscreen></iframe>

  ..  note::

      The video is not really up to date with current teracy-dev v0.5.0, however, you will see the similar workflow and result.

Next: :ref:`teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up>`

Automatic Installation on Windows
---------------------------------

// TODO(hoatle): add this

.. _manual-installation-on-windows:

Manual Installation on Windows
------------------------------

This should be the same on Windows 10, Windows 8 and Windows 7.

Follow step by step instructions below:

  ..  note::

      - You need to look after the console output, if there is no console output after some time,
        press "Enter" key to make sure the process should continue.

      - You must "restart the machine" when instructed to make sure we install packages properly.

1. Install ``chocolatey``

   Run ``Command Prompt`` **as administrator** and paste the Cmd.exe command copied from
   https://chocolatey.org/install#install-with-cmdexe section.

   It should look similar to the following command:

   ..  code-block:: bash

       > @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

   After the installation is finished, restart the machine.

2. Install ``dotnet4.5``

   ..  note::

       This is required for the ``vagrant`` installation later, see more:
       https://github.com/teracyhq/dev/issues/348#issuecomment-315068962

   Run ``Command Prompt`` **as administrator** and type the following command:

   ..  code-block:: bash

       > choco install dotnet4.5 --version 4.5.20120822 -y

   After the installation is finished, restart the machine.

3. Install ``cygwin`` and ``cyg-get``

   Type the command below on the opened ``Command Prompt``:

   ..  code-block:: bash

       > choco install cygwin --version 2.8.0 -y --ignore-checksums
       > choco install cyg-get --version 1.2.1 -y

   ..  note::

       - If you cannot install the ``cyg-get`` due to the checksums error, reinstall it with the
         following command instead:

         ..  code-block:: bash

             > choco install cyg-get --version 1.2.1 -y --ignore-checksums --force


4. Install ``bash-completion``, ``git``, ``virtualbox`` and ``vagrant``

   Run ``Cygwin Terminal`` **as administrator** with the following commands:

   - Install ``bash-completion``:

     .. code-block:: bash

        $ cyg-get.bat bash-completion

     ..  note::

         - From now on, let's call ``Cygwin Terminal`` ``terminal window`` on Windows.

         - If you encounter the following error:

           ..  code-block:: bash

              C:\ProgramData\chocolatey\lib\cyg-get\tools\cyg-get.ps1 : Please ensure you have Cygwin installed.
              To install please call 'choco install cygwin' (optionally add -y to autoconfirm).
              ERROR: This command cannot be run due to the error: The system cannot find the file specified.
              At line:1 char:1

           then fix it by going to http://cygwin.com/install.html and save the *setup-x86_64.exe*
           file with the new name *cygwinsetup.exe* into the *cygwin* folder (Details at
           https://github.com/chocolatey/chocolatey-coreteampackages/issues/176#issuecomment-212939458.)

   - Install ``git``:

     .. code-block:: bash

        $ cyg-get.bat git

   - Install ``virtualbox``:

     .. code-block:: bash

        $ choco install virtualbox --version 5.2.14 -y

   - Install ``vagrant``:

     .. code-block:: bash

        $ choco install vagrant --version 2.1.2 -y

   After finishing the ``vagrant`` installation, restart the machine.

Please check out the instruction video below for more details:

   .. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/SBOoUIVI3Jw" frameborder="0" allowfullscreen></iframe>

  ..  note::

      The video is not really up to date with current teracy-dev v0.5.0, however, you will see the similar workflow and result.

Next: :ref:`teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up>`

.. _teracy-dev-git-clone-and-vagrant-up:

teracy-dev Git Clone and Vagrant Up
-----------------------------------

1. Open your terminal window and type:

   ..  code-block:: bash

       $ cd ~/
       $ git clone https://github.com/teracyhq/dev.git teracy-dev
       $ cd teracy-dev
       $ git checkout develop
       $ vagrant up

   ..  note::

       - Check out the `develop` branch to use the latest development version of teracy-dev.
       - Check out the `master` branch to use the latest stable version of teracy-dev.
       - Checkout the tagged released version for usage.


   You should see the following similar messages after ``$ vagrant up`` finishes running:
   ::

      ==> node-01: Waiting for machine to boot. This may take a few minutes...
          node-01: SSH address: 127.0.0.1:2201
          node-01: SSH username: vagrant
          node-01: SSH auth method: private key
          node-01: Warning: Remote connection disconnect. Retrying...
          node-01: Warning: Connection reset. Retrying...
          node-01: 
          node-01: Vagrant insecure key detected. Vagrant will automatically replace
          node-01: this with a newly generated keypair for better security.
          node-01: 
          node-01: Inserting generated public key within guest...
          node-01: Removing insecure key from the guest if it's present...
          node-01: Key inserted! Disconnecting and reconnecting using new SSH key...
      ==> node-01: Machine booted and ready!
      ==> node-01: Checking for guest additions in VM...
      ==> node-01: Setting hostname...
      ==> node-01: Mounting shared folders...
          node-01: /vagrant => /Users/hoatle/teracy-dev/workspace/dev

   ..  note::

       - You may see the error on Windows:
         ::

           vagrant uses the VBoxManage binary that ships with VirtualBox and requires this to be
           available on the PATH. If VirtualBox is installed, please find the VBoxManage binary and
           add it to the PATH environmental variable.

         To fix this error, add the path of the **VirtualBox** folder to your environment variable.

         For example: In Windows, add this ``C:\Program Files\Oracle\VirtualBox``.

         If the error still occurs, you have to uninstall and re-install ``virtualbox``, then
         ``vagrant`` to fix this error.

       - On Windows, if you ``$ vagrant up`` but cannot start the VirtualBox, please find "VBoxUSBMon.inf" and
         "VBoxDrv.inf" in your installation directory then re-install it to fix the issue. The VirtualBox
         has an installation issue which was reported `here <https://www.virtualbox.org/ticket/4140>`_

2. Use the ``$ vagrant ssh`` command to access the virtual machine you have just `vagrant up`.

   ..  code-block:: bash

       $ cd ~/teracy-dev
       $ vagrant ssh

   You should see the following similar messages:

   .. code-block:: bash

      Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-116-generic x86_64)

       * Documentation:  https://help.ubuntu.com
       * Management:     https://landscape.canonical.com
       * Support:        https://ubuntu.com/advantage

      0 packages can be updated.
      0 updates are security updates.


Git Setup
---------

To work with ``git``, complete the following guides to set up ssh keys:
https://help.github.com/articles/connecting-to-github-with-ssh/

   .. note::

      On Windows, you must always use ``Cygwin Terminal``, not ``Git Bash``.

*Congratulations, you’ve all set now!*
