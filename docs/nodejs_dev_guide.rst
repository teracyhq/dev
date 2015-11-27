Node.js Development Guide
=========================

By default, Node.js is already installed on the `teracy-dev` VM with the following configuration:

..  code-block:: json

    {
      "nodejs":{
        "enabled":true,
        "versions": ["4.2.2", "0.12.8"],
        "global_version": "4.2.2",
        "npm": {
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


Verify `nvm`
------------
nvm_ is already installed and available to work on different versions of nodejs, to verify:

..  code-block:: bash

    $ nvm --version
    0.29.0


Verify Node.js
--------------

``$ vagrant ssh`` and check:

#.  ``node``

    ..  code-block:: bash

        $ node --version
        v4.2.2

#.  ``npm``

    ..  code-block:: bash

        $ npm --version
        2.14.7


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
    $ npm init
    $ npm install express --save

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


MEAN.IO Stack
-------------

We're going to follow http://learn.mean.io/ to get started.

``MEAN`` requires ``mongodb`` running, you need to follow :ref:`MongoDB Guide <databases-guide-mongodb>`.


..  code-block:: bash

    $ ws
    $ cd personal
    $ npm install -g mean-cli
    $ mean init mean-app
    $ cd mean-app
    $ npm install

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

..  _nvm: https://github.com/creationix/nvm
