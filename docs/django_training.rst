Django Training
===============

Setup
-----

Follow :doc:`getting_started` guide.


Start A Django Project
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
    $ git remote add djbp https://github.com/teracy-official/django-boilerplate.git
    $ git fetch djbp
    $ git merge djbp/master
    $ pip install -r requirements/project/dev.txt
    $ ./manage.py syncdb

When ``syncdb``, you should create a super account to access the admin page later.

The project https://github.com/teracy-official/django-boilerplate will help us to get
project development booted with a Django project template (boilerplate) of best practices.

Let's run the server now:
::

    $ ./manage.py runserver 0.0.0.0:8000


You should see the following similar messages:
::

    Validating models...

    0 errors found
    July 01, 2013 - 10:44:01
    Django version 1.5.1, using settings 'settings.dev'
    Development server is running at http://0.0.0.0:8000/
    Quit the server with CONTROL-C.

Now open your browser, yes, your browser :-) at http://localhost:8000/admin and login with your
created super account.

Sweet, everything is cool now! However, the project does not do anything much yet. You need to
create Django applications for it.

Start A Django Application
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

We're going to use `teracy-django-html5-boilerplate <https://github.com/teracy-official/django-html5-boilerplate>`_,
it's a Django wrapper application that includes ``html5-boilerplate`` assets and provides
``base.html`` for starting any web application with ``html5-boilerplate``. So we need to install it
on our project.

Add dependency to ``requirements/project/dev.txt`` as follow:
::

    teracy-django-html5-boilerplate==0.3.0

Then install it:
::

    pip install -r requirements/project/dev.txt

You should see something like this:
::

    Installing collected packages: teracy-django-html5-boilerplate
      Running setup.py install for teracy-django-html5-boilerplate

        Skipping installation of /home/vagrant/.virtualenvs/tutorial-new/lib/python2.7/site-packages/teracy/__init__.py (namespace package)
        Skipping installation of /home/vagrant/.virtualenvs/tutorial-new/lib/python2.7/site-packages/teracy/__init__.pyc (namespace package)
        Installing /home/vagrant/.virtualenvs/tutorial-new/lib/python2.7/site-packages/teracy_django_html5_boilerplate-0.1.0-py2.7-nspkg.pth
    Successfully installed teracy-django-html5-boilerplate
    Cleaning up...

Install the teracy-html5boilerplate application to ``settings/project/dev.py``:
::

    INSTALLED_APPS += (
        'teracy.html5boilerplate',
    )

We need to create ``hello`` application now.


A specific Django application should be put under ``apps`` directory. We're going to create
``hello`` application:
::

    $ ws
    $ workon tutorial
    $ cd personal/tutorial/apps
    $ ../manage.py startapp hello

Add `hello` application to ``INSTALLED_APPS`` on ``settings/project/dev.py`` by appending the
following configuration:
::

    INSTALLED_APPS += (
        'teracy.html5boilerplate',
        'apps.hello',
    )



Create ``home.html`` template under ``apps/hello/templates/hello`` directory with the following
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

Configure the root url on ``urls/project/dev.py`` by adding the following content:
::

    urlpatterns += (
        url(r'', include('apps.hello.urls')),
    )

During development, the server could be stopped by some errors and it's normal.
``$ ./manage.py runserver 0.0.0.0:8000`` again, the server should be started without any error.

Now, open your browser at http://localhost:8000 and you should see ``Hello World!`` page instead
of the 404 error page.


Congratulations, you've just created a Django application and make it work even though it does
nothing other than "Hello World!" page. You should now learn Django by developing many more
applications for this ``tutorial`` project by adapting Django tutorials at
https://docs.djangoproject.com/en/1.5/.
