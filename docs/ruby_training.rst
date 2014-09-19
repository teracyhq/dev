Ruby Training
=============

By default, ``teracy-dev`` will not install Ruby when ``$ vagrant up`` to avoid too much provision
time.

Installation
------------

#. Enable ``ruby`` by creating (if not exists) or opening the ``vagrant_config_override.josn`` file
   and adding or apppending the content below:
   ::

    "chef_json":{
        "teracy-dev":{
          "ruby":{
            "enabled":true
          }
        }
    }


   .. note ::
    You can see more default configuration at ``vagrant_config.json``.


#. ``$ vagrant reload --provision`` if your VM is already running, or ``$ vagrant up`` if it is not
   running yet.

#. `$ vagrant ssh` and verify if ``ruby`` works:
    ::

        $ vagrant ssh
        $ ruby --version

    And you should see something like this:
    ::

        ruby 1.9.3p194 (2012-04-20 revision 35410) [i686-linux]

Congratulations, you can do all Ruby related stuffs now!
