Best Practices
==============

This guide will list all the important best practices when using `teracy-dev`.


New User On-boarding Flow
-------------------------

Consistent user experience for on-boarding is really important. When using ``teracy-dev`` to set up any
projects, we should always stick to the following rules:

- Each project must have a ``README.md`` file.

- The ``<project>/README.md`` file should refer to the ``<project>/dev-setup/README.md`` file which
  must refer to the ``<organization-dev>/dev-setup/README.md`` file to set up the organization level
  development environment.

- Then users need to continue with the ``<project>/dev-setup/README.md`` file to set up the project
  level development environment.

That's all the steps that users must follow to set up any new project development environment, we
must automate as much as possible.


The rules above can be illustrated as follows:

.. image:: _static/best-practices/new_user_on-boarding_flow.png



Upgrading User Flow
-------------------

When there are any upgrading steps required, the upgrading section must be introduced:

- The ``<organization-dev>/dev-setup/README.md#upgrading`` section for the organization level dev-setup
  upgrading.

- The ``<project>/dev-setup/README.md#upgrading`` section for the project level dev-setup upgrading.

