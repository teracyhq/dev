Release Process
===============

This is the general guide for releasing software packages at Teracy.

Start
-----

- Follow workflow, a release branch should be branched off from origin branch that is ready to be
  released (for example: ``releases/0.1.0`` branch is branched off from ``develop`` branch).

- Set the next iteration version for ``develop`` branch. This will make sure there is no snapshot
version conflict between ``releases`` branch and ``develop`` branch. Moreover, ``develop`` branch
will not be blocked.

- Create an issue for DevOps team to create ci job if required.

- Create an issue for Blog team to preparing release announcement post.

Releasing
---------

- Follow specific release process docs on each project, this should be done on your forked
repository, then make pull requests when the release is ready.

- Remember that release branch should not introduce big changes.

- After each staging releases, create an issue for release test campaign to make sure the release
is stable enough and have a good quality.

End
---

- Tag the release: ``$ git tag -a v<version>`` with the message: ``v<version> Release``. For example,
  ``$ git tag -a v0.1.0`` with the message ``v0.1.0 Release``. This message pattern could be later
  used for auto deployment, so make sure the message has the correct pattern.

- Merge the tag release into ``master`` branch, then the origin branch. This is specified on the
  workflow.

- Delete release branch and we're done.

.. note::

    Automation is one of our development philosophy, and we're working on it so that releasing
    should be automated and really easy to do.

    See releated issue: https://issues.teracy.org/browse/DEVOPS-21
