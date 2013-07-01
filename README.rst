=======================================
teracy's chef-dev - get development fun 
=======================================

Starting project development with teracy's projects is never so easy. chef-dev is where all development happen and we could work on any *unix compatible OS (Mac OSX, Ubuntu, Fedora, you name it) and even on Windows :-D. However, we do NOT recommened Windows for best development expericience.

Ubuntu 12.04 is a **strongly** recommended OS for development, get it now at: http://www.ubuntu.com/download/desktop

Getting started
---------------

1. If you're on ``Ubuntu``:
	
	- Download and run this bash script: 


1. Or to get started manually, you need to finish 3 following simple steps:

	1.1. Install **latest** ``vagrant`` version at: http://downloads.vagrantup.com/tags/v1.2.2

	1.2. Install ``Virtualbox`` with the version of **4.2.10** at: https://www.virtualbox.org/wiki/Download_Old_Builds_4_2

	1.3. Setup ``git`` with github at: https://help.github.com/articles/set-up-git
	
		After setting up, you should have:

			+ git client installed.

			+ github account with ssh keys configured (guide at: https://help.github.com/articles/generating-ssh-keys). You need to remember the location of these ssh keys (usually under ~/.ssh directory).

	Note: If you're on Windows, you SHOULD use ``git-bash`` to execute terminal commands.

2. From home directory (``~/``), clone this repository, copy ssh keys to ``cookbooks/teracy-dev/files/default/`` and ``vagrant up``. You should prepare yourself a cup of coffee as this would take a little long time (~20-30 mins) to ``vagrant up`` at the first time only.	
::
	$ cd ~/
    $ git clone git@github.com:teracy-official/chef-dev.git
	$ cd chef-dev
	$ cp ~/.ssh/id_rsa* cookbooks/teracy-dev/files/default/
	$ vagrant up

You should see the following similar messages at the end of ``$ vagrant up``:
::
	[2013-07-01T09:57:11+00:00] INFO: Chef Run complete in 160.951322714 seconds
	[2013-07-01T09:57:11+00:00] INFO: Running report handlers
	[2013-07-01T09:57:11+00:00] INFO: Report handlers complete

Last but not least, ``$ vagrant ssh`` to ssh-access the virtual machine you have just installed which runs Ubuntu 12.04. You should see the following similar mesasages:
:: 
	Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.5.0-23-generic i686)

	 * Documentation:  https://help.ubuntu.com/

	37 packages can be updated.
	18 updates are security updates.

	Last login: Wed Apr 24 07:43:49 2013 from 10.0.2.2

*Congratulations, you're set now!*
	

Workspace directory
-------------------

After ``vagrant up``, the ``workspace`` directory was created under ``chef-dev``. This ``workspace`` directory is the location where you will store all your work.

``workspace/personal``: the location to store all your stuffs which you have full control of it (your own projects).

``workspace/readonly``: the location to store all the stuffs that you could read only (open source projects).

``workspace/teracy``: the location to store all the official stuffs of teracy's at https://github.com/teracy-official

You could access this ``workspace`` directory from the virtual machine (``$ cd /vagrant/workspace`` or alias ``$ ws``) or from the host machine (``$ cd ~/chef-dev/workspace``).

From now on, we will ``vagrant ssh`` and run command lines on the virtual machine if not explicitly mentioning about the host machine terminal.

Start a Django project
----------------------

To start a tutorial Django project, you must run it under a virtual Python environment.
::
	$ mkvirtualenv tutorial

You should see the following similar messages:
::
	New python executable in tutorial/bin/python
	Installing setuptools............done.
	Installing pip...............done.

You're now under ``tutorial`` virtual Python environment. ``$ deactive`` to escape it or ``$ workon tutorial`` to be under ``tutorial`` virtual Python environment.
 
Continue to setup the ``tutorial`` project:
::
    $ ws
    $ cd personal
    $ mkdir tutorial
    $ cd tutorial
    $ git init
    $ git remote add teracy git@github.com:teracy-official/teracy.git
    $ git pull teracy
    $ git merge teracy/master 
    $ pip install -r requirements/dev.txt
    $ ./manage.py syncdb
    $ ./manage.py runserver 0.0.0.0:8000

When ``syncdb``, you should create the super account to access the admin page.

You should see the following similar messages:
::
    Validating models...

    0 errors found
    July 01, 2013 - 10:44:01
    Django version 1.5.1, using settings 'settings.dev'
    Development server is running at http://0.0.0.0:8000/
    Quit the server with CONTROL-C.
	
Now open your browser, yes, your browser :-) with http://localhost:8000/admin and login with your created super account.

Sweet, everything is cool now! However, the project does not do anything much yet. You need to create Django applications for it.

Start a Django application
--------------------------

We're going to create a Django application named ``tutorial`` to display ``Hello World!`` message when accessing http://localhost:8000



Frequently asked questions
--------------------------






