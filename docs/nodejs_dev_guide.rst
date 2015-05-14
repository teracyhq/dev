Node.js Development Guide
=========================

By default, Node.js is already installed on the `teracy-dev` VM with the following configuration:

..  code-block:: json

    {
      "nodejs":{
        "enabled":true,
        "version":"0.10.28",
        "checksum":"abddc6441e0f208f6ed8a045e0293f713ea7f6dfb2d6a9a2024bf8b1b4617710",
        "npm": {
          "version":"1.4.3",
          "globals": [
            {
              "name":"grunt-cli",
              "version":""
            },
            {
              "name":"gulp",
              "version":""
            },
            {
              "name":"bower",
              "version":""
            },
            {
              "name":"yo",
              "version":""
            },
            {
             "name":"phantomjs",
             "version":""
            }
          ]
        }
      }
    }

Make sure you have the teracy-dev VM running (``$ vagrant up``) by following the
:doc:`getting_started` guide.


Verify Node.js
--------------

``$ vagrant ssh`` and check:

#.  ``node``

    ..  code-block:: bash

        $ node --version
        v0.10.28

#.  ``npm``

    ..  code-block:: bash

        $ npm --version
        1.4.3


Hello World
-----------

We're going to follow the example from https://nodejs.org/ to create a `Hello World` web server.

..  code-block:: bash

    $ ws
    $ cd personal
    $ mkdir node-hello
    $ cd node-hello

Let's use `vim` to create a file named `example.js` under the `node-hello` directory with the following
content:

..  code-block:: javascript

    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(3000, '0.0.0.0');
    console.log('Server running at http://0.0.0.0:3000/');

Run it with:

..  code-block:: bash

    $ node example.js
    Server running at http://0.0.0.0:3000/

And then open the browser at http://localhost:3000 and you should see the `Hello World` displayed.

We can start digging `Node.js` now at: https://nodejs.org/documentation/


Express Framework
-----------------

We're going to follow `Getting started` section from http://expressjs.com/starter/hello-world.html
to create a `Hello World` web application.


..  code-block:: bash

    $ ws
    $ cd personal
    $ mkdir myapp
    $ cd myapp
    $ sudo chown -R `whoami` ~/tmp/
    $ npm init
    $ npm install express --save

..  note::

    ``sudo chown -R `whoami` ~/tmp/`` is required to make sure you don't get any permission error,
    something like:

    ..  code-block:: bash

        npm ERR! Error: EACCES, mkdir '/home/vagrant/tmp/npm-19210-ZLDRmRUG'
        npm ERR!  { [Error: EACCES, mkdir '/home/vagrant/tmp/npm-19210-ZLDRmRUG']
        npm ERR!   errno: 3,
        npm ERR!   code: 'EACCES',
        npm ERR!   path: '/home/vagrant/tmp/npm-19210-ZLDRmRUG',
        npm ERR!   parent: 'myapp' }
        npm ERR!
        npm ERR! Please try running this command again as root/Administrator.

        npm ERR! System Linux 3.13.0-49-generic
        npm ERR! command "/usr/local/bin/node" "/usr/local/bin/npm" "install" "express" "--save"
        npm ERR! cwd /home/vagrant/workspace/personal/myapp
        npm ERR! node -v v0.10.28
        npm ERR! npm -v 1.4.9
        npm ERR! path /home/vagrant/tmp/npm-19210-ZLDRmRUG
        npm ERR! code EACCES
        npm ERR! errno 3
        npm ERR! stack Error: EACCES, mkdir '/home/vagrant/tmp/npm-19210-ZLDRmRUG'
        npm ERR!
        npm ERR! Additional logging details can be found in:
        npm ERR!     /home/vagrant/workspace/personal/myapp/npm-debug.log
        npm ERR! not ok code 0


Let's use `vim` to create `app.js` file under `myapp` directory with the following content:

..  code-block:: javascript

    var express = require('express');
    var app = express();

    app.get('/', function (req, res) {
      res.send('Hello World!');
    });

    var server = app.listen(3000, function () {

      var host = server.address().address;
      var port = server.address().port;

      console.log('Example app listening at http://%s:%s', host, port);

    });

Run it with:

..  code-block:: bash

    $ node app.js
    Example app listening at http://0.0.0.0:3000


And then open the browser at http://localhost:3000 and you should see the `Hello World!` displayed.

We can start digging `Express` now at: http://expressjs.com/


MEAN Stack
----------

We're going to follow http://learn.mean.io/ to get started.

``MEAN`` requires ``mongodb`` running, you need to follow :ref:`MongoDB Guide <databases-guide-mongodb>`.


..  code-block:: bash

    $ ws
    $ cd personal
    $ sudo npm install -g mean-cli
    $ sudo chown -R `whoami` ~/.npm
    $ mean init mean-app
    $ cd mean-app
    $ npm install
    $ bower install


..  note::

    -  ``sudo chown -R `whoami` ~/.npm`` is required to make sure you don't get any permission error,
       something like:

       ..  code-block:: bash

           There are 56 files in your ~/.npm owned by root
           Please change the permissions by running - chown -R `whoami` ~/.npm

           /usr/local/lib/node_modules/mean-cli/lib/install.js:43
                  if (err) throw err;
                                 ^
           ROOT PERMISSIONS IN NPM

    -  ``$ npm install`` could possibly not finish with this step:
       `node tools/scripts/postinstall.js` and that's ok.

Run it with:

..  code-block:: bash

    $ gulp


And then open the browser at http://localhost:3000 and you should see the `MEAN` web app displayed.

You can start digging `MEAN` now at: http://learn.mean.io/


References
----------
- https://nodejs.org/
- https://iojs.org/en/index.html
- http://expressjs.com
- http://mean.io/
