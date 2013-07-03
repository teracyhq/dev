=======================================
teracy's chef-dev - get development fun 
=======================================

This ``chef-dev`` repository was created for developing Django applications with ease and fun. We're going to use ``virtualbox`` for running Django projects, ``chef`` and ``vagrant`` for installing and configuring any neccessary packages.

By using this approach, you can work on any host machine with different OS, even Windows :-). However, Windows is NOT recommended for best development experience. You don't have to install tons of development
stuffs on your machine but on ``virtualbox`` only.

It's better to work on any *unix compatible OS (Mac OSX, Ubuntu, Fedora, Redhat, you name it :-D).


Ubuntu 12.04 is a **strongly** recommended OS for development, get it now at: http://www.ubuntu.com/download/desktop


Getting started
---------------

1. If you're on ``Ubuntu``:

    1.1. Install ``git``, ``virtualbox``, ``vagrant`` with a provided bash script: 
    ::
        $ cd /tmp
        $ wget https://raw.github.com/teracy-official/devops/master/scripts/setup_working_env_chef.sh
        $ bash setup_working_env_chef.sh

    1.2. Get github account with ssh keys configured (guide at: https://help.github.com/articles/generating-ssh-keys).


1. Or to get started manually, you need to finish 3 following simple steps:

	1.1. Install **latest** ``vagrant`` version at: http://downloads.vagrantup.com/

	1.2. Install ``Virtualbox`` with the version of **4.2.10** at: https://www.virtualbox.org/wiki/Download_Old_Builds_4_2

	1.3. Setup ``git`` with github at: https://help.github.com/articles/set-up-git
	
		After setting up, you should have:

			+ git client installed.

			+ github account with ssh keys configured (guide at: https://help.github.com/articles/generating-ssh-keys). You need to remember the location of these ssh keys (usually under ~/.ssh directory).

	Note: If you're on Windows, you SHOULD use ``git-bash`` to execute terminal commands.

2. From home directory (``~/``), clone this repository, copy ssh keys to ``cookbooks/teracy-dev/files/default/`` and ``vagrant up``. You should prepare yourself a cup of coffee as for the first time, it would take a little long time (~20-30 mins) to ``vagrant up``.
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

Last but not least, ``$ vagrant ssh`` to ssh-access the virtual machine you have just installed which runs Ubuntu 12.04. You should see the following similar messages:
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

Let's open the browser at http://localhost:8000, we will see a 404 error and it's normal.

We're going to create a Django application named ``hello`` to display ``Hello World!`` message when accessing http://localhost:8000 

It's time for coding, so we need an editor for it. ``Sublime Text`` is awesome, get and install it now at: http://www.sublimetext.com/

Open ``Sublime Text``, add ``workspace/personal/tutorial`` project (Menu: Project -> Add Folder to Project). The ``tutorial`` project should be opened and we could start coding now.

Usually, we need 2 terminal windows: 1 is used for running Django project and 1 is used for normal commands. Just open a new terminal window, change directory to ``chef-dev`` then ``$ vagrant ssh``.

A specific Django application should be put under ``apps`` directory. We're going to create ``hello`` application:
::
    $ ws
    $ workon tutorial
    $ cd personal/tutorial/apps
    $ ../manage.py startapp hello

Add `hello` application to ``INSTALLED_APPS`` on ``settings/dev.py``:
::
    INSTALLED_APPS += (
        'django.contrib.admin',
        'debug_toolbar',
        'compressor',
        'teracy.html5boilerplate',
        'apps.hello',
    ) 

Create ``home.html`` template under ``apps/hello/templates/hello`` directory with following content:
::
    {% extends 'html5boilerplate/base.html' %}

    {% block body_content %}
        <h1>Hello World!</h1>
        <h2>Welcome to Teracy's chef-dev - get development fun!</h2>
    {% endblock %}

Add ``HomeTemplateView`` to ``apps/hello/views.py``:
::
    from django.views.generic import TemplateView


    class HomeTemplateView(TemplateView):
        template_name = 'hello/home.html'

Create ``apps/hello/urls.py`` and configure ``HomeTemplateView`` with following content:
::
    from django.conf.urls import url, patterns

    from apps.hello.views import HomeTemplateView


    urlpatterns = patterns(
        '',
        url(r'^$', HomeTemplateView.as_view(), name='hello_home'),
    )

Configure the root url on ``urls/dev.py`` by adding the following content:
::
    urlpatterns += (
        url(r'', include('apps.hello.urls')),
    )  

During development, the server could be stopped by some errors and it's normal. If your coding skill is good enough (j/k :P), the server should be still running. If not, ``./manage.py runserver 0.0.0.0:8000`` again, the server should be started without any error.

Now, open your browser at http://localhost:8000 and you should see ``Hello World!`` page instead of the 404 error page.


Congratulations, you've just created a Django application and make it work even though it does nothing other than "Hello World!" page. You should now learn Django by developing many more applications for this ``tutorial`` project by adapting Django tutorials at https://docs.djangoproject.com/en/1.5/.


Learn more
----------

- Teracy's projects

    + https://github.com/teracy-official/teracy

    + https://github.com/teracy-official/teracy-html5boilerplate


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


Virtual machine's installed and configured packages by chef-dev
---------------------------------------------------------------

The base box is provided by https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04-i386_chef-11.4.4.box and additional packages installed are:

- ``apt``.

- ``vim``.

- ``git``.

- ``Python`` with ``pip``, ``virtualenv`` and ``virtualenvwrapper``.

Problems, want to help each other?
----------------------------------

During the development and learning, you're welcome to join us with discussions at https://groups.google.com/forum/#!forum/teracy

Frequently asked questions
--------------------------






