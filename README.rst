=================================
teracy-dev - get development fun!
=================================

This ``teracy-dev`` repository was created for developing Django applications with ease and fun. 
We're going to use ``virtualbox`` for running Django projects, ``chef`` and ``vagrant`` for 
installing and configuring any neccessary packages.

By using this approach, we can work on any host machine with different OS, even Windows :-). 
However, Windows is NOT recommended for best development experience. You don't have to install tons 
of development stuffs on your host machine but on ``virtualbox`` only.

It's better to work on any *nix compatible OS (Mac OSX, Ubuntu, Fedora, Redhat, you name it :-D).


Ubuntu 12.04 is a **strongly** recommended OS for development, get it now at: 
http://www.ubuntu.com/download/desktop


Getting started
---------------

You're required to install ``VirtualBox``, ``Vagrant`` then download this repository and unzip it,
and you're done to start. It's very easy to get started!

1. If you're on ``Ubuntu``:

    Install ``git``, ``virtualbox``, ``vagrant`` with the provided bash script below: 
    ::
        $ cd /tmp
        $ wget https://raw.github.com/teracy-official/teracy-dev/master/scripts/setup_working_env_chef.sh
        $ bash setup_working_env_chef.sh


1. Or to get started manually, you need to finish 2 required following simple steps:

    1.1. Install **latest** ``vagrant`` version at: http://downloads.vagrantup.com/

    1.2. Install ``virtualbox`` with the version of **4.2.10** at: 
         https://www.virtualbox.org/wiki/Download_Old_Builds_4_2

    1.3. [Required on Windows only] Install latest ``git`` version at http://git-scm.com/ to use 
    ``git-bash`` as terminal window.

2. From home directory (``~/``), download or clone this repository and ``$ vagrant up``. You should 
prepare yourself a cup of coffee as for the first time, it would take a little long time 
(~20-30 mins) to ``$ vagrant up``. 

- No ``git`` installed: 
Download and unzip this repository at https://github.com/teracy-official/teracy-dev/archive/master.zip
then open your terminal window:
::
    $ cd teracy-dev
    $ vagrant up

- Have ``git`` installed: 
Open your terminal window and type:
::
    $ cd ~/
    $ git clone https://github.com/teracy-official/teracy-dev.git
    $ cd teracy-dev
    $ vagrant up

You should see the following similar messages at the end of ``$ vagrant up``:
::
    [2013-07-01T09:57:11+00:00] INFO: Chef Run complete in 160.951322714 seconds
    [2013-07-01T09:57:11+00:00] INFO: Running report handlers
    [2013-07-01T09:57:11+00:00] INFO: Report handlers complete

Last but not least, ``$ vagrant ssh`` to access with ssh the virtual machine you have just 
installed which runs Ubuntu 12.04. You should see the following similar messages:
:: 
    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.5.0-23-generic i686)

     * Documentation:  https://help.ubuntu.com/

    37 packages can be updated.
    18 updates are security updates.

    Last login: Wed Apr 24 07:43:49 2013 from 10.0.2.2

*Congratulations, you're set now!*
    

``workspace`` directory
-----------------------

The ``workspace`` directory was created under ``teracy-dev``. This ``workspace`` directory is the 
location where you will store all your work, after ``$ vagrant up``, the following sub directories 
will be created if they do not exist yet.

``workspace/personal``: the location to store all your stuffs which you have full control of it 
(your own projects).

``workspace/readonly``: the location to store all the stuffs that you could read only (open source 
projects).

``workspace/teracy``: the location to store all the official stuffs of teracy's at 
https://github.com/teracy-official

The ``teracy-dev/workspace`` directory from host machine was mapped to ``~/workspace`` directory 
on the virtual machine. So you could access this ``workspace`` directory from the virtual machine 
(``$ cd ~/workspace`` or alias ``$ ws``).

From now on, we will ``$ vagrant ssh`` and run command lines on the virtual machine if not 
explicitly mentioning about running command lines on the host machine.

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

You're now under ``tutorial`` virtual Python environment. ``$ deactive`` to escape it or 
``$ workon tutorial`` to be under ``tutorial`` virtual Python environment.
 
Let's continue to setup the ``tutorial`` project:
::
    $ ws
    $ cd personal
    $ mkdir tutorial
    $ cd tutorial
    $ git init
    $ git remote add teracy https://github.com/teracy-official/teracy.git
    $ git fetch teracy
    $ git merge teracy/master 
    $ pip install -r requirements/dev.txt
    $ ./manage.py syncdb
    $ ./manage.py runserver 0.0.0.0:8000

The project https://github.com/teracy-official/teracy.git will help us to get project development 
booted with a Django project template (boilerplate) of best practices.

When ``syncdb``, you should create the super account to access the admin page.

