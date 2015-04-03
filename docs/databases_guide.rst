Databases Guide
===============

Databases are very important and crucial part of any systems, they provide an efficient way to
store, retrieve and analyze data.

The teracy-dev VM provides some of the most popular databases such as: ``MySQL``, ``PostgreSQL``
and ``MongoDB``. This guide will help us to enable and use these databases.


MySQL
-----

``MySQL`` is installed by default on the teracy-dev VM with **root** as username and **teracy**
as password by default.


#.  Local access

    ..  code-block:: bash

        $ vagrant ssh
        $ mysql -u root -pteracy

    And we should see the following output:

    ..  code-block:: bash

        Welcome to the MySQL monitor.  Commands end with ; or \g.
        Your MySQL connection id is 5
        Server version: 5.5.41-0ubuntu0.12.04.1 (Ubuntu)

        Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

        Oracle is a registered trademark of Oracle Corporation and/or its
        affiliates. Other names may be trademarks of their respective
        owners.

        Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

        mysql>

    Type ``$ exit`` to exit the ``MySQL`` shell above.


#.  Remote access

    For easier development, ``MySQL`` on the teracy-dev has binding address of ``0.0.0.0``, this
    means that we could remote access it.

    The teracy-dev VM by default forwards the port `3306` of ``MySQL`` to `6603` of the host
    machine. So we're going to remote access with the following credentials information by default:

    - host: the guest machine's IP address or ``127.0.0.1`` to access from the guest machine
    - port: ``6603``
    - username: ``root``
    - password: ``teracy``

    We need a ``MySQL`` client, such as `MySQL Command-Line Tool`_, `MySQL Workbench`_, etc.

    - With *MySQL Command-Line Tool* to remote access from the guest machine:

        ..  code-block:: bash

            $ mysql -u root -pteracy -h 127.0.0.1 -P 6603


    - With *MySQL Workbench* to remote access from the guest machine:

        ..  image:: _static/databases-guide/mysql_workbench.png
            :align: center


#.  phpMyAdmin

    Open http://localhost:9997 and type *root* as username, *teracy* as password and we're done.

    ..  image:: _static/databases-guide/phpMyAdmin.png
        :align: center

From now on we can start digging ``MySQL`` database at: http://dev.mysql.com/doc/


PostgreSQL
----------

``PostgreSQL`` is disabled by default on the teracy-dev VM:

..  code-block:: json

    {
      "postgresql":{
        "enabled":false,
        "password":{
          "postgres":"teracy"
        },
        "version":"9.3"
      }
    }

#.  Enable

    To enable, we need to override the default configuration by appending *postgresql* attribute within
    *teracy-dev* attribute to the *vagrant_config_override.json* file like the configuration below:

    ..  code-block:: json

        {
          "chef_json":{
            "teracy-dev":{
              "postgresql":{
                "enabled":true
              }
            }
          }
        }

    Save the file and then ``$ vagrant provision``, after that ``PostgreSQL`` should be installed.

    By default, we use `postgres` as username and `teracy` as password to access the enabled
    ``PostgreSQL`` database instance.


#.  Verify

    Within vagrant ssh session, by:

    ..  code-block:: bash

        $ vagrant ssh
        $ psql -U postgres -h localhost

    And we should see the following output:

    ..  code-block:: bash

        Password for user postgres:
        psql (9.1.14)
        SSL connection (cipher: DHE-RSA-AES256-SHA, bits: 256)
        Type "help" for help.

        postgres=#

    To exit the ``PostgreSQL`` shell:

    ..  code-block:: bash

        postgres=# \q

#.  Initialize the super user *vagrant* role and default *vagrant* database

    This step is required for the first time when the ``PostgreSQL`` database is enabled and
    installed.

    ..  code-block:: bash

        $ sudo su postgres
        $ createuser vagrant

    Type ``y`` and hit enter when asked “Shall the new role be a superuser?”

    Now we can exit the *su* subshell to go back to the vagrant user SSH session:

    ..  code-block:: bash

        $ exit

    Now create *vagrant* database:

    ..  code-block:: bash

        $ createdb vagrant


#.  Local access

    When *vagrant* super user and *vagrant* database is created, we just need to type:

    ..  code-block::

        $ psql

    And we should the the following output:

    ..  code-block:: bash

        psql (9.1.14)
        Type "help" for help.

        vagrant=#

    Type ``\q`` to quit the ``PostgreSQL`` shell.

#.  Remote access

    ..  todo::
        We need to support this by https://issues.teracy.org/browse/DEV-221

From now on we can start digging ``PostgreSQL`` database at: http://www.postgresql.org/docs/


MongoDB
-------

``MongoDB`` is disabled by default on the teracy-dev VM:

..  code-block:: json

    {
      "mongodb":{
        "enabled":false,
        "version":"2.6.3"
      }
    }


#.  Enable

    To enable, we need to override the default configuration by appending *mongodb* attribute within
    *teracy-dev* attribute to the *vagrant_config_override.json* file like the configuration below:

    ..  code-block:: json

        {
          "chef_json":{
            "teracy-dev":{
              "mongodb":{
                "enabled":true
              }
            }
          }
        }

    Save the file and then ``$ vagrant provision``, after that ``MongoDB`` should be installed.

#.  Verify

    Within vagrant ssh session, by:

    ..  code-block:: bash

        $ vagrant ssh
        $ mongo

    And we should the the following output:

    ..  code-block: bash

        MongoDB shell version: 2.6.9
        connecting to: test
        >

    Type ``exit`` to quit the ``MongoDB`` shell.

#.  Local access

    Just type ``mongo`` and we're done.


#.  Remote access

    By default, the default port *27017* is forwarded to the guest machine, to remote access it, we
    only need to specify the host ip address when required:

    - host: the guest machine's IP address or *127.0.0.1* or *localhost* or none to access from the
    guest machine

    For example, from a guest machine:

    ..  code-block:: bash

        $ mongo

    or:

    ..  code-block:: bash

        $ mongo localhost

    We could replace *localhost* with *127.0.0.1*.

    or from a different machine to the machine running the teracy-dev VM with ip: *192.168.1.111*

    ..  code-block:: bash

        $ mongo 192.168.1.111


    ..  notice::
        For easier development, by default the ``MongoDB`` instance does not require username and
        password.

From now on we can start digging ``MongoDB`` database at: http://docs.mongodb.org/manual/

References
----------
- https://www.mysql.com/
- http://www.postgresql.org/
- https://www.mongodb.org/
- http://www.phpmyadmin.net/home_page/index.php

..  _`MySQL Command-Line Tool`: http://dev.mysql.com/doc/refman/5.6/en/mysql.html
..  _`MySQL Workbench`: https://www.mysql.com/products/workbench/
