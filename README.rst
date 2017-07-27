teracy-dev
==========

.. image:: https://travis-ci.org/teracyhq/dev.svg?branch=develop
    :target: https://travis-ci.org/teracyhq/dev

Issues board: https://waffle.io/teracyhq/all?source=teracyhq%2Fdev


The only truly universal productive software development platform for all!


``teracy-dev`` is created to set up a universal development platform which has the same development
workflow on Mac, Linux and Windows with good developer experience and productivity in mind. 

We leverage Docker workflow for our software development and we use ``vagrant``, ``virtualbox``, and
``chef`` to install and configure any necessary packages.

By using this approach, we can work in a consistent development environment and workflow.
We do not have to install tons of development stuff on the host machine **manually** to get started.

.. note:: We are using the https://github.com/acme101 project to show the best practices from ``teracy-dev`` applied for organizations.


Features
--------

- fully automated managed servers on your local machine (by leveraging ``vagrant`` + ``chef``
  provisioner). This saves you a lot of time and money to work on many virtual private servers (VPS)
  on your local machine before deploying applications on the production servers.
- the universally same workflow on Windows, Linux and Mac
- higher performance and productivity gain than default vagrant settings
- support different configuration management tools (provisioners)
- default set up with easy personalized configuration settings without any limitation
- seamless upgrading to the next updated versions of teracy-dev
- best practices to develop and deploy applications
- a full-stack developer workstation
- many more features that you will discover yourselves when using this

Installation and Usage
----------------------

Follow the guide at http://dev.teracy.org/docs/getting_started.html


License
-------

BSD License
