Getting Started
===============

To get started, you must follow the instruction steps below to set up the development environment.


Prerequisites
-------------

**1. Required**

- ``virtualbox``
- ``vagrant``
- ``git``

**Notice**

Teracy supports SSH Agent Forwarding by default. It means you do not have to submit username & password
each time when working with Git like ``pull, push, rebase, etc`` on the Vagrant box.

Do the following guide to get it work:

- Mac/ Linux: https://help.github.com/articles/working-with-ssh-key-passphrases#platform-mac

- Windows: https://help.github.com/articles/working-with-ssh-key-passphrases#platform-windows

- Clone GitHub repositories using SSH.

**Windows Notes**:

- You MUST install ``git`` to use ``Git Bash``, from now on, it is called ``terminal window``.

- You MUST ALWAYS run ``virtualbox`` and ``Git Bash`` as **administrator** to make symlinks
  (of virtualenv) work as expected.


Automatic Installation
----------------------

To install required packages automatically, you need run **Ubuntu** 12.04. If not, you need to move
to the next alternative instruction by installing required packages manually.

Installing ``git``, ``virtualbox``, ``vagrant`` with the provided bash script below:
::

    $ cd /tmp
    $ wget https://raw.github.com/teracy-official/dev/v0.3.5/scripts/setup_working_env_chef.sh
    $ bash setup_working_env_chef.sh

On Windows (Windows 7 & Windows 8), follow these steps:

1. Open: https://raw.github.com/teracy-official/dev/v0.3.5/scripts/setup_vagrant_and_virtualbox.bat on Chrome or Firefox.

2. Press ``Ctrl + S``.

3. Select the option ``Save as type: Text document``, with the name "setup_vagrant_and_virtualbox.bat" (notice the double quote).

4. Open it by double-clicking on ``setup_vagrant_and_virtualbox.bat``.

Now you have ``vagrant`` and ``virtualbox`` installed on your system.


Manual Installation
----------------------

1. Install ``vagrant`` with the version of **1.6.2** at: http://www.vagrantup.com/downloads.html.

2. Install ``virtualbox`` with the version of **4.3.12** at:
   https://www.virtualbox.org/wiki/Downloads

3. Install the latest ``git`` version at http://git-scm.com/

**Notice**:

- The 64-bit architecture is used and run every day, however, the 32-bit archirecture is expected to work, too.

- The virtualbox has an installation issue which is reported `here
  <https://www.virtualbox.org/ticket/4140>`_. If you `$ vagrant up` but can not start the virtual box,
  please find "VBoxUSBMon.inf" & "VBoxDrv.inf" in your installation directory and re-install it to fix the issue.


Environment Up
--------------

1. Open your terminal window and type:
    ::

      $ cd ~/
      $ git clone https://github.com/teracy-official/dev.git teracy-dev
      $ cd teracy-dev
      $ vagrant up

Notice:

- The home directory on ``Git Bash`` normally should point to your user's directory on windows.
  For example: ``C:\Documents and Settings\<user_name>``, this is the place you will find
  ``teracy-dev`` directory to import projects into your text editor later for coding.

- You may see the error:
    ::

      Vagrant uses the `VBoxManage` binary that ships with VirtualBox, and requires this to be available
      on the PATH. If VirtualBox is installed, please find the `VBoxManage` binary and add it to the PATH
      environmental variable.

To fix this error, add the path of the **VirtualBox** folder to your environment variable.

For example: In Windows, add this "C:\Program Files\Oracle\VirtualBox".

If the error still occur, you have to unistall and re-install VirtualBox, then Vagrant to fix
this error.

You should see the following similar messages at the end of ``$ vagrant up``:
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
