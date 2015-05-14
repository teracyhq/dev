Firefox Add-ons Development Guide
=================================

To develop add-on for Firefox, you need to install the SDK and optional ``amo-validator``. In this
guide, you're going to install both on the teracy-dev VM.

At the time of writing this guide, you're going to install the latest SDK (v1.17) and latest
``amo-validator`` (v1.6.0). It's expected that this guide should work with the latest SDK and
``amo-validator``.

At the time of writing this guide, `native JavaScript SDK <https://www.npmjs.com/package/jpm>`_ is
not ready for prime time yet. In the future, we will add the instruction here. However, as it's
a ``nodejs`` module, it's very easy to install on the teracy-dev VM as ``nodejs`` is available by
default.

First of all, make sure that the teracy-dev VM is running, if not yet, please follow the guide here
at: :doc:`getting_started`

Firefox Add-ons SDK Installation
--------------------------------

This installation guide is based on https://developer.mozilla.org/en-US/Add-ons/SDK/Tutorials/Installation

.. note::

  Within the teracy-dev VM with default configuration:

  - Python 2.7 is already available by default

  - Firefox is not available, so you cannot use the commands involving Firefox, for example:
    ``$ cfx run`` or ``$ cfx test``

To install the SDK, the following steps need accomplishing:

#.  ``$ vagrant ssh`` if you are not ``ssh-ing`` the teracy-dev VM yet.

#.  Download the SDK

    ..  code-block:: bash

        $ cd ~/workspace/readonly
        $ wget https://ftp.mozilla.org/pub/mozilla.org/labs/jetpack/jetpack-sdk-latest.tar.gz
        $ tar -xf jetpack-sdk-latest.tar.gz

    After extracting, it's expected that the SDK is available at ``~/workspace/readonly/addon-sdk-1.17``

#.  Make ``activate`` permanent

    ..  code-block:: bash

        $ sudo ln -s ~/workspace/readonly/add-on-sdk-1.17/bin/cfx /usr/local/bin/cfx

And from now on you can use ``$ cfx`` anywhere. To verify, try the command below:

..  code-block:: bash

    $ cfx --version

And you should see the following output:

..  code-block:: bash

    Add-on SDK 1.17 (12f7d53e8b5fc015a15fa4a30fa588e81e9e9b2e)

You can start building Firefox Add-ons now by following the instruction at:
https://developer.mozilla.org/en-US/Add-ons/SDK/Tutorials/Getting_started


addons.mozilla.org Validator Installation
-----------------------------------------

To publish the add-ons on AMO, it requires review process and ``amo-validator`` is provided to
help you to spot some common problems as early as possible.

``amo-validator`` is available as Python package at: https://pypi.python.org/pypi/amo-validator

To install ``amo-validator``, you need to add ``amo-validator`` and ``fastchardet`` to python global
system packages.

#.  Open ``vagrant_config_override.js`` and override the default ``python`` configuration as follows:

    ..  code-block:: json

        {
          "chef_json":{
            "python":{
              "pip":{
                "globals":[
                  {
                    "name":"Sphinx"
                  },
                  {
                    "name":"restview"
                  },
                  {
                    "name":"fastchardet",
                    "supported_python_versions":["2.7.6"]
                  },
                  {
                    "name":"amo-validator",
                    "supported_python_versions":["2.7.6"]
                  }
                ]
              }
            }
          }
        }

    ..  note::
        At the time of this writing, `fastchardet` is required by `amo-validator` but not included
        in `setup.py`, that's the reason why you need to add it in the configuration above.

#.  Provision the teracy-dev VM

    ..  code-block:: bash

        $ vagrant provision

    After that, ``addon-validator`` should be available. Try the following commands to verify:

    ..  code-block:: bash

        $ vagrant ssh
        $ addon-validator

    And you should see the following output:

    ..  code-block:: bash

        usage: addon-validator [-h]
                               [-t {theme,multi,dictionary,extension,webapp,search,any,languagepack}]
                               [-o {text,json}] [-v] [--boring] [--determined]
                               [--selfhosted]
                               [--approved_applications APPROVED_APPLICATIONS]
                               [--target-maxversion TARGET_MAXVERSION]
                               [--target-minversion TARGET_MINVERSION]
                               [--for-appversions FOR_APPVERSIONS] [--timeout TIMEOUT]
                               package
        addon-validator: error: too few arguments

From now on, you can use ``addon-validator`` anywhere to check for the Firefox add-ons before
submitting to AMO. This will save us a lot of time when preparing for AMO publishing.

References
----------
- https://developer.mozilla.org/en-US/Add-ons
- https://blog.mozilla.org/addons/2014/06/05/how-to-develop-firefox-extension/

