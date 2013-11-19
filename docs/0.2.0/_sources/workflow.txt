Workflow
========

At Teracy, we care about the workflow that makes it as much consistent and fun as possible, take
less time with higher quality of work.

We adopted `A successful Git branching model`_ for our development workflow with some specific
rules. What's the fun with a game without rules :-D?

Quality checklist
-----------------

Quality of work must be strictly defined with rules and measurements, especially with software
quality.

Any work is accepted as good enough MUST meet the following (including but not limited) requirements
of ``quality checklist``:

    - no tab character
    - length of the text/code line within 100 characters
    - follow conventions and standards
    - any tests must be done and must be passed
    - any documentation must be updated
    - the implementation must be good enough from the view of collaborators

We use many automatic tools to detect and reports the quality. Trust me, your work will be better
and better over time.

Git commit messages
-------------------

Git commit message must convey the actual change/ work of that commit. Usually, the commit message
should follow the convention pattern:
::
    <issue_key> | <issue_title>: <changes description>

    <Multi-line description for detail changes, notices, solutions, etc.>


For example:
::
    DEV-1 | Auto deployment with Fabric

    Fabric deployment should be very easy to deploy on both local and remote machine.
    This is the work on local part.

Git branching off
-----------------

Usually, a new branch should be branched off from target to-be-merged remote branch.
It's usually *upstream/develop*. However, there are cases that it does not apply:

Keep in mind that you need to rebase often the work of that dependent branch to
your working branch.

This is the demonstration example: *phuonglm* is working on
features/1_fabric_deployment_virtual_machine, and you're going to work on
features/2_fabric_deployment_remote_machine, it depends on phuonglm's features/1. On this case, you
MUST indicate the branch name with ``deps_<issueNumber>``.
::
    $ git remote add phuonglm https://github.com/phuonglm/teracy-django-boilerplate.git
    $ git fetch phuonglm
    $ git checkout phuonglm/features/1_fabric_deployment_virtual_machine -b features/2_fabric_deployment_remote_machine_deps_1
    $ git push origin features/2_fabric_deployment_remote_machine_deps_1

After sometime of work, phuonglm's feature_1_fabric_deployment_virtual_machine has some updates.
::
    $ git fetch phuonglm
    $ git rebase phuonglm/features/1_fabric_deployment_virtual_machine
    $ git push origin features/2_fabric_deployment_remote_machine_deps_1 -f

When phuonglm's features/1 is merged into *upstream/develop*, you need to rebase on it to get
these new updates:
::
    $ git fetch upstream
    $ git rebase upstream/develop
    $ git push origin features/2_fabric_deployment_remote_machine_deps_1 -f


Git is a distributed version control system, so collaboration like this should be encouraged.

Git force push
--------------

Should not ``$ git push origin branch_name -f`` if your branch has another branch depending on.

NEVER ever force push the *official repository*.


Git branch cleaning up
----------------------

After your working branch is merged back into official repository, make sure to delete these
working branches.

Delete remote branch:
::
    $ git push origin :branch_name

Delete local branch:
::
    $ git checkout master
    $ git branch -d branch_name


Let's take a ride on actual workflow.


First, initialize working repositories
--------------------------------------

To start working on a repository project, ``fork`` it first to your git account.

Your working repositories MUST cloned from your git account and put under ``workspace/personal``
directory.

For example, you're going to work on https://github.com/teracy-official/django-boilerplate
project, so follow the steps to follow:

1. ``Fork`` the official repository to your github account.
Mine should be https://github.com/hoatle/django-boilerplate

2. ``Clone`` it to your ``personal`` workspace.
::
    $ ws
    $ cd personal
    $ git clone git@github.com/hoatle/django-boilerplate.git

3. Add ``upstream`` repository (the official repository).
::
    $ git remote add upstream https://github.com/teracy-official/django-boilerplate.git


Work on features/ enhancements/ improvements
--------------------------------------------

- To start a new feature, you MUST branch off from the latest ``upstream/develop`` branch with a
name of the pattern: ``features/<issue_key>_<concise_title>``. The title must be concise as much
as possible, then ``push`` that branch to your repository.

- To start a new improvement, start a new branch with a name of the pattern:
``improvements/<issue_key>_<concise_title>``.

