Getting Started
===============

To get started, you must follow the instruction steps below to setup the development environment.


Prerequisites
-------------

**1. Required:**

- ``virtualbox``
- ``vagrant``

**2. Optional:**

- ``git``

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

You need to finish 2 (or 3 on Windows) following required simple steps:

1. Install ``vagrant`` with the version of **1.2.7** at: http://downloads.vagrantup.com/tags/v1.2.7

2. Install ``virtualbox`` with the version of **4.2.10** at:
   https://www.virtualbox.org/wiki/Download_Old_Builds_4_2

3. [**Required on Windows only**] Install latest ``git`` version at http://git-scm.com/ to use
   ``Git Bash`` as a terminal.

Notice: We use and run 64 bit architecture every day, however, 32 bit archirecture is expected to work, too.


Environment Up
--------------

- Have ``git`` installed:

Open your terminal window and type:
::

    $ cd ~/
    $ git clone https://github.com/teracy-official/dev.git teracy-dev
    $ cd teracy-dev
    $ vagrant up

- Or no ``git`` installed:

Download the repository at https://github.com/teracy-official/dev/archive/master.zip and
unzip with named ``teracy-dev`` at ``~/`` (\*unix) or ``C:\Documents and Settings\<user_name>``
(Windows). Then open your terminal window:
::

    $ cd ~/
    $ cd teracy-dev
    $ vagrant up


Note: The home directory on ``Git Bash`` normally should point to your user's directory on Windows.
For example: ``C:\Documents and Settings\<user_name>``, this is the place you will find
``teracy-dev`` directory to import projects into your text editor later for coding.


You should see the following similar messages at the end of ``$ vagrant up``:
::

    [2013-07-01T09:57:11+00:00] INFO: Chef Run complete in 160.951322714 seconds
    [2013-07-01T09:57:11+00:00] INFO: Running report handlers
    [2013-07-01T09:57:11+00:00] INFO: Report handlers complete

Notice:
1. We support for vagrant 1.5.1, virtualbox 4.3.8 AND vagrant 1.5.4, virtualbox 4.3.10
2. Please note that virtualbox has an installation issue which is reported here ( https://www.virtualbox.org/ticket/4140 ). If you $ vagrant up but can not start virtual box, pls find "VBoxUSBMon.inf" & "VBoxDrv.inf" in your installation directory and re-install it, it will fix the issues.

Last but not least, ``$ vagrant ssh`` to access the virtual machine you have just
installed which runs Ubuntu 12.04 with ssh. You should see the following similar messages:
::

    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.5.0-23-generic i686)

     * Documentation:  https://help.ubuntu.com/

    37 packages can be updated.
    18 updates are security updates.

    Last login: Wed Apr 24 07:43:49 2013 from 10.0.2.2

*Congratulations, you're all set now!*
