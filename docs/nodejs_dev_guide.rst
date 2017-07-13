Node.js Development Guide
=========================

Follow this guide to create https://github.com/acme101/nodejs-hello-world from scratch.

Make sure that you have ``teracy-dev`` running, if not yet, follow the :doc:`getting_started` guide first.

Make sure that you master the :doc:`basic_usage` guide, too.


Enable proxy and add aliases domains
------------------------------------

To access your nodejs web app with the domain ``dev.nodejs.teracy.dev`` (dev mode),
``review.nodejs.teracy.dev``` (review mode) and ``nodejs.teracy.dev`` (local prod mode), you need
to enable the proxy container and configure domain aliases so that everything should be
set up automatically under the hood for you.

- Create ``vagrant_config_override.json`` file under the ``~/teracy-dev`` directory with the
  following content:

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
            "aliases": ["dev.nodejs.teracy.dev", "review.nodejs.teracy.dev" "nodejs.teracy.dev"]
          }
        }]
      }

- Reload the VM to get new configuration updated to the VM:

  ..  code-block:: bash

      $ cd ~/teracy-dev
      $ vagrant reload --provision

- Update the ``/etc/hosts`` file automatically with the following commands:

  ..  code-block:: bash

      $ cd ~/teracy-dev
      $ vagrant hostmanager

- Now open teracy.dev on your browser, it should display the following similar message:

  ..  code-block:: bash

      503 Service Temporarily Unavailable

      nginx/1.11.9

  so reverse proxy works.


Init the project
----------------


- Create the ``nodejs-hello-world`` directory under the ``~/teracy-dev/workspace`` directory by
  opening a host terminal window and execute the following commands:

  ..  code-block:: bash

      $ cd ~/teracy-dev/workspace
      $ mkdir nodejs-hello-world

- Use the ``node:8.1.3-alpine`` Docker image to run ``$ npm init`` by ``vagrant ssh`` into the VM
  and execute the commands as follows:

  ..  code-block:: bash

      $ vagrant ssh
      $ ws
      $ cd nodejs-hello-world
      $ docker container run -it --rm -v $(pwd):/opt/nodejs-hello-world -w /opt/nodejs-hello-world node:8.1.3-alpine sh

  You should be presented with the container bash session as: ``/opt/nodejs-hello-world #``

- ``# npm init`` and fill in the content as below:

  ..  code-block:: bash

      /opt/nodejs-hello-world # npm init
      npm info it worked if it ends with ok
      npm info using npm@5.0.3
      npm info using node@v8.1.3
      This utility will walk you through creating a package.json file.
      It only covers the most common items, and tries to guess sensible defaults.

      See `npm help json` for definitive documentation on these fields
      and exactly what they do.

      Use `npm install <pkg>` afterwards to install a package and
      save it as a dependency in the package.json file.

      Press ^C at any time to quit.
      package name: (nodejs-hello-world) 
      version: (1.0.0) 0.1.0-SNAPSHOT
      description: nodejs-hello-world
      entry point: (index.js) 
      test command: 
      git repository: 
      keywords: 
      author: Teracy
      license: (ISC) MIT
      About to write to /opt/nodejs-hello-world/package.json:

      {
        "name": "nodejs-hello-world",
        "version": "0.1.0-SNAPSHOT",
        "description": "nodejs-hello-world",
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

- You need to sync the generated files from the VM machine back to the host machine by opening a host
  terminal window and type:

  ..  code-block:: bash

      $ cd teracy-dev
      $ vagrant rsync-back

  After that, you should see the ``package.json`` file under the 
  ``~/teracy-dev/workspace/nodejs-hello-world`` directory on the host machine.


The changes should be like this:
https://github.com/acme101/nodejs-hello-world/commit/893a19a17ced18d8aef5115ff85a109efc0f43a5


Install dependencies
--------------------

We're going to use ``express`` for the web app construction and ``nodemon`` for development
convenience.

- Continue running the following commands within the container bash session:

  ..  code-block:: bash

      /opt/nodejs-hello-world # yarn add express
      /opt/nodejs-hello-world # yarn add nodemon --dev

- And similarly, you need to sync the generated files from the VM machine back to the host machine
  by opening a host terminal window and type:

  ..  code-block:: bash

      $ cd teracy-dev
      $ vagrant rsync-back

  After that, you should see the updated ``package.json`` file.

The changes should be like this:
https://github.com/acme101/nodejs-hello-world/commit/a2208b5b1110d920e78d292cfcb9f6aec4f93a3b


Add app.js and update package.json's scripts
--------------------------------------------

- Create ``app.js`` file within the ``nodejs-hello-world`` directory with the following content:

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

- Update the ``main``, ``scripts`` section on the ``package.json`` file:

  ..  code-block:: json

      "main": "app.js",
      "scripts": {
        "dev": "nodemon --inspect=0.0.0.0:5858",
        "dev:brk": "nodemon --inspec-brk=0.0.0.0:5858",
        "test": "echo \"Error: no test specified\" && exit 1"
      }

The changes should be like this:
https://github.com/acme101/nodejs-hello-world/commit/a2228e9c4da01bf3988337def3cf26c4974a9c6f


Create dev mode
---------------

Dev mode usually contains development packages to assist development productivity, for example:
auto reloading when there are code changes, debugging, etc.


- Create ``docker-compose.yml`` file within the ``nodejs-hello-world`` directory with the following
  content:

  ..  code-block:: yaml

      version: '3'

      services:

        dev:
          image: ${DOCKER_IMAGE_DEV:-node:8.1.3-alpine}
          working_dir: /opt/app
          command: sh run-dev.sh
          environment:
            NODE_ENV: development
            PORT: 3000
            VIRTUAL_HOST: dev.nodejs.teracy.dev, ~^dev\.nodejs\..*\.xip\.io
            VIRTUAL_PORT: 3000
            HTTPS_METHOD: noredirect # support both http and https
          env_file:
            - .env-common
            - .env-dev
          ports:
            - "3000"
            - "5858"
          volumes:
            - .:/opt/app
          restart: unless-stopped
          # to get this work with https://github.com/jwilder/nginx-proxy
          # related: https://github.com/jwilder/nginx-proxy/issues/305
          network_mode: bridge


- Create ``run-dev.sh`` with the following content:

  ..  code-block:: bash

      #!/bin/bash

      yarn

      yarn run dev



- Create ``.env-common`` and ``.env-dev`` files to set environment variables when required.


The changes should be like this:
https://github.com/acme101/nodejs-hello-world/commit/b0a7ac4e95898ecd12651830917a5f4db9561420


Run on dev mode
---------------

Open a new terminal window, ``vagrant ssh`` into the ``teracy-dev`` VM to execute the following commands:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd nodejs-hello-world
    $ docker-compose up -d dev && docker-compose logs -f dev


After that, open:

- http://dev.nodejs.teracy.dev or https://dev.nodejs.teracy.dev on your host browser to see the app
  on the dev mode.
- Check out the VM's :ref:`basic_usage-ip_address` and on any device within your LAN,
  open http://dev.nodejs.<vm_ip>.xip.io or https://dev.nodejs.<vm_ip>.xip.io to see the web app.


Two-way sync for node_modules
-----------------------------

By default, we disable ``node_modules`` sync. To have two-way sync, we need to configure it.

- Create the ``node_modules`` directory from the host terminal window:

  ..  code-block:: bash

      $ cd ~/teracy-dev/workspace/nodejs-hello-world
      $ mkdir node_modules
      $ touch node_modules/.gitkeep

- Add ``.gitignore`` for ``node_modules`` content, except ``.gitkeep`` to keep the empty directory,
  this is required by the configuration of the ``vagrant_config_override.json`` file as follows:

  ..  code-block:: json

      {

        "vm": {
          "synced_folders":[{
            "type": "virtual_box",
            "host": "workspace/nodejs-hello-world/node_modules",
            "guest": "/home/vagrant/workspace/node-js-hello-world/node_modules",
            "mount_options": [
              "dmode=777",
              "fmode=755"
            ]
          }]
        },
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
            "aliases": ["dev.nodejs.teracy.dev", "review.nodejs.teracy.dev" "nodejs.teracy.dev"]
          }
        }]
      }

- ``$ vagrant reload`` to get it take effect.

- Re-run the dev container to get it to install the ``npm`` packages again:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd nodejs-hello-world
    $ docker-compose restart dev && docker-compose logs -f dev

Afer this, the ``npm`` packages should be syned into the host ``node_modules`` directory.

The changes should be like this: https://github.com/acme101/nodejs-hello-world/commit/7876be54139be716d45f200f2a87a1c3985bf81a


Remote debugging
----------------

See the forwarded debug ports by:

..  code-block:: bash

    $ docker-compose ps dev


You could see something like this:

..  code-block:: bash

             Name               Command      State                        Ports                       
    -------------------------------------------------------------------------------------------------
    nodejshelloworld_dev_1   sh run-dev.sh   Up      0.0.0.0:32770->3000/tcp, 0.0.0.0:32769->5858/tcp 


=> use ``32769`` as the debug port.

=> use ``teracy.dev`` as the debug host.

And you follow the links below for remote debugging:

- https://www.jetbrains.com/help/webstorm/run-debug-configuration-chromium-remote.html
- https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000161104-Can-t-remote-debug-node-inspect
- https://nodejs.org/en/docs/inspector/#chrome-devtools-55


When you scale the dev services into more containers, you can do the same by attaching more debug hosts into the IDE.


Create Prod mode
----------------

Prod mode will run the Docker image of the app which is used for production deployment. The Docker image
usually contains only the run-time stuff.

- Create the ``Dockerfile`` file within the ``nodejs-hello-world`` directory with the following content:

  ..  code-block:: docker

      FROM node:8.1.3-alpine

      LABEL authors="hoatle <hoatle@teracy.com>"

      RUN mkdir -p /opt/app

      ENV TERM=xterm APP=/opt/app

      # add more arguments from CI to the image so that `$ env` should reveal more info
      ARG CI_BUILD_ID
      ARG CI_BUILD_REF
      ARG CI_REGISTRY_IMAGE
      ARG CI_BUILD_TIME
      ARG NODE_ENV

      ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
          CI_BUILD_TIME=$CI_BUILD_TIME NODE_ENV=$NODE_ENV

      WORKDIR $APP

      ADD package.json yarn.lock $APP/

      RUN yarn install && \
          yarn global add pm2 && \
          yarn cache clean

      ADD . $APP

      CMD ["sh", "run-prod.sh"]


- Create the ``docker-compose.prod.yml`` file within the ``nodejs-hello-world`` directory with the
  following content:

  ..  code-block:: yaml

      version: '3'

      services:

        prod:
          build:
            context: .
            dockerfile: Dockerfile
            args:
              CI_BUILD_ID: ${CI_BUILD_ID}
              CI_BUILD_REF: ${CI_BUILD_REF}
              CI_BUILD_TIME: ${CI_BUILD_TIME}
              CI_REGISTRY_IMAGE: ${CI_REGISTRY_IMAGE}
              NODE_ENV: production
          image: ${DOCKER_IMAGE_PROD:-acme101/nodejs-hello-world:develop}
          environment:
            PORT: 8080
            VIRTUAL_HOST: nodejs.teracy.dev, ~^nodejs\..*\.xip\.io
            HTTPS_METHOD: noredirect # support both http and https
          env_file:
            - .env-common
            - .env-prod
          ports:
            - "8080"
          network_mode: bridge



The changes should be like this:
https://github.com/acme101/nodejs-hello-world/commit/a710fda1e9602e4f5e558198c6a3206affb8976e


Run on prod mode
----------------

Open a new terminal window,, `vagrant ssh` into the ``teracy-dev`` VM to execute the following
commands:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd nodejs-hello-world
    $ docker-compose -f docker-compose.prod.yml build prod # to build the prodution Docker image
    $ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d prod && \
      docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f prod # to run the production Docker image


After that, open:

- http://nodejs.teracy.dev or https://nodejs.teracy.dev on your host browser to see the app
  on the prod mode.
- Check out the VM's :ref:`basic_usage-ip_address` and on any device within your LAN,
  open http://nodejs.<vm_ip>.xip.io or https://nodejs.<vm_ip>.xip.io to see the web app.


Create review mode
------------------

Review mode will be used to review the production docker image from other team members.

This is very simple docker-compose configuration.

The changes should be like this: https://github.com/acme101/nodejs-hello-world/commit/1f7d0cfdd82435a482834fb45b2203674134cfc2


Run on review mode
------------------

For example, we're going to review `hoatle/nodejs-hello-world:feature-1` Docker image.

Open a new terminal window,, ``$ vagrant ssh`` into the ``teracy-dev`` VM to execute the following
commands:

..  code-block:: bash

    $ vagrant ssh
    $ ws
    $ cd nodejs-hello-world
    $ DOCKER_IMAGE_REVIEW=hoatle/nodejs-hello-world:feature-1 \
      docker-compose -f docker-compose.yml -f docker-compose.review.yml up -d review && \
      docker-compose -f docker-compose.yml -f docker-compose.review.yml logs -f review

After that, open:

- http://review.nodejs.teracy.dev or https://review.nodejs.teracy.dev on your host browser to see
  the app on the review mode.
- Check out the VM's :ref:`basic_usage-ip_address` and on any device within your LAN,
  open http://review.nodejs.<vm_ip>.xip.io or https://review.nodejs.<vm_ip>.xip.io to see the web app.


Create CI/CD system
-------------------

It's required that we should always run CI/CD to automate the build and deployment. In this guide,
we're going to create CI/CD for travis-ci and gitlab-ci.

For deployment, we're going to deploy on Heroku, Google Container Engine (Kubernertes).

The changes should be like this: https://github.com/acme101/nodejs-hello-world/commit/ca822a679691de619200e7cd2a0a5d946e5045ae

To get the most up-to-date and more information, please checkout the README.md file from the
project https://github.com/acme101/nodejs-hello-world

We can deploy the app on GKE (Google Container Engine) and Heroku by default.

We deploy and keep the app on Heroku at: https://develop-acme101-nhw.herokuapp.com/


Summary
-------

Congratulations, we've created a basic hello world Node.js app with Docker workflow, CI/CD system on
the ``teracy-dev``. These are the current best practices to work with ``teracy-dev``, we can apply
these best practices to different types of projects and stacks.