You should see the following similar messages:
::
    Validating models...

    0 errors found
    July 01, 2013 - 10:44:01
    Django version 1.5.1, using settings 'settings.dev'
    Development server is running at http://0.0.0.0:8000/
    Quit the server with CONTROL-C.
    
Now open your browser, yes, your browser :-) with http://localhost:8000/admin and login with your 
created super account.

Sweet, everything is cool now! However, the project does not do anything much yet. You need to 
create Django applications for it.

Start a Django application
--------------------------

Let's open the browser at http://localhost:8000, we will see a 404 error and it's normal.

We're going to create a Django application named ``hello`` to display ``Hello World!`` message when 
accessing http://localhost:8000 

It's time for coding, so we need an editor for it. ``Sublime Text`` is awesome, get and install it 
now at: http://www.sublimetext.com/

Open ``Sublime Text``, add ``workspace/personal/tutorial`` project (Menu: Project -> Add Folder to 
Project). The ``tutorial`` project should be opened and we could start coding now.

Usually, we need 2 terminal windows: One is used for running Django project and the other one is 
used for normal commands. Just open a new terminal window, change directory to ``teracy-dev`` then 
``$ vagrant ssh``.

A specific Django application should be put under ``apps`` directory. We're going to create 
``hello`` application:
::
    $ ws
    $ workon tutorial
    $ cd personal/tutorial/apps
    $ ../manage.py startapp hello

Add `hello` application to ``INSTALLED_APPS`` on ``settings/dev.py`` by appending the following 
configuration:
::
    INSTALLED_APPS += (
        'apps.hello',
    ) 

Create ``home.html`` template under ``apps/hello/templates/hello`` directory with following 
content:
::
    {% extends 'html5boilerplate/base.html' %}

    {% block body_content %}
        <h1>Hello World!</h1>
        <h2>Welcome to <strong>teracy-dev</strong> - get development fun!</h2>
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

During development, the server could be stopped by some errors and it's normal. If your coding 
skill is good enough (j/k :P), the server should be still running. If not, 
``$ ./manage.py runserver 0.0.0.0:8000`` again, the server should be started without any error.

Now, open your browser at http://localhost:8000 and you should see ``Hello World!`` page instead 
of the 404 error page.


Congratulations, you've just created a Django application and make it work even though it does 
nothing other than "Hello World!" page. You should now learn Django by developing many more 
applications for this ``tutorial`` project by adapting Django tutorials at 
https://docs.djangoproject.com/en/1.5/.


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


ssh keys
--------

1. To be able to use ssh keys on the virtual machine, you must configure the use of ssh from 
``Vagrantfile``: replace ``"ssh" => false`` by ``"ssh" => true``.

2. Use existing ssh keys: ``id_rsa`` and ``id_rsa.pub`` from *cookbooks/teracy-dev/files/default* 
will be always copied into the virtual machine each time of login into the virtual machine. This 
mechanism is used to make sure you can always have updated ssh keys into the virtual machine. Just 
put files there, and you're done after ``$ vagrant ssh`` again.

3. If you don't want to use existing ssh keys (means that no id_rsa and id_rsa.pub in the cookbook), 
then ``$ vagrant ssh`` will ask you to create ssh keys right after login. You need to use default 
key name (id_rsa). These are new generated keys. So to use for ssh access, you must provide this 
new public key to ssh servers (add public key to github, bitbucket accounts).
These new generated keys will be also copied into *cookbooks/teracy-dev/files/default*. When the 
virtual machine is ``destroy`` and ``up`` again, it will be copied into ``./ssh`` directory of the 
virtual machine again as described in step 2 above.


Virtual machine's installed and configured packages by ``vagrant`` with ``chef-solo`` provision
------------------------------------------------------------------------------------------------

The base box is provided by https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04-i386_chef-11.4.4.box 
and additional packages installed are:

- ``apt``.

- ``vim``.

- ``git``.

- ``Python`` with ``pip``, ``virtualenv`` and ``virtualenvwrapper``.

You could see it clearly on ``Vagrantfile`` with the following similar content:
::
      # Enable provisioning with chef solo, specifying a cookbooks path, roles
      # path, and data_bags path (all relative to this Vagrantfile), and adding
      # some recipes and/or roles.
      #
      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "cookbooks"
        chef.roles_path = "roles"
        chef.data_bags_path = "data_bags"

        chef.add_recipe "apt" #required for installing vim (?!)
        chef.add_recipe "vim"
        chef.add_recipe "python"
        chef.add_recipe "git"
        chef.add_recipe "teracy-dev"
      #   chef.add_recipe "mysql"
      #   chef.add_role "web"
      #
      #   # You may also specify custom JSON attributes:
      #   chef.json = { :mysql_password => "foo" }
      end

For more information about ``chef``, see it at http://www.opscode.com/chef/.

Problems, want to help each other?
----------------------------------

During the development and learning, you're welcome to join us with discussions at 
https://groups.google.com/forum/#!forum/teracy

Frequently asked questions
--------------------------