- To start a new bug, start a new branch with a name of the pattern:
``bugs/<issue_key>_<concise_title>``.

- And to start a new task: ``tasks/<issue_key>_<consise_title>``.

For example, you're going to work on the issue #1 with title: "auto deployment with fabric" of type
"feature":
::
    $ ws
    $ cd personal/django-boilerplate
    $ git fetch upstream
    $ git checkout upstream/develop -b features/1_auto_fabric_deployment
    $ git push origin features/1_auto_fabric_deployment

- Now you're on ``features/1_auto_fabric_deployment`` branch, just ``focus`` working on it,
``commit`` and ``push`` as often as possible. Sometimes you need to get updates from
``upstream/develop``, so you need to rebase on it.
::
    $ git fetch upstream
    $ git rebase upstream/develop

Resolve any conflicts and continue with ``focus``, ``commit`` and ``push`` as often as possible.

- When the feature is ready to ship, rebase on ``upstream/develop`` again, reorganize the commits
as logical as possible and make a ``pull`` request to the official repository with target merging
branch. You will get tons of comments, suggestions and you need to continue working on it to make it
good enough to be merged into ``upstream/develop`` branch.

Before making a pull request, make sure your work must meet the **quality checklist**.

Note: After a ``pull`` request, you will continue to work on your working branch as normal, just
``push`` it and the pull request will be updated with your new commits. Ping other Teracier to
help reviewing, comments, suggestions, etc.

After all these long strict requirements that you meet, your work will be more welcomed accepted.
Congratulations, let's get some beer then :-).


Work on bugs
------------

Before doing anything, try to **reproduce** the bug. If the bug is hard to reproduce, try to get
some blind clues. If you could not see how to *reproduce* the bug or any clue about it, report it
to your supervisor collaborators to get suggestions and directions.

If you could **reproduce** the bug, start branching off from the target branch with a name of the
pattern: ``bugs/<issue_key>_<concise_title>``. MUST try to **add tests** to reproduce the bug and
pass it.

For example, you're going to work on a bug issue #2 with the title: "fabric does not work on Mac
OSX" with expected fix for *upstream/develop* branch.
::
    $ ws
    $ cd personal/teracy-django-boilerplate
    $ git fetch upstream
    $ git checkout upstream/develop -b bugs/2_fabric_not_work_mac_osx
    $ git push origin bugs/2_fabric_not_work_mac_osx

``focus``, ``commit`` and ``push`` as often as possible. After the work is done, make a pull
request.

Work on **critical** bugs
------------------------

These kind of bugs need hot-fix as it has *very high priority*.

Branch off a branch from the branch that needs hot-fix with a name of the pattern:
``hot-fixes/<issue_key>_<concise_title>``

For example, you're going to work on a critical bug issue #3 with the title: "fabric causes the
remote server crashed!!!" with expected fix for *upstream/master* branch:
::
    $ ws
    $ cd personal/teracy-django-boilerplate
    $ git fetch upstream
    $ git checkout upstream/master -b hot-fixes/3_fabric_crashes_remote_server
    $ git push origin hot-fixes/3_fabric_crashes_remote_server

Fix it as fast as possible with *really good tests*, you must make sure there should not have any
*regression*, then make a pull request to target merging branch.

Official branch's merging and releasing
---------------------------------------

With branch merging and releasing workflow, *senior* collaborators must follow the git branching
model as mentioned by the article above.

As the merging, pushing must be done on official teracy's projects, so you need to clone projects
into ``workspace/teracy`` directory.

For example, you need to merge the work of *features/1_auto_fabric_deployment* branch from
https://github.com/hoatle/django-boilerplate
::
    $ ws
    $ cd teracy
    $ git clone git@github.com/teracy-official/teracy-django-boilerplate.git
    $ cd teracy
    $ git fetch origin
    $ git checkout origin/develop
    $ git remote add hoatle https://github.com/hoatle/teracy-django-boilerplate.git
    $ git fetch hoatle
    $ git git merge --no-ff hoatle/features/1_auto_fabric_deployment
    $ git push origin develop

.. _`A successful Git branching model`: http://nvie.com/posts/a-successful-git-branching-model/