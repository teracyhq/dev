Node.js Development Guide
=========================

Follow this guide to create https://github.com/teracyhq/hello-world-nodejs from scratch.

Make sure that you have ``teracy-dev`` running, if not, follow the :doc:`getting_started` guide first.

Make sure that you master the :doc:`basic_usage` guide first.

Video
-----

Check out the video and follow step by step instructions below:

.. raw:: html

    <iframe width="100%" height="630" src="https://www.youtube.com/embed/2200zvxIdAs" frameborder="0" allowfullscreen></iframe>

..  note::

    The video is not really up to date with current teracy-dev v0.5.0, you will understand the
    similar worlflow and the result, though.


Enable proxy and add aliases domains
------------------------------------

To access your nodejs web app with the domain ``hello-d.teracy.dev`` (dev mode) and ``hello.teracy.dev``
(prod mode), we need to enable the proxy container and domain aliases so that everything should be
set up automatically under the hood for you.

- Create ``vagrant_config_override.json`` file under ``~/teracy-dev`` directory with the following
  content:

  ..  code-block:: json

      {
        "provisioners": [{
          "_id": "0",
          "json": {
            "teracy-dev": {
              "proxy": {
                "container": {
                  "enabled": true
                }
              }
            }
          }
        }],
        "plugins": [{
          "_id": "2",
          "options": {
            "aliases": ["hello-d.teracy.dev", "hello.teracy.dev"]
          }
        }]
      }

- Reload the VM:

  ..  code-block:: bash

      $ cd ~/teracy-dev
      $ vagrant reload

- Update the ``/etc/hosts`` file automatically with the following commands:

  ..  code-block:: bash

      $ cd ~/teracy-dev
      $ vagrant hostmanager

- Now open teracy.dev on your browser, it should display the following similar message:

  ..  code-block:: bash

      503 Service Temporarily Unavailable

      nginx/1.11.9

  so it works.


Init the project
----------------

You're going to create `hello-world-nodejs` application, so let's create the app directory and init
the app with `$ npm init`.


- Create the ``hello-world-nodejs`` directory under ``~/teracy-dev/workspace`` by opening a host
  terminal window and execute the following commands:

  ..  code-block:: bash

      $ cd ~/teracy-dev/workspace
      $ mkdir hello-world-nodejs

- Use the `node:6.9` Docker image to run ``$ npm init`` by ``ssh`` into the VM and execute the
  following commands:

  ..  code-block:: bash

      $ vagrant ssh
      $ ws
      $ cd hello-world-nodejs
      $ docker container run -it --rm -v $(pwd):/opt/hello-world-nodejs -w /opt/hello-world-nodejs node:6.9 /bin/bash

  You should be presented with the container bash session as: ``root@85fe561:/opt/hello-world-nodejs#``

- ``# npm init`` and fill in the content as below:

  ..  code-block:: bash

      root@85fe561:/opt/hello-world-nodejs# npm init
      npm info it worked if it ends with ok
      npm info using npm@3.10.10
      npm info using node@v6.9.5
      This utility will walk you through creating a package.json file.
      It only covers the most common items, and tries to guess sensible defaults.

      See `npm help json` for definitive documentation on these fields
      and exactly what they do.

      Use `npm install <pkg> --save` afterwards to install a package and
      save it as a dependency in the package.json file.

      Press ^C at any time to quit.
      name: (hello-world-nodejs)
      version: (1.0.0) 0.1.0-SNAPSHOT
      description: hello-world-nodejs
      entry point: (index.js)
      test command:
      git repository:
      keywords:
      author: Teracy
      license: (ISC) MIT
      About to write to /opt/hello-world-nodejs/package.json:

      {
        "name": "hello-world-nodejs",
        "version": "0.1.0-SNAPSHOT",
        "description": "hello-world-nodejs",
        "main": "index.js",
        "scripts": {
          "test": "echo \"Error: no test specified\" && exit 1"
        },
        "author": "Teracy",
        "license": "MIT"
      }

      Is this ok? (yes) yes
      npm info init written successfully
      npm info ok
      root@85fe561:/opt/hello-world-nodejs#

- You need to sync the generated files from the VM machine to the host machine by opening a host
  terminal window and type:

  ..  code-block:: bash

      $ cd teracy-dev
      $ vagrant rsync-back

  After that, you should see the ``package.json`` file under the 
  ``~/teracy-dev/workspace/hello-world-nodejs`` directory on the host machine.


The output should be something like this:
https://github.com/teracyhq/hello-world-nodejs/commit/72ffde127e5935c70b9022ccdf107c2c9d4c6048


