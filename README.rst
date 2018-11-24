teracy-dev
==========

.. image:: https://travis-ci.org/teracyhq/dev.svg?branch=develop
    :target: https://travis-ci.org/teracyhq/dev

Issues board: https://waffle.io/teracyhq/all?source=teracyhq%2Fdev


The only truly universal productive software development platform for all!


``teracy-dev`` is created to set up a universal development platform which has the same development
workflow on Mac, Linux and Windows with good developer experience and productivity in mind.


`teracy-dev` is super minimal kernel with extension mechanism so that we can use/ develop many
different extensions by our needs.


Features
--------

- super minimal kernel
- highly configurable and extensible with extensions
- the universally same workflow on Windows, Linux and Mac
- best practices to develop and deploy any types of stacks and architectures


Useful Extensions
-----------------

- teracy-dev-core: https://github.com/teracyhq-incubator/teracy-dev-core
- teracy-dev-essential: https://github.com/teracyhq-incubator/teracy-dev-essential
- teracy-dev-certs: https://github.com/teracyhq-incubator/teracy-dev-certs
- teracy-dev-k8s: https://github.com/teracyhq-incubator/teracy-dev-k8s
- teracy-dev-v05-compat: https://github.com/teracyhq-incubator/teracy-dev-v05-compat


Installation and Usage
----------------------

Follow the guide at http://dev.teracy.org/docs/develop/getting_started.html

How to develop
--------------
Follow the commands below to pull the latest code of teracy-dev and you can continue to develop it.

   ..  code-block:: bash

      $ cd ~/
      $ git clone <your_forked_repo> teracy-dev
      $ cd teracy-dev
      $ git remote add upstream git@github.com:teracyhq/dev.git
      $ git fetch upstream # get the changes from the upstream repo
      $ git checkout develop # the develop branch to work on it
      $ git branch -u upstream/develop # track the upstream's branch
      $ git pull # update to the latest upstream's changes


License
-------

BSD License
