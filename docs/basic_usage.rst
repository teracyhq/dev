Basic Usage
===========

Vagrant
-------

1. ``vagrant up``

   Use this command to create and provision a new VM, or start up an existing VM.

2. ``vagrant reload``

   Use this command to restart the VM.

3. ``vagrant reload --provision``

   Use this command to restart and then provision the VM. This is useful when we update ``teracy-dev``.

4. ``vagrant halt``

   Use this command to shut down the VM.

5. ``vagrant destroy``

   Use this command to destroy the VM to create a brand new clean VM.

6. ``vagrant global-status``

   Use this command to check the state of all active Vagrant environments on the system. You should
   halt or destroy the running Vagrant enviromnents that are not being worked on.

For more, please check out: https://www.vagrantup.com/docs/getting-started/


Extension
---------


Supported Config
----------------


Config Overriding
-----------------


Upgrading
---------

To upgrade teracy-dev, just checkout the desired git tag and you're set:

.. code-block:: bash

   $ cd ~/teracy-dev
   $ git fetch origin && git checkout v0.6.0

``$ vagrant reload --provision`` could be used for improvements and bug fixes change when upgrading.

``$ vagrant destroy && vagrant up`` could used for next major version change when upgrading.


References
----------

- https://www.vagrantup.com/docs/

