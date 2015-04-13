Django Training
===============

Setup
----------

Follow :doc:`getting_started` guide.


Starting A Django Project
--------------------------
In this section, you will know how to create a ``tutorial`` Django project via some following simple
steps:

#. Run the project under a virtual Python environment.
    ::

        $ mkvirtualenv tutorial

    You should see the following similar messages:
    ::

        New python executable in tutorial/bin/python
        Installing setuptools............done.
        Installing pip...............done.

    You are now under the ``tutorial`` virtual Python environment. Use ``$ deactive`` to escape it or
    ``$ workon tutorial`` to be under the ``tutorial`` virtual Python environment.

#. Set up the ``tutorial`` project:
    ::

        $ ws
        $ cd personal
        $ mkdir tutorial
        $ cd tutorial
        $ git init
        $ git remote add djbp https://github.com/teracy-official/django-boilerplate.git
        $ git fetch djbp
        $ git merge djbp/master
        $ pip install -r requirements/dev.txt
        $ python manage.py syncdb

    When ``syncdb``, you should create a super account to access the admin page later.

    The project https://github.com/teracy-official/django-boilerplate will help you get
    project development booted with a Django project template (boilerplate) of the best practices.

#. Run the server now:
    ::

        $ python manage.py runserver 0.0.0.0:8000


    You should see the following similar messages:
    ::

        Validating models...

        0 errors found
        July 01, 2013 - 10:44:01
        Django version 1.5.1, using settings 'settings.dev'
        Development server is running at http://0.0.0.0:8000/
        Quit the server with CONTROL-C.

#. Open your browser at http://localhost:8000/admin and login with your created super account.

Sweet, everything is cool now! However, the project does not do anything much yet. You need to
create Django applications for it.

Starting A Django Application
-----------------------------
This section shows you how to create a Django application named ``hello`` to display the ``Hello
World!`` message when accessing http://localhost:8000.

#. Open the browser at http://localhost:8000.

   You will see a 404 error and it is normal.

#. Install an editor for coding. If you have had it, skip this step.

   At Teracy, you are suggested to use `Sublime Text <http://www.sublimetext.com/>`_. Download and
   install it on your computer.

#. Open ``Sublime Text``, add ``workspace/personal/tutorial`` project by clicking **Project** ->
   **Add  Folder to Project**.
   
   The ``tutorial`` project should be opened and you can start coding now.

#. Open two terminal windows:

   Usually, you need two terminal windows:

   - One is used for running the Django project. Open a new terminal window, change the
     directory to ``teracy-dev``, then ``$ vagrant ssh``.

   - The other one is used for normal commands.

#. Install ``teracy-django-html5-boilerplate`` to your project
   `teracy-django-html5-boilerplate <https://github.com/teracy-official/django-html5-boilerplate>`_
   is a Django wrapper application that includes ``html5-boilerplate`` assets and provides
   ``base.html``for starting any web application with ``html5-boilerplate``, so you need to install
   it on your project.

    - Add the following dependency to ``requirements/project/dev.txt``:
      ::

        teracy-django-html5-boilerplate==0.3.0

    - Install it:
      ::

        pip install -r requirements/dev.txt

    You should see something like this:
    ::

        Installing collected packages: teracy-django-html5-boilerplate
        Running setup.py install for teracy-django-html5-boilerplate

            Skipping installation of /home/vagrant/.virtualenvs/tutorial-new/lib/python2.7/site-packages/teracy/__init__.py (namespace package)
            Skipping installation of /home/vagrant/.virtualenvs/tutorial-new/lib/python2.7/site-packages/teracy/__init__.pyc (namespace package)
            Installing /home/vagrant/.virtualenvs/tutorial-new/lib/python2.7/site-packages/teracy_django_html5_boilerplate-0.1.0-py2.7-nspkg.pth
            Successfully installed teracy-django-html5-boilerplate
            Cleaning up...

#. Install the ``teracy-html5boilerplate`` application to ``settings/project/dev.py``: 
    ::

       INSTALLED_APPS += (
        'teracy.html5boilerplate',
         )  
#. Create  the ``hello`` application  

    .. note::
         A specific Django application should be put under ``apps`` directory.
    
    ::

        $ ws
        $ workon tutorial
        $ cd personal/tutorial/apps
        $ python manage.py startapp hello

#. Add the ``hello`` application to ``INSTALLED_APPS`` on ``settings/project/dev.py`` by appending
   the following configuration:

    ::

        INSTALLED_APPS += (
            'teracy.html5boilerplate',
            'apps.hello',
        )

#. Create the ``home.html`` template under the ``apps/hello/templates/hello`` directory with the
   following content:
   
    ::

        {% extends 'html5boilerplate/base.html' %}

        {% block body_content %}
            <h1>Hello World!</h1>
            <h2>Welcome to <strong>teracy-dev</strong> - get development fun!</h2>
        {% endblock %}
#. Add ``HomeTemplateView`` to ``apps/hello/views.py``:
    ::

        from django.views.generic import TemplateView

        class HomeTemplateView(TemplateView):
            template_name = 'hello/home.html'
#. Create ``apps/hello/urls.py`` and configure ``HomeTemplateView`` with following content:
    ::

        from django.conf.urls import url, patterns

        from apps.hello.views import HomeTemplateView


        urlpatterns = patterns(
            '',
            url(r'^$', HomeTemplateView.as_view(), name='hello_home'),
        )
#. Configure the root URL on ``urls/project/dev.py`` by adding the following content:
    ::

        urlpatterns += (
            url(r'', include('apps.hello.urls')),
        )

#. Refresh your browser opening http://localhost:8000 and you should see ``Hello World!`` page instead
   of the 404 error page.

.. note::

    During development, the server could be stopped by some errors and it is normal.
    The server should be started without any error with the command:
    ::
    
        $ python manage.py runserver 0.0.0.0:8000

Congratulations, you have just created a Django application and make it work even though it does
nothing other than "Hello World!" page. You should now learn Django by developing many more
applications for this ``tutorial`` project by adapting Django tutorials at
https://docs.djangoproject.com/en/1.5/.
