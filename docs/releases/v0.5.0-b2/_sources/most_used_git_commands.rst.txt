Most Used Git Commands
======================

New git users usually get confused with new concepts and workflow. To make it easy, this
documentation will list common scenarios and how to use what git commands. You will get more
experience with git over time. This is just the easy starting point to get work with git
and Teracy's projects.

You should install Teracy's development environment to practise those commands mentioned below
more easily.

Fork
----

This is not really git concept, it was introduced by github. Basically, you can copy a repository
into your git account (github, bitbucket) so that you could have full permission on it. The
repository you copied from is called ``upstream`` (official repository) by convention. The forking
action is done on the web UI. You do not need to use  the git command for this kind of concept.

Teraciers must fork the official Teracy's projects into their accounts to work.

Clone
-----

Cloning means that you copy a remote repository into the local hard drive and track it. You usually
clone your forked repository into your local hard drive to work on it.

For example, I fork the official repository at https://github.com/teracyhq/teracy-django-boilerplate.
I will have the same repository with full permission at https://github.com/hoatle/teracy-django-boilerplate
with the ``git@github.com:hoatle/teracy-django-boilerplate.git`` git address. To clone it, I use the following
commands:
::

    $ ws
    $ cd personal
    $ git clone git@github.com:hoatle/teracy-django-boilerplate.git
    $ git remote add upstream https://github.com/teracyhq/teracy-django-boilerplate.git
    $ git fetch upstream

By convention, your full permission repository has ``origin`` remote name, ``upstream`` remote name
is used to track updated from official repository.

Remote
------

There are local and remote repositories. Local repository is the repository on your hard drive.
Remote repository is the repository stored somewhere else by a git server. You make changes on
your local repository and push these changes to remote repositories.

By convention, there are two most used remote repositories:

- ``origin``: is the repository you clone into the local repository.

- ``upstream``: is the official repository that you need to keep track of it.

With DVCS (Distributed version control system) like git, you are encouraged to collaborate with
other collaborators' remote repositories.

