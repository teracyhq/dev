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


PostgreSQL
----------

``PostgreSQL`` is disabled by default on the teracy-dev VM.

#.  Enable


#.  Local access


#.  Remote access

    ..  todo::
        We need to support this


MongoDB
-------

``PostgreSQL`` is disabled by default on the teracy-dev VM.

#.  Enable


#.  Local access


#.  Remote access

    ..  todo::
        We need to support this



References
----------
- https://www.mysql.com/
- http://www.postgresql.org/
- https://www.mongodb.org/
- http://www.phpmyadmin.net/home_page/index.php

..  _`MySQL Command-Line Tool`: http://dev.mysql.com/doc/refman/5.6/en/mysql.html
..  _`MySQL Workbench`: https://www.mysql.com/products/workbench/
