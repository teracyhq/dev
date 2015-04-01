Built-in IDE (codebox)
======================

Sometimes we want to work remote on the vagrant machine from a different machine or to use
a text editor on browsers, such the built-in editor is very helpful.

That's why we support a built-in editor for vagrant box, however, it's disabled by default. We'll
need to enable it to use.

The built-in editor we support is Codebox_ - it's more than an editor, it's an IDE.

..  image:: _static/built-in-ide/teracy_codebox_screenshot.png
    :align: center


Default Configuration
---------------------

This is the default configuration of the IDE:

..  code-block:: json

    {
      "codebox": {
          "enabled":false,
          "port":30000,
          "sync_dir":"/home/vagrant/workspace"
      }
    }


How to Enable
-------------

To enable the built-in IDE, add the following configuration to *vagrant_config_override.json* file
as follows:

..  code-block:: json

    {
      "chef_json": {
        "teracy-dev": {
          "codebox": {
            "enabled":true
          }
        }
      }
    }

After that, ``$ vagrant provision`` and we're done.


How to Use
----------

Open http://localhost:30000 and check out: http://help.codebox.io/


How to Customize
----------------

``port:3000`` and ``sync_dir:"/home/vagrant/workspace"`` are configured by default.

We could customize them by changing its configuration, like:

..  code-block:: json

    {
      "chef_json": {
        "teracy-dev": {
          "codebox": {
            "enabled":true,
            "port":31000,
            "sync_dir":"/home/vagrant/workspace/personal"
          }
        }
      }
    }

After that, ``$ vagrant provision`` and we're done.

..  note::
    Make sure that the new port has the corresponding forwared port to the host machine.


References
----------
- https://www.codebox.io/
- https://github.com/CodeboxIDE/codebox

..  _Codebox:  https://github.com/CodeboxIDE/codebox





