Getting Started
===============

``teracy-dev`` is created to set up a universal development platform which has the same development
workflow on Mac, Linux and Windows with good developer experience and productivity in mind.


Please follow the installation instruction below, after that, the instruction step for teracy-dev
`git clone` and `vagrant up` is the same on all the platforms.


..  note::

    - By default, we're using a Ubuntu 64-bit guest OS, so you need to enable VT-x/AMD-v in the host PC BIOS.
      Remember to reboot your host PC after making BIOS changes. Please refer to https://forums.virtualbox.org/viewtopic.php?f=1&t=62339 for more details.

    - We recommend the following tested and supported platforms:

      + macOS Sierra and above
      + Ubuntu 16.04 and above
      + Windows 10, Windows 8, Windows 7 SP1 x64. We don't support Windows 32 bit.
        Note: Power shell version >= 3.0

      Other platforms are expected to work, but we haven't fully tested them yet.

- If you're using a macOS machine, `click here to jump to macOS installation <manual-installation-on-macos_>`_.

- If you're using a Linux (Ubuntu) machine, `click here to jump to Linux (Ubuntu) installation <manual-installation-on-linux-ubuntu_>`_.

- If you're using a Windows machine, `click here to jump to Windows manual installation <manual-installation-on-windows-to-use-git-bash_>`_.

Automatic Installation on macOS
-------------------------------

// TODO(hoatle): https://github.com/teracyhq/dev/issues/162

.. _manual-installation-on-macos:

Manual Installation on macOS
----------------------------

Open the terminal window:

1. Install ``Homebrew``

   - http://brew.sh/


2. Install ``virtualbox`` and ``vagrant``

   - Install ``virtualbox`` (>= v5.2.22):

     .. code-block:: bash

        $ brew cask install virtualbox

   - Install ``vagrant`` (>= v2.2.0):

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


Next: `teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up_>`_

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

2. Install ``virtualbox`` (>= v5.2.22):

   ..  code-block:: bash

      $ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add - \
      && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add - \
      && sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
      && sudo apt-get update && sudo apt-get install virtualbox-5.2 -y # or virtualbox-6.0

3. Install ``vagrant`` (>= v2.2.0):

   ..  code-block:: bash

      $ version=2.2.3 && cd /tmp \
      && wget $(if [ `uname -m` == "x86_64" ]; then echo "https://releases.hashicorp.com/vagrant/$version/vagrant_${version}_x86_64.deb"; else echo "https://releases.hashicorp.com/vagrant/$version/vagrant_${version}_i686.deb"; fi;) \
      && sudo dpkg -i vagrant_${version}* && rm vagrant_${version}* && cd --


Please check out the instruction video below for more details:

  .. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/MteK5c1r6B8" frameborder="0" allowfullscreen></iframe>

  ..  note::

      The video is not really up to date with current teracy-dev v0.6.0, however, you will see the similar workflow and result.

Next: `teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up_>`_

Automatic Installation on Windows
---------------------------------

// TODO(hoatle): add this

.. _manual-installation-on-windows-to-use-git-bash:

Manual Installation on Windows to Use Git Bash
----------------------------------------------

1. Install `chocolatey <https://chocolatey.org/install#installing-chocolatey>`_:

   Run ``Command Prompt`` **as administrator** and then copy this to your terminal window:

   ..  code-block:: bash

       @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

   After the installation is finished, restart the machine.

2. Install `git <https://git-scm.com/>`_:

   ..  code-block:: bash

       $ choco install git.install --version 2.20.1

3. Install `virtualbox <https://www.virtualbox.org/>`_ (>= 5.2.22):

   ..  code-block:: bash

       $ choco install virtualbox --version 5.2.22

4. Install `vagrant <https://www.vagrantup.com/>`_ (>= 2.2.0):

   ..  code-block:: bash

       $ choco install vagrant --version 2.2.3

