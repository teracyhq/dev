PHP Development Guide
=====================

By default, ``LAMP`` (Linux - Apache - MySQL - PHP) stack and ``LEMP`` (Linux - Ngix - MySQL - PHP)
stack are both installed on the teracy-dev VM with the following configuration:

..  code-block:: json

    {
      "nginx": {
        "enabled":true,
        "default_root": "/home/vagrant/workspace/personal",
        "listen_port":9998,
        "version": "1.7.8"
      },
      "apache":{
        "enabled":true,
        "default_root": "/home/vagrant/workspace/personal",
        "listen_port":9999
      },
      "php":{
        "enabled":true,
        "version":"5.4.29", //empty string: default ubuntu distribution; http://php.net/downloads.php
        "checksum":"9caf973b19ba93bb2b78f78c61643d5d"
      },
      "mysql":{
        "enabled":true,
        "version":"5.3.6",
        "password":"teracy"
      }
    }

Make sure you have the teracy-dev VM running (``$ vagrant up``) by following the
:doc:`getting_started` guide.


Verify ``LAMP`` and ``LEMP``
----------------------------

``$ vagrant ssh`` and check:

#.  Linux

    ..  code-block:: bash

        $ uname -a
        Linux vagrant 3.5.0-45-generic #68~precise1-Ubuntu SMP Wed Dec 4 16:18:46 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

#.  Apache

    ..  code-block:: bash

        $ apache2 -v
        Server version: Apache/2.2.22 (Ubuntu)
        Server built:   Jul 22 2014 14:35:32

#.  Nginx

    ..  code-block:: bash

        $ /opt/nginx/sbin/nginx -v
        nginx version: nginx/1.7.8

#.  MySQL

    ..  code-block:: bash

        $ mysql -u root -pteracy;

    And you should see the following output:

    ..  code-block:: bash

        Welcome to the MySQL monitor.  Commands end with ; or \g.
        Your MySQL connection id is 37
        Server version: 5.5.38-0ubuntu0.12.04.1 (Ubuntu)

        Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

        Oracle is a registered trademark of Oracle Corporation and/or its
        affiliates. Other names may be trademarks of their respective
        owners.

        Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

        mysql>

    Type ``exit`` to exit ``mysql`` shell:

    ..  code-block:: bash

        mysql> exit;


#.  PHP

    ..  code-block:: bash

        $ php --version
        PHP 5.4.29 (cli) (built: Mar 10 2015 12:20:28)
        Copyright (c) 1997-2014 The PHP Group
        Zend Engine v2.4.0, Copyright (c) 1998-2014 Zend Technologies


Open http://localhost:9998 to see ``Nginx`` serving the *workspace/personal* directory by default.

Open http://localhost:9999 to see ``Apache`` serving the *workspace/personal* directory by default.


``info.php`` Page
-----------------

Create *info.php* on the *workspace/personal/info* directory:

..  code-block:: bash

    $ ws
    $ cd personal
    $ mkdir info
    $ cd info
    $ echo "<?php" > info.php
    $ echo "  phpinfo();" >> info.php
    $ echo "?>" >> info.php

After the command lines above, you should have the *workspace/personal/info/info.php* file with the
following content:

..  code-block:: php

    <?php
      phpinfo();
    ?>

Open http://localhost:9998/info/info.php you should see php info of the system like the screenshot
below:

..  image:: _static/php-dev-guide/LEMP_info.png
    :align: center

Open http://localhost:9999/info/info.php you should see php info of the system like the screenshot
below:

..  image:: _static/php-dev-guide/LAMP_info.png
    :align: center


``XDebug`` With your favorite IDE
---------------------------------
By default our PHP install having xdebug module enabled. All you need to is:

+ Browser plugin to emmbed debug request along with page request. Install this `plugin <https://addons.mozilla.org/en-US/firefox/addon/the-easiest-xdebug/>`_ for Firefox or this `plugin <https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc>`_ for Chrome.
+ An IDE with ability to receive XDebug callback from server.

Basic step would be (Note: Details steps would be difference depend on your browser and IDE):

+ Settings XDebug handler in IDE list on port 9999 with all network interface. 
+ Use browser plugin to embed XDebug request along with HTTP request header.
+ PHP on server will call back to client IP on port 9999 and debug session start.

Read http://xdebug.org/docs/remote for more information about remote debug with XDebug.

``Composer`` Installation
-------------------------

As ``teracy-dev`` version 0.5.x and above we don't need to install ``composer`` manually, the
binary is installed at ``/usr/local/bin/composer``.


``CakePHP`` Framework
---------------------

We'll follow http://book.cakephp.org/3.0/en/quickstart.html to get started with ``CakePHP``
framework.

#.  Install

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ composer create-project --prefer-dist cakephp/app bookmarker
        $ cd bookmarker
        $ bin/cake server -H 0.0.0.0 -p 8000

    And you should see the output like:

    ..  code-block:: bash

        Welcome to CakePHP v3.1.3 Console
        ---------------------------------------------------------------
        App : src
        Path: /home/vagrant/workspace/personal/bookmarker/src/
        DocumentRoot: /home/vagrant/workspace/personal/bookmarker/webroot
        ---------------------------------------------------------------
        built-in server is running in http://0.0.0.0:8000/
        You can exit with `CTRL-C`

#.  Verify

    Open http://localhost:8000 and you should see "CakePHP - Get the Ovens Ready" page.

You can start digging ``CakePHP`` framework now: http://book.cakephp.org/3.0/en/quickstart.html


``CodeIgniter`` Framework
-------------------------

We'll follow http://www.codeigniter.com/userguide3/overview/index.html to get started with
``CodeIgniter`` framework.

