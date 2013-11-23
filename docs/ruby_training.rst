Ruby Training
=============

By default, ``teracy-dev`` will not install Ruby when ``$ vagrant up`` to avoid too much provision
time.

Installation
------------

Open ``Vagrantfile`` file and find:
::

    "ruby" => {
      "enabled" => false # ruby platform development, disabled by default
    },

Enable ``ruby`` with: ``"enabled" => true``.

If you do not want to work with ``python``, disable it with ``"python" => "enabled" => false`` to
save provision time.

Then ``$ vagrant provision`` if your VM is already running, or ``$ vagrant up`` if it is not running
yet.

After the provision process, `$ vagrant ssh` and you should verify if it works by:
::

    $ ruby --version


And you should see something like this:
::

    ruby 1.9.3p194 (2012-04-20 revision 35410) [i686-linux]

Congratulations, you can do all Ruby related stuffs now!
