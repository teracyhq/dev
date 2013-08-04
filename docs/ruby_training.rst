Ruby Training
=============

By default, ``teracy-dev`` will not install Ruby when ``$ vagrant up`` to avoid too much provision
time.

Installation
------------

To install Ruby on your VM, follow these steps:
::
    $ vagrant ssh
    $ cd /tmp && wget https://raw.github.com/teracy-official/teracy-dev/master/scripts/rbenv.sh && chmod +x rbenv.sh && . ./rbenv.sh && cd ~

The downloaded script will:

- install `rbenv`_

- install Ruby 1.9.3-p194

.. _rbenv: https://github.com/sstephenson/rbenv

After the installation process, you should verify it works by:
::
    $ ruby --version


And you should see something like this:
::
    ruby 1.9.3p194 (2012-04-20 revision 35410) [i686-linux]

Congratulations, you can do all Ruby related stuffs now!
