Document Guide
==============

At present we use ``reStructureText`` for project docs and ``Markdown`` for blog, spec docs.
To write docs more easily and style consistently, document writers must follow some guidelines
below.

It's expected that everyone should understand this guide to produce good documents.

Style Guide
-----------

..  todo::
    Need to have docs style guide here


reStructuredText Writing
------------------------

For easier .rst writing, we use restview_.

As ``restview`` is installed on the teracy-dev VM by default, we can use it immediately without any
installation steps. Make sure you have the teracy-dev VM running (``$ vagrant up``) by following the
:doc:`getting_started` guide.

To use ``restview``, just specify the watching directory and specify the listening port.

For example:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd personal
    $ mkdir restview-test
    $ cd restview-test
    $ touch test.rst
    $ restview . -l *:8000

And you should see the output like:

..  code-block:: bash

    Listening on http://vagrant:8000/

Open http://localhost:8000, you should see `test.rst` file, click on it to see the result.

..  tip::
    ``restview`` supports instant update without refreshing the brower, just update .rst files and
    we can see the result instantly.


Markdown Writing
----------------

..  todo::
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