Install dependencies
--------------------

We're going to use ``express`` for the web app construction and ``nodemon`` for development
convenience.

- Continue run the following commands within the container session:

  ..  code-block:: bash

      root@85fe561:/opt/hello-world-nodejs# npm install express --save
      root@85fe561:/opt/hello-world-nodejs# npm install nodemon --save-dev

- And similarly, you need to sync the generated files from the VM machine to the host machine by
  opening a host terminal window and type:

  ..  code-block:: bash

      $ cd teracy-dev
      $ vagrant rsync-back

  After that, you should see the updated ``package.json`` file.

The output should be something like this:
https://github.com/teracyhq/hello-world-nodejs/commit/82f357675e426f4af076a4608cc43a364edfb7af


Add app.js and update package.json's scripts
--------------------------------------------

- Create ``app.js`` file within ``hello-world-nodejs`` directory with the following content:

  ..  code-block:: javascript

      var express = require('express');
      var app = express();

      app.get('/', function (req, res) {
        res.send('Hello World!');
      });

      var port = process.env.PORT || 3000;
      app.listen(port, function () {
        console.log('app listening on port ' + port);
      });

- Update the ``scripts`` section on the ``package.json`` file:

  ..  code-block:: json

      "scripts": {
        "start": "node app.js",
        "start:dev": "nodemon app.js",
        "test": "echo \"Error: no test specified\" && exit 1"
      }

The output should be something like this:
https://github.com/teracyhq/hello-world-nodejs/commit/eb33e42f8544ee8f59535b44b6416630d911b06f


Add Docker files
----------------

We need to add:
  - ``Dockerfile-dev`` and ``docker-compose.yml`` files for dev mode
  - ``Dockerfile`` and ``docker-compose.prod.yml`` for prod mode


- Create ``Dockerfile-dev`` file within ``hello-world-nodejs`` directory with the following content:

  ..  code-block:: docker

      FROM node:6.9

      ENV APP=/opt/app

      RUN mkdir -p $APP

      ADD package.json $APP/

      WORKDIR $APP

      RUN npm install

      VOLUME $APP/node_modules

- Create ``docker-compose.yml`` file within ``hello-world-nodejs`` directory with the following
  content:

  ..  code-block:: yaml

      version: '2'

      services:
        dev:
          build:
            context: .
            dockerfile: Dockerfile-dev
          image: teracy/hello-world-nodejs:dev_develop
          command: bash -c "npm run start:dev"
          volumes:
            - .:/opt/app
          ports:
            - 3000
          restart: always
          # nginx-proxy
          environment:
            - VIRTUAL_HOST=hello-d.teracy.dev
          # to get this work with https://github.com/jwilder/nginx-proxy
          # related: https://github.com/jwilder/nginx-proxy/issues/305
          network_mode: bridge

- Create ``Dockerfile`` file within ``hello-world-nodejs`` directory with the following content:

  ..  code-block:: docker

      FROM node:6.9

      ENV APP=/opt/app NODE_ENV=production

      RUN mkdir -p $APP

      ADD . $APP/

      WORKDIR $APP

      RUN npm install --production

      CMD npm run start

- Create ``docker-compose.prod.yml`` file within ``hello-world-nodejs`` directory with the following
  content:

  ..  code-block:: yaml

      version: '2'

      services:
        prod:
          build:
            context: .
            dockerfile: Dockerfile
          image: teracy/hello-world-nodejs:develop
          ports:
            - 3000
          restart: always
          # nginx-proxy
          environment:
            - VIRTUAL_HOST=hello.teracy.dev
          # to get this work with https://github.com/jwilder/nginx-proxy
          # related: https://github.com/jwilder/nginx-proxy/issues/305
          network_mode: bridge


The output should be something like this:
https://github.com/teracyhq/hello-world-nodejs/commit/e1d708c0e0192ca1dad8ba4225d3766ac310b02c


Run on dev mode
---------------

Open a new terminal window, `ssh` into the teracy-dev VM to execute the following commands:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd hello-world-nodejs
    $ docker-compose up -d


After that, open hello-d.teracy.dev on your browser to see the app on the dev mode.

Run on prod mode
----------------

Open a new terminal window,, `ssh` into the teracy-dev VM to execute the following commands:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd hello-world-nodejs
    $ docker-compose -f docker-compose.prod.yml up -d


After that, open hello.teracy.dev on your browser to see the app on the prod mode.

Congratulations, you've created a basic hello world nodejs app with Docker workflow running
on ``teracy-dev``.