#.  Install

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ wget https://github.com/bcit-ci/CodeIgniter/archive/2.2.1.zip
        $ unzip 2.2.1.zip

    And you should see *CodeIgniter-2.2.1* directory after ``unzip``.

#.  Verify

    Open http://localhost:9999/CodeIgniter-2.2.1/index.php and you should see
    "Welcome to CodeIgniter!" page.

You can start digging ``CodeIgniter`` framework now: http://www.codeigniter.com/userguide3/tutorial/index.html


``Laravel`` Framework
---------------------

You'll follow http://laravel.com/docs/5.0/installation to get started with ``Laravel`` framework.

#.  Install

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ composer global require "laravel/installer=~1.1"

#.  ``laravel new blog``

    From installation step above, ``laravel`` should be avaiable executable.

    ..  code-block:: bash

        $ laravel new blog


#.  Verify

    Open http://localhost:9999/blog/public/ and you should see "Laravel 5" page.


You can start digging ``Laravel`` framework now: http://laravel.com/docs/5.0/routing


``Symfony`` Framework
---------------------

You'll follow http://symfony.com/doc/current/quick_tour/the_big_picture.html to get started with
``Symfony`` framework.

#.  Install

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ curl -LsS http://symfony.com/installer > symfony.phar
        $ sudo mv symfony.phar /usr/local/bin/symfony

#.  Create a ``Symfony`` project

    ..  code-block:: bash

        $ symfony new myproject
        $ cd myproject
        $ php app/console server:run 0.0.0.0:8000

    And you should see the output like:

    ..  code-block:: bash

        Server running on http://0.0.0.0:8000

        Quit the server with CONTROL-C.

#.  Verify

    Open http://localhost:8000 and you should see "Welcome to Symfony" page.

You can start digging ``Symfony`` framework now:
http://symfony.com/doc/current/quick_tour/the_big_picture.html


``Yii`` Framework
-----------------

You'll follow http://www.yiiframework.com/doc-2.0/guide-start-installation.html to get started
with ``Yii`` framework.

#.  Install

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ composer global require "fxp/composer-asset-plugin:~1.0.3"
        $ composer create-project --prefer-dist yiisoft/yii2-app-basic basic

    ..  note::
        During the installation Composer may ask for your Github login credentials. This is normal
        because ``Composer`` needs to get enough API rate-limit to retrieve the dependent package
        information from Github.

        From http://www.yiiframework.com/doc-2.0/guide-start-installation.html#installing-via-composer

#.  Verify

    Verify the installation by opening http://localhost:9999/basic/web/index.php

    ..  todo::
        http://localhost:9999/basic/web/index.php (Nginx) did not work out of the box yet.


You can start digging ``Yii`` framework now: http://www.yiiframework.com/doc-2.0/guide-start-hello.html



``Drupal`` CMS
--------------

You'll follow https://www.drupal.org/documentation/install to get started with ``Drupal``.

#.  Download and extract

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ wget http://ftp.drupal.org/files/projects/drupal-7.35.tar.gz
        $ tar -xzvf drupal-7.35.tar.gz

#.  Create the database

    You'll use ``MySQL`` for database.

    ..  code-block:: bash

        $ mysql -u root -pteracy -e "CREATE DATABASE drupal CHARACTER SET utf8 COLLATE utf8_general_ci;"

    You'll use *drupal* as database with *root* as username and *teracy* as password by default.

    ..  note::
        All the default username, password of the teracy-dev is for development only. Don't use all
        the default like this on production servers.

#.  Setup

    Open http://localhost:9999/drupal-7.35 and follow installation wizard.


You can start digging ``Drupal`` CMS now: https://www.drupal.org/documentation


``Joomla!`` CMS
---------------

You'll follow https://docs.joomla.org/J3.x:Installing_Joomla to get started with ``Joomla!``.

#.  Download and extract

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ wget https://github.com/joomla/joomla-cms/releases/download/3.4.1/Joomla_3.4.1-Stable-Full_Package.zip
        $ unzip Joomla_3.4.1-Stable-Full_Package.zip -d joomla

#.  Create the database

    You'll use ``MySQL`` for database.

    ..  code-block:: bash

        $ mysql -u root -pteracy -e "CREATE DATABASE joomla CHARACTER SET utf8 COLLATE utf8_general_ci;"

    You'll use *joomla* as database with *root* as username and *teracy* as password by default.

#.  Setup

    Open http://localhost:9999/joomla and follow installation wizard.

You can start digging ``Joomla!`` CMS now: https://docs.joomla.org/J3.x:Getting_Started_with_Joomla!


``WordPress`` CMS
-----------------

You'll follow http://codex.wordpress.org/Installing_WordPress to get started with ``Wordpress``.


#.  Download and extract

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ wget https://wordpress.org/latest.tar.gz
        $ tar -xzvf latest.tar.gz

#.  Create the database

    You'll use ``MySQL`` for database.

    ..  code-block:: bash

        $ mysql -u root -pteracy -e "CREATE DATABASE wordpress CHARACTER SET utf8 COLLATE utf8_general_ci;"

    You'll use *wordpress* as database with *root* as username and *teracy* as password by default.

#.  Setup

    Open http://localhost:9999/wordpress and follow installation wizard.


You can start digging ``Wordpress`` CMS now: http://codex.wordpress.org/Getting_Started_with_WordPress

References
----------
- http://www.phptherightway.com/
- https://getcomposer.org/
- http://cakephp.org/
- http://www.codeigniter.com/
- http://laravel.com/
- http://symfony.com/
- http://www.yiiframework.com/
- https://www.drupal.org/
- https://joomla.org/
- http://wordpress.org/