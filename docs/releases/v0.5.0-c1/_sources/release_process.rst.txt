Release Process
===============

This is the general guide for releasing software packages at Teracy.

Starting
--------

- Follow workflow, a releasing branch should be branched off from an origin branch that is ready to be
  released.

- The releasing branch should be named ``releases/vX.X.X``.

- For example: the ``releases/v0.1.0`` branch is branched off from the ``develop`` branch.

- Set the next iteration version for the ``develop`` branch. This will make sure there is no snapshot
  version conflict between the ``releases`` branch and the ``develop`` branch. Moreover, the
  ``develop`` branch will not be blocked.

- Create an issue for DevOps team to create ci job if required.

- Create an issue for Blog team to preparing release announcement post.

Releasing
---------

- Follow specific release process doccuments on each project, this should be done on your forked
  repository, then make pull requests when the release is ready.

- Remember that release branch should not introduce big changes.

- After each staging release, create an issue for release test campaign to make sure the release
  is stable enough and have good quality.

Ending
------

- Make sure that the tag step must be ready at least **3 days** before the expected release date.
  Use **UTC** as standard reference time.

- Tag the release: ``$ git tag -a v<version>`` with the ``v<version> Release`` message. For example,
  ``$ git tag -a v0.1.0`` with the ``v0.1.0 Release`` message. This message pattern could be later
  used for auto deployment, so make sure the message has the correct pattern.

- Merge the tag release into the ``master`` branch, then the origin branch. This is specified on the
  project workflow.

- Delete the released branch and we are done.

.. note::

    Automation is one of our development philosophy, and we are working on it so that releasing
    should be automated and really easy to do.

    See the releated issue: https://issues.teracy.org/browse/DEVOPS-21
