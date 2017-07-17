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

.. _basic_usage-ip_address:

IP Address
----------

By default, the VM uses a public dynamic IP address, so we need to know its IP address to access.

When provisioning, we could see it on the console output like:

..  code-block:: bash

    ==> default: Running provisioner: shell...
        default: Running: inline script
    ==> default: mesg: 
    ==> default: ttyname failed
    ==> default: : 
    ==> default: Inappropriate ioctl for device
    ==> default: ip address: 192.168.0.116


When we want to display the IP address of the VM anytime, follow the commands below:

..  code-block:: bash

    $ cd ~/teracy-dev
    $ vagrant up

Or:

..  code-block:: bash

    $ cd ~/teracy-dev
    $ vagrant provision --provision-with ip


And it should display the IP address output of the VM.


File Sync
---------

We use ``rsync`` for syncing files between the host machine and the VM (the guest machine) under
the `~/teracy-dev/workspace` directory by default. So put your project files there, it will be 
synced back and forth with with `/home/vagrant/workspace` directory on the VM guest machine.
This is default setting and you can configure the sync directories and mechanism whatever you want.

For easier and high-performance sync, we use additional vagrant plugins:

- `vagrant-gatling-rsync <https://github.com/smerrill/vagrant-gatling-rsync/>`_

- `vagrant-rsync-back <https://github.com/smerrill/vagrant-rsync-back/>`_


1. Sync from the host machine to the guest VM

    By default, we run ``$ vagrant gatling-rsync-auto`` automatically when ``$ vagrant up`` to watch
    and sync files from the host machine to the guest VM automatically.

    We could stop and enable it anytime by running: ``$ vagrant gatling-rsync-auto``.


2. Sync from the guest VM to the host machine

    This is used only when you want the file changes on the VM to be synced back to the host machine,
    use this command:

    ..  code-block:: bash

        $ vagrant rsync-back


References
----------

- https://www.vagrantup.com/docs/

