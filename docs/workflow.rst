Workflow
========

At Teracy, we care about the workflow that makes it as much consistent and fun as possible, take less 
time with higher quality of work.

We adopted `A successful Git branching model <http://nvie.com/posts/a-successful-git-branching-model/>`_
for our workflow with some specific rules. What's the fun with a game without rules :-D?

Quality checklist
-----------------

Quality of work must be strictly defined with rules and measurements, especially with software quality.

Any work is accepted as good enough MUST meet the following requirements of ``quality checklist``:

    - no tab character
    - length of the text/code line within 100 characters.
    - follow conventions and stardards
    - any tests must be done and must be passed
    - any documentation must be updated
    - the implementation must be good enough from the view of collaborators

We use many automatic tools to detect and reports the quality. Trust me, your work will be better and 
better over time.

Git commit messages
-------------------

Git commit message must convey the actual change/ work of that commit. Usually, the commit message should
follow the convention pattern:
::
    [issue_title] [#issueNumber]

    [add more description of work here]


For example:
::
    Auto deployment with Fabric [#1]

    Fabric deployment should be very easy to deploy on both local and remote machine.
    Blah blah blah.....

Git branching off
-----------------

Usually, a new branch should be branched off from *upstream/develop*. However, there are cases that it does
not apply:

- Your work depends on a branch other than *upstream/develop*, feel free to branch off from that branch. However,
keep in mind that you need to rebase on that dependent branch. After that branch is merged ino *upstream/develop*,
you need to rebase on *upstream/develop* to continue working.

This is the demostration example: *phuonglm* is working on feature_1_fabric_deployment_virtual_machine, and you're
going to work on feature_2_fabric_deployment_remote_machine, it depends on phuonglm's feature_1.
::
    $ git remote add phuonglm https://github.com/phuonglm/teracy
    $ git fetch phuonglm
    $ git checkout phuonglm/feature_1_fabric_deployment_virtual_machine -b feature_2_fabric_deployment_remote_machine
    $ git push origin feature_2_fabric_deployment_remote_machine

Git is a distributed version control system, so collaboration should not be so hard.


Let's take a ride on actual workflow.


First, init working repositories
--------------------------------

To start working on a repository project, ``fork`` it first to your git accounts.
 
Your working reposities MUST cloned from your git accounts' and put under ``workspace/personal``
directory.

For example, you're going to work on https://github.com/teracy-official/teracy project, so the steps 
to follow:

1. ``Fork`` the official repository to your github account. Mine should be https://github.com/hoatle/teracy

2. ``Clone`` it to your ``personal`` workspace.
::
    $ ws
    $ cd personal
    $ git clone https://github.com/hoatle/teracy

3. Add ``upstream`` repository (the official repository).
::
    $ git remote add upstream https://github.com/teracy-official/teracy


Work on features/ enhancements/ improvements
--------------------------------------------

- To start a new feature, you MUST branch off from the latest ``upstream/develop`` branch with a name 
of the pattern: ``feature_[issueNumber]_[concise_title]``. The title must be concise as much as possible, 
then ``push`` that branch to your repository.

- To start a new enhancement, start a new branch with a name of the pattern: 
``enhance_[#issueNumber]_[concise_title]``.

- To start a new improvement, start a new branch with a name of the pattern: 
``improve_[#issueNumber]_[concise_title]``.

For example, you're going to work on the issue #1 with title: *auto deployment with fabric* of type
 *feature*.
::
    $ ws
    $ cd personal/teracy
    $ git fetch upstream
    $ git checkout upstream/develop -b feature_1_auto_fabric_deployment
    $ git push origin feature_1_auto_fabric_deployment

- Now you're on ``feature_1_auto_fabric_deployment`` branch, just ``focus`` working on it, ``commit``
and ``push`` as often as possible. Somtimes you need to get updates from ``upstream/develop``, so you 
need to rebase on it.
::
    $ git fetch upstream
    $ git rebase upstream/develop

Resolve any conflicts and continue with ``focus``, ``commit`` and ``push`` as often as possible.

- When the feature is ready to ship, rebase on ``upstream/develop`` again and make a ``pull`` request to
official repository. You will get tons of comments, suggestions and believe me, you will continue to work 
on it to make it good enough to be merged into ``upstream/develop`` branch.

Note: After a ``pull`` request, you will continue to work on your feature branch as normal, just ``push`` 
it and the pull request will be updated with your new commits. Ping other Teracier to help reviewing, 
comments, suggestions, etc.

After reviewing, your work must meet the **quality checklist** mentioned above to be merged into official 
repository.

After all these long strict requirements that you meet, your work will be more welcomed accepted. 
Congratulations, let's get some beer now :-).


Work on bugs
------------

Before doing anything, try to **reproduce** the bug. If the bug is hard to reproduce, try to get some 
blind clues. If you could not see how to *reproduce* the bug or any clue about it, report it to your 
supervior collaborators to get suggestions and directions.

If you could **reproduce** the bug, start a branch off the *buggy* branch with a name of the pattern: 
`bug_[issueNumber]_[concise_title]`. Try to **add tests** to reproduce the bug and pass it.

For example, you're going to work on a bug issue #2 with the title: "fabric does not work on Mac OSX" 
with expected fix for *upstream/develop* branch.
::
    $ ws
    $ cd personal/teracy
    $ git fetch upstream
    $ git checkout upstream/develop -b bug_2_fabric_not_work_mac_osx
    $ git push origin bug_2_fabric_not_work_mac_osx

``focus``, ``commit`` and ``push`` as often as possible. After the work is done, make a pull request. 
Very easy workflow to follow :-).

Work on **critial** bugs
------------------------

These kind of bugs need hot-fix as it has *very high priority*.

Branch off a branch from the branch that needs hot-fix with a name with the pattern: 
``hot-fix_[issueNumber]_[concise_title]``

For example, you're going to work on a critical bug issue #3 with the title: "fabric causes the remote 
server crashed!!!" with expected fix for *upstream/master* branch:
::
    $ ws
    $ cd personal/teracy
    $ git fetch upstream
    $ git checkout upstream/master -b hot-fix_3_fabric_crashes_remote_server
    $ git push origin hot-fix_3_fabric_crashes_remote_server

Fix it as fast as possible with *really good tests*, you must make sure there should not have any 
*regression*, then make a pull request to *upstream/master* branch.


Branch merging and releasing
----------------------------

With branch merging and releasing workflow, *senior* collaborators must follow the git branching model 
as mentioned by the article above.

As the merging, pushing must be done on official teracy's projects, so you need to clone projects into 
``workspace/teracy`` directory.

For example, you need to merge the work of *feature_1_auto_fabric_deployment* branch from 
https://github.com/hoatle/teracy
 ::
    $ ws
    $ cd teracy
    $ git clone https://github.com/teracy-official/teracy
    $ cd teracy
    $ git fetch origin
    $ git checkout origin/develop
    $ git remote add hoatle https://github.com/hoatle/teracy
    $ git fetch hoatle
    $ git git merge --no-ff hoatle/feature_1_auto_fabric_deployment
    $ git push origin develop
