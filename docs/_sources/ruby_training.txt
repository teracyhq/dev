Ruby Training
=============

By default, ``teracy-dev`` will not install Ruby when ``$ vagrant up`` to avoid too much provision
time.

Installation
------------

#. Open the ``Vagrantfile`` file and find:
    ::

        "ruby" => {
            "enabled" => false # ruby platform development, disabled by default
        },
#. Enable ``ruby`` with ``"ruby"`` => ``"enabled" => true``.

#. Disable ``python`` with ``"python" => "enabled" => false`` to save provision time if you do not
   want to work with it. (You can ignore this step.)

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
