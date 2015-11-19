Git Training
============

Git is a distributed version control systems (DVCS) which was used to manange all Teracy's
development resources. You need to learn to use Git to work with Teracy's projects.

Studying
---------

There are many free available resources for you to study git. The followings are some recommended resources:

- http://git-scm.com/book

- http://sixrevisions.com/resources/git-tutorials-beginners/

- http://documentup.com/skwp/git-workflows-book

Practising
----------

- Prerequisites

    + You need to have a github account with configured ssh keys.

    + ``teracy-dev`` is running with working ssh (``$ ssh -T git@github.com`` should be ok).

- Git basics

    + You are going to create a ``pro-git-practice`` repository on github (via github's web UI).

    + The repository on your VM should be at ``workspace/personal/pro-git-practice``.

    + Read the chapter 2 and practice with your ``pro-git-practice`` repository on your VM at
      http://git-scm.com/book/en/Git-Basics.

    + Remember to push the changes to github so we could see your work and practice.


- Working again on teracy-tutorial

.. note::
    You are encouraged to practice with as many git commands as possible, but have to follow
    strictly all the instructions below, the results will be displayed on github to check.

As you remember, you practiced to adapt Django's tutorial into Teracy's ``Django boilerplate`` project.

Now you will continue to work on it with git and push it to github.

#. Initial setup:

    - Create your repository named ``teracy-tutorial`` on github, and set up the local repo ``   workspace/personal/teracy-tutorial`` on your VM.

    - Push this first commit on github (Initial setup).

#. Setting up project layout

    - Add the remote repository https://github.com/teracyhq/django-boilerplate.git into
      your repository with the ``djbp`` name.

    - Fetch and merge the ``djbp/master`` branch.

    - Push the merge to your github's repository at ``origin/master``.

#. Tutorial 01 at https://docs.djangoproject.com/en/1.5/intro/tutorial01/.

    - Create a branch named ``tutorial01``, branch off from ``origin/master``.

    - Checkout the ``tutorial01`` branch

    - Skip the section of ``startproject`` as we already started a project with ``teracy``.

    - Work on the ``Creating models`` section and commit the changes with the message: ``Creating models``.

    - Work on the ``Activating models`` section and commit the changes with the message: ``Activating
      models``.

    - Work on the ``Playing with the API`` section and commit the changes with the message: ``Playing
      with the API``.

    - Push the ``tutorial01`` branch to ``origin/tutorial01`` branch. 

    (You should open the repository on github and see the branch there.)

    - Merge (no fast forward) (hint: $ git merge --no-ff) the ``tutorial01`` branch into the ``master``
      branch, then push to the ``origin/master`` branch.

#. Tutorial 02 at https://docs.djangoproject.com/en/1.5/intro/tutorial02/.

    - Create a branch named ``tutorial02``, branch off from ``origin/master``.

    - Checkout ``tutorial02`` branch.

    - Skip ``Activate the admin site`` section as admin is activated by teracy's project layout on
      ``settings/dev.py``.

    - Work on the ``Make the poll app modifiable in the admin`` section and commit the changes.

    - Work on the ``Customize the admin form`` section and commit the changes.

    - Work on the ``Adding related objects`` section and commit the changes.

    - Work on the ``Customize the admin change list`` section and commit the changes.

    - Work on the ``Customize the admin look and feel`` section and commit the changes.

    .. note::
        TEMPLATE_DIRS is already configured by ``teracy-django-boilerplate``, you could just use
        it.

    - Work on the ``Customize the admin index page`` section and commit the changes.

    - Push ``tutorial02`` to ``origin/tutorial02`` and see it on github.

    - Merge no fast forward ``tutorial02`` into ``master`` and push to ``origin/master``.

#. Tutorial 03 at https://docs.djangoproject.com/en/1.5/intro/tutorial03/

    - Create a branch named ``tutorial03``, branch off from ``origin/master``.

    - Checkout the ``tutorial03`` branch.

    - Work on the ``Write your first view`` section and commit.

    - Work on the ``Writing more views`` section and commit.

    - Work on the ``Write views that actually do something`` section and commit.

    - Work on the ``A shortcut: render()`` section and commit.

    - Work on the ``Raising a 404 error`` section and commit.

    - Work on the ``A shortcut: get_object_or_404()`` section and commit.

    - Work on the ``Write a 404 (page not found) view`` section and commit.

    - Work on the ``Write a 500 (server error) view`` section and commit.

    - Work on the ``Use the template system`` section and commit.

    - Work on the ``Removing hardcoded URLs in templates`` section and commit.

    - Work on the ``Namespacing URL names`` section and commit.

    - Push ``tutorial03`` to ``origin/tutorial03`` and see it on github.

    - Merge no fast forward ``tutorial03`` into ``master`` and push to ``origin/master``.

#. Tutorial 04 at https://docs.djangoproject.com/en/1.5/intro/tutorial04/.

    - Create a branch named ``tutorial04``, branch off from ``origin/master``.

    - Checkout the ``tutorial04`` branch.

    - Work on the ``Write a simple form`` section and commit.

    - Work on the ``Use generic views: Less code is better`` section and commit.

    - Work on the ``Amend URLconf`` section and commit.

    - Work on the ``Amend views`` section and commit.

    - Push ``tutorial04`` to ``origin/tutorial04`` and see it on github.

    - Merge no fast forward ``tutorial04`` into ``master`` and push to ``origin/master``.

#. Tutorial 05 at https://docs.djangoproject.com/en/1.5/intro/tutorial05/

    - Create a branch named ``tutorial05``, branch off from ``origin/master``.

    - Checkout the ``tutorial05`` branch.

    - Work on the ``Create a test to expose the bug`` section and commit.

    - Work on the ``Fixing the bug`` section and commit.

    - Work on the ``More comprehensive tests`` section and commit.

    - Work on the ``Improving our view`` section and commit.

    - Work on the ``Testing our new view`` section and commit.

    - Work on the ``Testing the DetailView`` section and commit.

    - Push ``tutorial05`` to ``origin/tutorial05`` and see it on github.

    - Merge no fast forward ``tutorial05`` into ``master`` and push to ``origin/master``.

#. Tutorial 06 at https://docs.djangoproject.com/en/1.5/intro/tutorial06/.

    - Create a branch named ``tutorial06``, branch off from ``origin/master``.

    - Checkout the ``tutorial06`` branch.

    - Work on the ``Customize your app’s look and feel`` section and commit.

    - Work on the ``Adding a background-image`` section and commit.

    - Push ``tutorial06`` to ``origin/tutorial06`` and see it on github.

    - Merge no fast forward ``tutorial06`` into ``master`` and push to ``origin/master``.

Congratulations, now you could work with git with basic commands. You will know more about git from time to
time when working at Teracy.
