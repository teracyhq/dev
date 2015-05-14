Python Development Guide
========================

Python_ is a very powerful language that we use for many different projects at Teracy. In this
guide, we're going to explore the Python language and some Python web frameworks.


``Python`` should be available by default on the ``teracy-dev`` VM, so make sure you have the
``teracy-dev`` VM running by following the :doc:`getting_started` guide.

..  note::
    pyenv_, virtualenv_ and virtualenvwrapper_ are already installed and available to use.


Verify that ``Python`` Works
----------------------------

..  code-block:: bash

    $ vagrant ssh
    $ python --version

And you should see something like this:

..  code-block:: bash

    Python 2.7.6

Congratulations, you can do all ``Python`` related stuff now!


Learn
-----

There are many free resources for learning Python and those listed ones below are just some of
those. We should learn from easy to harder levels.

#.  Python tutorial

    Introduction about Python: https://docs.python.org/2/tutorial/index.html

#.  Python Course

    Very easy to follow: http://www.codecademy.com/tracks/python

#.  Dive into Python

    Useful for middle level: http://www.diveintopython.net/toc/index.html

#.  Learn Python the hard way

    Required to work: http://learnpythonthehardway.org/book/


Flask Framework
---------------

After learning ``Python``, you should know how to use Flask_ for web application development.

Follow the steps below to get started.

#.  Create a virtualenv

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ mkdir flask-app
        $ cd flask-app
        $ mkvirtualenv flask-app

#.  Install the `Flask` package

    ..  code-block:: bash

        $ pip install Flask

#.  Create `hello.py` under `flask-app` directory with the following content:

    ..  code-block:: python

        from flask import Flask
        app = Flask(__name__)

        @app.route("/")
        def hello():
            return "Hello World!"

        if __name__ == "__main__":
            app.run(host='0.0.0.0')


#.  Run the ``Flask`` web app

    ..  code-block:: bash

        $ python hello.py

    Now open http://localhost:5000 on the browser to see the web app.


..  tip::

    Teracy introduces flask-boilerplate_ to speed up `Flask` development with best practices.


Django Framework
----------------

After learning ``Python``, you should know how to use Django_ for web application development.

Follow the steps below to get started.

#.  Create a virtualenv

    .. code-block:: bash

        $ ws
        $ cd personal
        $ mkvirtualenv django-app

#.  Install the `Django` package

    ..  code-block:: bash

        $ pip install Django

#.  Create a `Django` application

    ..  code-block:: bash

        $ django-admin startproject django_app


#.  Run the `Django` application

    ..  code-block:: bash

        $ cd django_app
        $ python manage.py migrate
        $ python manage.py runrver 0.0.0.0:8000

    Now open http://localhost:8000 on your browser to see the web app.

..  tip::

    Teracy introduces django-boilerplate_ to speed up `Django` development with best practices and
    we follow the :doc:`django_training` guide.

References
----------

- https://www.python.org/
- http://flask.pocoo.org/
- https://www.djangoproject.com/

..  _Python: https://www.python.org/
..  _pyenv: https://github.com/yyuu/pyenv
..  _virtualenv: http://docs.python-guide.org/en/latest/dev/virtualenvs/
..  _virtualenvwrapper: https://virtualenvwrapper.readthedocs.org/en/latest/
..  _Flask: http://flask.pocoo.org/
..  _Django: https://www.djangoproject.com/
..  _flask-boilerplate: https://github.com/teracyhq/flask-boilerplate
..  _django-boilerplate: https://github.com/teracyhq/django-boilerplate