For example, I am working on the issue #3 with the title: "django prod deployment on prod virtual
machine" (feature) which depends on an issue that phuonglm is working on: the issue #2 with
the title: "add prod virtual machine with basic packages" (feature). So I need to add phuonglm's
repository (for example, https://github.com/phuonglm/teracy-django-boilerplate.git):
::

    $ git remote add phuonglm https://github.com/phuonglm/teracy-django-boilerplate.git
    $ git fetch phuonglm

#. remote add

    To add a remote repository and to keep
    track of it.
    ::

        $ git remote add <remote_name> <remote_git_url>

#. remote list

    To list all the remote repositories you tracked on the local repository:
    ::

        $ git remote -v

#. remote update

    To change/ update a remote repository URL:
    ::


    $ git remote set-url <remote_name> <new_url> <old_url>

#. remote delete

    Don't want to keep track of a remote repository, then remove (``rm``) it:

    ::

        $ git rm <remote_name>


Branch
------

**1. Branching off**

When there is an issue that you are going to work, the first thing you need to do is to create a new
working branch to make any changes on it.

For example, I am going to work on the issue #1 with the title: "Cleaning up the project" of the
``enhancement`` type:
::

    $ ws
    $ cd personal/teracy
    $ git fetch upstream
    $ git checkout upstream/develop -b enhance_1_project_clean_up
    $ git push origin enhance_1_project_clean_up

What do the above commands do? First, we need to ``cd`` to the working repository. Then
get the latest updates from ``upstream`` repository (official repository). Then branch off (copy)
``upstream/develop`` branch content into local branch with name *enhance_1_project_clean_up*. Then
we push this branch into the ``origin`` repository (full permission repository).

**2. Listing branches**

To see the list of branches on your local repository::
::

    $ git branch

You could see something similar like this:
::

  * docs_10_useful_most_used_git_commands
    docs_5_workflow
    enhance_4_simpler_entry_access
    feature_1_basic_deployment_virtual_machine_deps_4
    feature_8_ssh_keys_configuration_virtual_machine
    master
    origin/enhance_4_simpler_entry_access

The asterisk symbol (*) shows which branch you are currently working on.

**3. Switching branches**

To switch to another branch:
::

    $ git checkout branch_name

Fetch
-----

Fetching is usually used to get new updated from a remote repository and you could ``rebase`` or
``merge`` remote branch's updates into your current working branch on the local repository.
::

    $ git fetch upstream
    $ git merge upstream/develop

Status
------

One of the most used command to see which files/folders are changed on the currently working branch and get
suggestions command to add/ remove/ discard these changes.
::

    $ git status


Diff
----

- To see the differences before and after your changes:
    ::

        $ git diff

- If your changed files/folders are already added to the committed list, it means you have used the ``git add`` command, use the command below:
    ::

        $ git diff --cached

.. note::
    You should enable the color mode of git, it is easier to see the changes with colors.
    ::

        $ git config --global color.ui true


Commit
------

When making changes to the local repository, these changes must be tracked and committed. To see the
changes, use ``$ git status``. To commit the changes, use the following commands:
::

    $ git add .
    $ git commit -a

The ``git add .`` or ``git add -A`` command allows you to add all changed files/folder to the
committed list. If you just want to commit some of these files/folders, you should use the command
below instead:
::

    $ git add [path_to_files]
    $ git commit -a

And the terminal will open a default editor (usually ``vim`` on linux, mac), add your commit
message, write and quite (vim: press [i] to enter edit mode, then [ESC] to go into view mode,
then ``:wq`` to write changes and quit).

You can add your commit message directly to your commit without the ``vim`` editor by using the
command below instead of ``git commit -a``:
::

    $git commit -m "<issue_key>|git commit message"

There are cases when you missed something and you want to add more changes into the latest commit:
::

    $ git add .
    $ git commit --amend

``git commit --amend`` will allow you to add more changes into the latest commit and edit the commit
message. Even if you do not want to add any changes but to edit the latest commit message,
you should use this command.

Log
---

**1. List**

    - To see a full list of commits, use:
        ::

            $ git log

    - To see the list of commit messages only, use:
        ::

            $ git log --online

    - Press [Enter] to scroll the list till the end or press ``q`` to quit.

**2. Search**

    To search commit logs matching a specific pattern, use:
    ::

        $ git log -g --grep=<pattern>


Push
----

After some commits and you would like to push them into the ``origin`` repository, do as follows:
::

    $ git push origin enhance_1_project_clean_up

Sometimes when there is diversity which means there are difference between git commit list on the local and remote branch,
git does not allow you to push. In that case, you need to ``force push`` (means that you want
to have you local changes put into the ``origin`` repository, keep only commit history of local
repository.
::

    $ git push origin enhance_1_project_clean_up -f

If you want to keep the ``origin`` and make the local changes to resolve different commit
list, you can use ``git rebase`` to make the history be fast-forwarded.

Fast-forward means that your local repository is in sync with remote repository with some
additional commits. When you push, the additional commits will be appended into remote history
repository.

WARNING: `force push` can make you lost some commits if you are not careful enough. This
is true when you merge work from other branches into your local branch. In such case, you could
use ``git reflog``, find the hash commit and ``git reset --hard <hash>`` to get back the changes.

.. note::
     NEVER EVER force push the official repositories.


Rebase
------

``rebase`` means that you want to keep the remote's commit list as base, any changes of local
branch should be reorganized and appending to the remote repository. You usually ``rebase`` to get
the latest changes from the ``upstream`` repository.
::

    $ git fetch upstream
    $ git rebase upstream/develop

If there is any conflict, resolve it, then ``$ git add .`` and ``$ git commit -a``. Do it until git
says that you are done; Or you could ``abort`` the ``rebase`` process by ``$ git rebase --abort``.
Everything will come back before the ``rebase`` process after ``abort``.


Merge
-----

``merge`` is used to join 2 or more commit histories together (from different branches).


Pull request
------------

This concept is not introduced by ``git`` but ``github``, which means that you do not have any git
command here. Pull request is done on the web UI of github (bitbucket) to notify the ``upstream``
that your work is great, finished and you want your work to be merged into the ``upstream`` repository.


Reset
-----

``Reset`` means that you could set the working branch to a specific commit history and see all the
changes.
::

    $ git reset HEAD~<index>

or:
::

    $ git reset <commit_hash_id>

This is useful to view all the changes from some commits of your collaborators for an issue.

- reset hard

    - To discardss all the current changes on the working branch:
        ::

            $ git reset --hard

    -  To set the
        current working branch to a specific commit and discard all the changes, use one of two following commands:
        ::

            $ git reset --hard HEAD~<index>

            $ git reset --hard <commit_hash_id>

    - To reset the working branch to a remote branch:
        ::

            $ git reset --hard <remote_repo>/<branch_name>

Stash
-----

**1. stash it**

    ``stash`` is a stack and is usually used when you want to store temporarily changes from a working
    branch instead of committing these changes to switch to another branch. ``stash`` is a stack like.
    Usually, you need to store all the changes:
    ::

        $ git add .
        $ git stash

**2. stash list**

    To see all the stashed list:
    ::

        $ git stash list

**3. show it**

    To show the changes from a specific stash:
    ::

        $ git stash show stash@{<index>}

**4. apply it**

    When switching back the repository having stash, you could get the changes from ``stash``.

    - To get the latest stashed content and apply changes to the current working
      branch:
      ::

        $ git stash apply

    -  To apply changes from a specific stash into the current
        working branch:
        ::

            $ git stash apply stash@{<index>}

**5. drop it**

    To drop a specific stash:
    ::

        $ git stash drop stash@{<index>}

Squash
------

Warning: Squash is used to rewrite your git history, so use on your own full permission repository
ONLY.

``squash`` means you choose one or some commits and ``amend`` to its previous commit to be a
single commit.

When working, you "commit early, commit often", and you get a list of commits that is hard for your
collaborators to review, and each commit is not atomic itself. Each commit should be an atomic
problem solving step, that is the reason why you need ``squash``:
::

    $ git rebase -i HEAD~<index>

Use ``s`` instead of ``pick`` for the commits you want
to squash.

Learn More
----------

You can learn more git commands by using one of the following commands to open the Help page, or ask us,
Teraciers, for work and practice.
::

    $ git --help

    $ git <command> --help

    $ man git-<command>