5. Install rsync for ```Git Bash```:

  - Download `rsync-3.1 <http://www2.futureware.at/~nickoe/msys2-mirror/msys/x86_64/rsync-3.1.2-2-x86_64.pkg.tar.xz>`_ at http://www2.futureware.at/~nickoe/msys2-mirror/msys/x86_64/

  - Extract and copy ``rsync.exe`` to ``C:\Program Files\Git\usr\bin``, then re-open your terminal window.

Now everything is done, head over to `teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up_>`_ to continue the setup.

.. _manual-installation-on-windows-to-use-cygwin:

Manual Installation on Windows to Use Cygwin
--------------------------------------------

This should be the same on Windows 10, Windows 8 and Windows 7.

Follow step by step instructions below:

  ..  note::

      - You need to look after the console output, if there is no console output after some time,
        press "Enter" key to make sure the process should continue.

      - You must "restart the machine" when instructed to make sure we install packages properly.

1. Install ``chocolatey``

   Run ``Command Prompt`` **as administrator** and paste the Cmd.exe command copied from the
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

   - Install ``git``, ``curl``, ``tar`` and ``wget``:

     .. code-block:: bash

        $ cyg-get.bat git curl wget tar

   - Install ``virtualbox`` (>= v5.2.22):

     .. code-block:: bash

        $ choco install virtualbox --version 5.2.22 -y

   - Install ``vagrant`` (>= v2.2.0):

     .. code-block:: bash

        $ choco install vagrant --version 2.2.3 -y

   - Install Winpty for cygwin:

     .. code-block:: bash

        $ curl -L https://github.com/rprichard/winpty/releases/download/0.4.3/winpty-0.4.3-cygwin-2.8.0-x64.tar.gz | tar xzv --strip-components=1 -C /;
        $ echo "alias vagrant=\"winpty vagrant\"" >> ~/.bashrc;

   - Also please make sure ``echo $VAGRANT_PREFER_SYSTEM_BIN`` returns ``true``, if not then add it by ``echo "export VAGRANT_PREFER_SYSTEM_BIN=true" >> ~/.bashrc"``

   - Restart the machine after the installation is finished.



Please check out the instruction video below for more details:

   .. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/SBOoUIVI3Jw" frameborder="0" allowfullscreen></iframe>

  ..  note::

      The video is not really up to date with current teracy-dev v0.6.0, however, you will see the similar workflow and result.


Next: `teracy-dev Git Clone and Vagrant Up <teracy-dev-git-clone-and-vagrant-up_>`_

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

       - On Windows, if you see the error `code converter not found (UTF-16LE to Windows-1258) (Encoding::ConverterNotFoundError)` when using vagrant:

         ::

           $ vagrant status
           C:/HashiCorp/Vagrant/embedded/mingw64/lib/ruby/2.4.0/win32/registry.rb:185:in `encode!': code converter not found (UTF-16LE to Windows-1258) (Encoding::ConverterNotFoundError)

         You should set the `system locale` into `US`, by following the steps below:

           - Open `Control Panel` --> `Region` --> `Location` --> select `United States` for `Home Location`.
           - Navigate to the `Administrative` tab --> Change system locale… > Click `Appy` in the popup --> click `OK` to confirm selecting `English (United States)` --> Apply, and restart the machine.

2. Use the ``$ vagrant ssh`` command to access the virtual machine you have just `vagrant up`.

   ..  code-block:: bash

       $ cd ~/teracy-dev
       $ vagrant ssh

   You should see the following similar messages:

   .. code-block:: bash

      Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.4.0-116-generic x86_64)

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

      - If you have SSH configured and ``vagrant`` is still not working on Windows, you should add the
        ``export VAGRANT_PREFER_SYSTEM_BIN=true`` environment variable to the ``.bash_profile`` file, that helps you
        not add this variable on Cygwin repeatedly.

      ..  code-block:: bash

          $ cat >> ~/.bash_profile

      Type ``export VAGRANT_PREFER_SYSTEM_BIN=true`` and press ``Ctrl + D``, then run:

       ..  code-block:: bash

          $ source ~/.bash_profile

      Now, open the terminal and run the ``export`` command to check if the variable is added successfully

*Congratulations, you’ve all set now!*
