Git Training
============

Git is a distributed version control systems (DVCS) which was used to manange all Teracy's
development resources. You need to learn to use Git to work with Teracy's projects.

Learn
-----

There are many free available resources for learning git. These are some of recommended resources
that you need to learn it.

- http://git-scm.com/book

- http://sixrevisions.com/resources/git-tutorials-beginners/

- http://documentup.com/skwp/git-workflows-book

Practice
--------

After learning, now it's the time for practice.

- Prerequisites

    + github account with configured ssh keys.

    + ``teracy-dev`` is running with working ssh (``$ ssh -T git@github.com`` should be ok).

- Git basics

    + You're going to create ``pro-git-practice`` repository on github (via github's web UI).

    + The repository on your VM should be at: ``workspace/personal/pro-git-practice``

    + Read the chapter 2 and practice with your ``pro-git-practice`` repository on your VM at
      http://git-scm.com/book/en/Git-Basics

    + Remember to push the changes to github so we could see your work and practice.


- Work again on teracy-tutorial

Note: You're encouraged to practice with as many git commands as possible, but have to follow
strictly all the instructions below, the results will be displayed on github to check.

As you remember, you practiced to adapt Django's tutorial into Teracy's Django boilerplate project.

Now you will work on it again with git and push it to github.

First, create a repository name ``teracy-tutorial`` on github, and setup the local repo
``workspace/personal/teracy-tutorial`` on your VM.

Push the first commit there on github (Initial setup).

#. Setup project layout

    - Add remote repository https://github.com/teracy-official/django-boilerplate.git into
      your repository with named ``djbp``.

    - Fetch and merge ``djbp/master`` branch.

    - Push the merge to your github's repository at ``origin/master``.

#. Tutorial 01 at https://docs.djangoproject.com/en/1.5/intro/tutorial01/

    - Create a branch named ``tutorial01``, branch off from ``origin/master``.

    - Checkout ``tutorial01`` branch

    - Skip the section of ``startproject`` as we already started a project with ``teracy``

    - Work on ``Creating models`` section and commit the changes with message ``Creating models``.

    - Work on ``Activating models`` section and commit the changes with message: ``Activating
      models``.

    - Work on ``Playing with the API`` section and commit the changes with message: ``Playing with
      the API``.

    - And push the ``tutorial01`` branch to ``origin/tutorial01`` branch. You should open the
      repository on github and see the branch there.

    - Merge (no fast forward) (hint: $ git merge --no-ff) the ``tutorial01`` branch into ``master``
      branch, then push to ``origin/master`` branch.

#. Tutorial 02 at https://docs.djangoproject.com/en/1.5/intro/tutorial02/

    - Create a branch named ``tutorial02``, branch off from ``origin/master``

    - Checkout ``tutorial02`` branch

    - Skip ``Activate the admin site`` section as admin is activated by teracy's project layout on
      ``settings/dev.py``.

    - Work on ``Make the poll app modifiable in the admin`` section and commit the changes.

    - Work on ``Customize the admin form`` section and commit the changes.

    - Work on ``Adding related objects`` section and commit the changes.

    - Work on ``Customize the admin change list`` and commit the changes.

    - Work on ``Customize the admin look and feel`` and commit the changes.

    Note: TEMPLATE_DIRS is already configured by ``teracy-django-boilerplate``, you could just use
    it.

    - Work on ``Customize the admin index page`` and commit the changes.

    - Push ``tutorial02`` to ``origin/tutorial02`` and see it on github.

    - Merge no fast forward ``tutorial02`` into ``master`` and push to ``origin/master``.

#. Tutorial 03 at https://docs.djangoproject.com/en/1.5/intro/tutorial03/

    - Create a branch named ``tutorial03``, branch off from ``origin/master``.

    - Checkout ``tutorial03`` branch.

    - Work on ``Write your first view`` and commit.

    - Work on ``Writing more views`` and commit.

    - Work on ``Write views that actually do something`` and commit.

    - Work on ``A shortcut: render()`` and commit.

    - Work on ``Raising a 404 error`` and commit.

    - Work on ``A shortcut: get_object_or_404()`` and commit.

    - Work on ``Write a 404 (page not found) view`` and commit.

    - Work on ``Write a 500 (server error) view`` -> commit.

    - Work on ``Use the template system`` -> commit.

    - Work on ``Removing hardcoded URLs in templates`` -> commit.

    - Work on ``Namespacing URL names`` -> commit.

    - Push ``tutorial03`` to ``origin/tutorial03`` and see it on github.

    - Merge no fast forward ``tutorial03`` into ``master`` and push to ``origin/master``.

#. Tutorial 04 at https://docs.djangoproject.com/en/1.5/intro/tutorial04/

    - Create a branch named ``tutorial04``, branch off from ``origin/master``.

    - Checkout ``tutorial04`` branch.

    - Work on ``Write a simple form`` -> commit.

    - Work on ``Use generic views: Less code is better`` -> commit.

    - Work on ``Amend URLconf`` -> commit.

    - Work on ``Amend views`` -> commit.

    - Push ``tutorial04`` to ``origin/tutorial04`` and see it on github.

    - Merge no fast forward ``tutorial04`` into ``master`` and push to ``origin/master``.

#. Tutorial 05 at https://docs.djangoproject.com/en/1.5/intro/tutorial05/

    - Create a branch named ``tutorial05``, branch off from ``origin/master``.

    - Checkout ``tutorial05`` branch.

    - Work on ``Create a test to expose the bug`` -> commit.

    - Work on ``Fixing the bug`` -> commit.

    - Work on ``More comprehensive tests`` -> commit.

    - Work on ``Improving our view`` -> commit.

    - Work on ``Testing our new view`` -> commit.

    - Work on ``Testing the DetailView`` -> commit.

    - Push ``tutorial05`` to ``origin/tutorial05`` and see it on github.

    - Merge no fast forward ``tutorial05`` into ``master`` and push to ``origin/master``.

#. Tutorial 06 at https://docs.djangoproject.com/en/1.5/intro/tutorial06/

    - Create a branch named ``tutorial06``, branch off from ``origin/master``.

    - Checkout ``tutorial06`` branch.

    - Work on ``Customize your app’s look and feel`` -> commit.

    - Work on ``Adding a background-image`` -> commit.

    - Push ``tutorial06`` to ``origin/tutorial06`` and see it on github.

    - Merge no fast forward ``tutorial06`` into ``master`` and push to ``origin/master``.

Congratulations, now you could work with git with basic commands. You will know more from time to
time when working at Teracy.
