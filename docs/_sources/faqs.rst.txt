FAQs
====
This page provides the frequently asked questions (FAQs) about ``teracy-dev``.

Why teracy-dev? Why not just Docker?
------------------------------------
Docker is great to work with, it solves a lot of problems on development, distribution, and production deployment. It works great on Linux, but it's very challenging to make it work universal and consistent on Mac and Windows. There are lots of efforts to solve this problem, from Docker themselves and from Docker community, too. However, we haven't achieved that stage yet (until ``teracy-dev``). ``teracy-dev`` is a universal Productive Development Platform With Docker on macOS, Linux and Windows.  With ``teracy-dev``, anyone from any OS platforms could collaborate and help each other with no differences in the development environment, and many other reasons why you should use ``teracy-dev`` to develop software more easily, see details at
http://blog.teracy.com/2016/12/20/teracy-dev-the-only-truly-universal-productive-development-platform-with-docker-on-macos-linux-and-windows/.

How do I know which version of ``teracy-dev`` that I'm using?
-------------------------------------------------------------
Currently, to know the version of teracy-dev which you are using, you need to follow the steps: 
First, you need to ``git branch`` to know the current branch, then ``git log`` to know the info about the latest commits. Normally, we have the commits about release the new version, for example, "Merge pull request #313 from hoatle/tasks/#312-release-v0.5.0-b3".

We'll provide a simpler way soon at https://github.com/teracyhq/dev/issues/366.


After ``vaggrant ssh``, why cannot I run the ``grunt`` or ``npm`` command in the VM?
------------------------------------------------------------------------------------

The ``grunt`` or ``npm`` command is not used in the ``teracy-dev`` latest version anymore. Instead, ``docker`` and ``docker-compose`` is installed by default and you should use these two.

What should I do after updating ``vagrant_config_override.json`` to get it applied to the VM?
---------------------------------------------------------------------------------------------
Make sure to save the ``vagrant_config_override.json`` file, and you can run ``$ vagrant provision``
, usually this should work. If not, run ``$ vagrant reload --provision``.

What should I do when ``$ vagrant up`` gets stuck at this step?
---------------------------------------------------------------
    ::

      default: /tmp/vagrant-chef/7cb2926f81b5c74a4ca3dd163f9d9ffd/roles => /Users/hoatle/teracy-dev/workspace/teracy-dev/roles
      default: /tmp/vagrant-chef/3071687433aa992e850e416aafea8f25/nodes => /Users/hoatle/teracy-dev/workspace/teracy-dev/nodes
      default: /tmp/vagrant-chef/bbfefdc57119d7552b06b24069242f8a/data_bags => /Users/hoatle/teracy-dev/workspace/teracy-dev/data_bags
      default: /tmp/vagrant-chef/9b5518c8fee080ca55f1c57179068e17/cookbooks => /Users/hoatle/teracy-dev/workspace/teracy-dev/vendor-cookbooks
      default: /tmp/vagrant-chef/87b97d785383812081b2ec7e56be857d/cookbooks => /Users/hoatle/teracy-dev/workspace/teracy-dev/main-cookbooks
      ==> default: Running provisioner: chef_solo...
      default: Installing Chef (latest)...

Then stop it, ``$ vagrant ssh`` to update this http://askubuntu.com/questions/620317/apt-get-update-stuck-connecting-to-security-ubuntu-com, then ``$ vagrant reload --provision`` again.


``/etc/hosts`` is not properly updated when I got errors, after ``$ vagrant destroy`` and ``$ vagrant up``. I end up having multiple same entries that the wrong one is on the top of the file. This leads to wrong DNS to point to the right VM's IP address. What should I do?
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Follow the steps below:

1. check VM's ip: ``$ vagrant up``
2. ``$ vagrant hostmanger`` to make sure ``/etc/hosts`` is updated.
3. ``$ ping <the_configured_domain>`` to see if it pings the right VM IP from step 1.
4. If it's not right, open ``/etc/hosts`` to check and remove wrong entries.
5. Come back to Step 3 to verify.


What should I do when the ``teracy-dev`` version is changed?
------------------------------------------------------------
You should run the command ``vagrant destroy``, then ``vagrant up``.

What should I do when changing provisioner (Chef, Bash...)?
-----------------------------------------------------------
You should run the command ``$ vagrant reload --provision``.


What should I do when meeting other errors, and the problems cannot be solved with ``vagrant reload`` or ``vagrant reload --provision``?
---------------------------------------------------------------------------------------------------------------------------------------------

You should run the command ``vagrant destroy``, then ``$ vagrant up``.

