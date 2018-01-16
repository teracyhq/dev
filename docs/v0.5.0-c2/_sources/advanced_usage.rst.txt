Advanced Usage
==============

This is for advanced usage, make sure to master the :doc:`basic_usage` guide first.

Configuration
-------------

Sometimes, we need some customized configuration other than default configuration.

So for easier upgrade and customized configuration, we use a json file named `vagrant_config_override.json`
to override the default configuration on `vagrant_config.json` file.

By using this, we can easily upgrade teracy-dev with ease, no conflicts introduced.


For example, to use more memory for the VM, looking into the `vagrant_config.json` file we could find:

..  code-block:: javascript

    "vb":{ //virtualbox settings from https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
      //"gui":true,
      //"name":"teracy-dev",
      "memory":2048,
      //"cpus":1,
      "description":"teracy-dev #{Time.now.getutc.to_i}"
    }

Now create the `vagrant_config_override.json` file with the following content:

..  code-block:: json

    {
      "vb":{
        "memory":3072
      }
    }

After that, ``$ vagrant reload``, then this overridden configuration will update the VM with *3072* MB memory instead of default *2048* MB memory.

This applied the same for other configuration that you want to override. Under the hood, we merge
the `vagrant_config_override.json` with `vagrant_config.json` to create the configuration settings.
The configuration settings are then applied to the `Vagrantfile` file.


Upgrading
---------

To upgrade teracy-dev, just pull the latest changes from the git repo and you're set:

.. code-block:: bash

   $ cd ~/teracy-dev
   $ git fetch origin && git reset --hard origin/master

``$ vagrant reload --provision`` is used for improvements and bug fixes change upgrading.

``$ vagrant destroy && vagrant up`` is used for next major version change upgrading.
