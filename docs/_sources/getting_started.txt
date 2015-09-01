Getting Started
===============

To get started, you must follow the instruction steps below to set up the development environment.


Prerequisites
-------------

At Teracy, you need to install the tools below:

- ``virtualbox``
- ``vagrant``
- ``git``

**Windows Notes**:

- You MUST install ``git`` to use ``Git Bash``, from now on, it is called ``terminal window``.

- You MUST ALWAYS run ``virtualbox`` and ``Git Bash`` as **administrator** to make symlinks
  (of virtualenv) work as expected.

Automatic Installation
----------------------

To install required packages automatically, you need run **Ubuntu** 12.04 and newer. If not, you
need to move to the next alternative instruction by installing required packages manually.

Installing ``git``, ``virtualbox``, ``vagrant`` with the provided bash script below:
::

    $ cd /tmp && wget -qO- https://raw.github.com/teracy-official/dev/v0.4.2/scripts/setup_working_env_chef.sh | bash

On Windows (Windows 7 & Windows 8), follow these steps:

1. Open: https://raw.github.com/teracy-official/dev/v0.4.2/scripts/setup_vagrant_and_virtualbox.bat on Chrome or Firefox.

2. Press ``Ctrl + S``.

3. Select the option ``Save as type: Text document``, with the name "setup_vagrant_and_virtualbox.bat" (notice the double quote).

4. Open it by double-clicking on ``setup_vagrant_and_virtualbox.bat``.

Now you should have ``vagrant`` and ``virtualbox`` installed on your system.


Manual Installation
-------------------

1. Install the latest ``git`` version at http://git-scm.com/.

2. Install ``virtualbox`` with the exact version of **4.3.20** at
   https://www.virtualbox.org/wiki/Downloads.

3. Install ``vagrant`` with the exact version of **1.7.1** at
   https://www.vagrantup.com/download-archive/v1.7.1.html.

..  note::

    - The 64-bit architecture is used and run every day by us, however, the 32-bit archirecture is
      expected to work, too.

    - The virtualbox has an installation issue which is reported `here
      <https://www.virtualbox.org/ticket/4140>`_. If you `$ vagrant up` but can not start the
      virtual box, please find "VBoxUSBMon.inf" & "VBoxDrv.inf" in your installation directory and
      re-install it to fix the issue.

Adding SSH Key
---------------
Teracy supports SSH Agent Forwarding by default. It means you do not have to submit username & password
each time when working with Git like ``pull, push, rebase, etc`` on the Vagrant box. So, after
having installed Git, Vagrant, and Virtualbox, you need to add SSH key for Git and Virtualbox.

Do the following guides to get it work:

- Mac: https://help.github.com/articles/generating-ssh-keys#platform-mac

- Linux: https://help.github.com/articles/generating-ssh-keys#platform-linux

- Windows: https://help.github.com/articles/generating-ssh-keys

- Clone GitHub repositories using SSH.

.. note::

  You need to use the **ssh-agent** tool that provides a secure way of storing and using your SSH
  keys. Also, it allows you to use git commands on the virtual machine. See
  https://help.github.com/articles/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-msysgit
  to automatically run when opening the terminal window.

Environment Up
--------------

1. Open your terminal window and type:
    ::

      $ cd ~/
      $ git clone https://github.com/teracy-official/dev.git teracy-dev
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

          [2013-07-01T09:57:11+00:00] INFO: Chef Run complete in 160.951322714 seconds
          [2013-07-01T09:57:11+00:00] INFO: Running report handlers
          [2013-07-01T09:57:11+00:00] INFO: Report handlers complete

2. Use the ``$ vagrant ssh`` command to access the virtual machine you have just
installed which runs Ubuntu 12.04 with ssh. You should see the following similar messages:
::

    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.5.0-23-generic i686)

     * Documentation:  https://help.ubuntu.com/

    37 packages can be updated.
    18 updates are security updates.

    Last login: Wed Apr 24 07:43:49 2013 from 10.0.2.2

*Congratulations, you've all set now!*
