Getting Started
===============

To get started, you must follow the instruction steps below to setup the development environment.


Prerequisites
-------------

**1. Required:**

- ``virtualbox``
- ``vagrant``
- ``git``

**Notice**

We support SSH Agent Forwarding by default. It means you don't have to submit username & password
each time when work with Git like ``pull, push, rebase, etc`` on the Vagrant box.

Do the following guide to get it work:

- Mac/ Linux: https://help.github.com/articles/working-with-ssh-key-passphrases#platform-mac

- Window: https://help.github.com/articles/working-with-ssh-key-passphrases#platform-windows

- Remember that: never clone source code by HTTPS or GIT clone URL, we can not implement this by these protocol.
  (http://stackoverflow.com/questions/7773181/git-keeps-prompting-me-for-password)

Make this extra step and make your life simpler.

**Windows Notes**:

- You MUST install ``git`` to use ``Git Bash`` and from now on we will call it ``terminal window``.

- You MUST ALWAYS run ``virtualbox`` and ``Git Bash`` as **administrator** to make symlinks
  (of virtualenv) work as expected.


Automatic Installation
----------------------

To install required packages automatically, you need run **Ubuntu** 12.04. If not, you need to move
to the next alternative instruction by installing required packages manually.

Install ``git``, ``virtualbox``, ``vagrant`` with the provided bash script below:
::

    $ cd /tmp
    $ wget https://raw.github.com/teracy-official/dev/master/scripts/setup_working_env_chef.sh
    $ bash setup_working_env_chef.sh


Or Manual Installation
----------------------

You need to finish 3 following required simple steps:

1. Install ``vagrant`` with the version of **1.6.2** at: http://www.vagrantup.com/downloads.html

2. Install ``virtualbox`` with the version of **4.3.12** at:
   https://www.virtualbox.org/wiki/Downloads

3. Install latest ``git`` version at http://git-scm.com/

Notice:

- We use and run 64 bit architecture every day, however, 32 bit archirecture is expected to work, too.

- Please note that virtualbox has an installation issue which is reported here
  (https://www.virtualbox.org/ticket/4140). If you `$ vagrant up` but can not start virtual box,
  please find "VBoxUSBMon.inf" & "VBoxDrv.inf" in your installation directory and re-install it,
  this will fix the issue.


Environment Up
--------------

Open your terminal window and type:
::

    $ cd ~/
    $ git clone https://github.com/teracy-official/dev.git teracy-dev
    $ cd teracy-dev
    $ vagrant up

Notice:

1. The home directory on ``Git Bash`` normally should point to your user's directory on Windows.
For example: ``C:\Documents and Settings\<user_name>``, this is the place you will find
``teracy-dev`` directory to import projects into your text editor later for coding.

2. You may see the error:
::

    Vagrant uses the `VBoxManage` binary that ships with VirtualBox, and requires this to be available
    on the PATH. If VirtualBox is installed, please find the `VBoxManage` binary and add it to the PATH
    environmental variable.

Please add path to VirtualBox folder to your environment variable.
Example: in Window, add this "C:\Program Files\Oracle\VirtualBox".

If the error still occur, you have to unistall and re-install VirtualBox then Vagrant. This will fix
this error.

You should see the following similar messages at the end of ``$ vagrant up``:
::

    [2013-07-01T09:57:11+00:00] INFO: Chef Run complete in 160.951322714 seconds
    [2013-07-01T09:57:11+00:00] INFO: Running report handlers
    [2013-07-01T09:57:11+00:00] INFO: Report handlers complete

Last but not least, ``$ vagrant ssh`` to access the virtual machine you have just
installed which runs Ubuntu 12.04 with ssh. You should see the following similar messages:
::

    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.5.0-23-generic i686)

     * Documentation:  https://help.ubuntu.com/

    37 packages can be updated.
    18 updates are security updates.

    Last login: Wed Apr 24 07:43:49 2013 from 10.0.2.2

*Congratulations, you're all set now!*
