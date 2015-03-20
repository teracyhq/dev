Document Guide
==============

At present we use reStructureText for project docs and Markdown for blog, spec docs.
To write docs more easily and style consistently, document writers must follow some guidelines
below.

It's expected that everyone should understand this guide to produce good documents.

Style Guide
-----------

.. todo::
    Need to have docs style guide here


reStructuredText Wring
----------------------

For easier .rst writing, we use restview_.

As `restview` is installed on the teracy-dev VM by default, we could use it immediately without any
installation steps. Make sure you have teracy-dev VM running by following :doc:`getting_started`
guide.

To use `restview`, just specify the watching directory and specify the listen port.

For example:
::

    $ vagrant ssh
    $ ws
    $ cd personal
    $ mkdir restview-test
    $ cd restview-test
    $ touch test.rst
    $ restview . -l *:8000

And you should see the output like:
::

    Listening on http://vagrant:8000/

Openning http://localhost:8000, you should see `test.rst` file, just click on it to see the result.

.. tip::
    `restview` supports instant update without refreshing the brower, just update .rst files and we
    could see the result instantly.


Markdown Writing
----------------

.. todo::
    find good live markdown libs, for example:

    - https://github.com/shime/livedown
    - https://github.com/mobily/markdown-live


References
----------
- http://docutils.sourceforge.net/rst.html
- http://sphinx-doc.org/
- http://daringfireball.net/projects/markdown/syntax
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet


.. _restview: https://mg.pov.lt/restview/
