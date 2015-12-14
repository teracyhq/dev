Ruby Development Guide
======================

By default, ``teracy-dev`` already has Ruby installed for the default base box.


Verify that ``ruby`` works
--------------------------

..  code-block:: bash

    $ vagrant ssh
    $ ruby --version

And you should see something like this:

..  code-block:: bash

    ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-linux]

Congratulations, you can do all ``Ruby`` related stuff now!


Ruby on Rails (RoR) Development
-------------------------------

This guide is based on: http://rubyonrails.org/download/

As ``Ruby`` is already installed along with ``rbenv``, you could start using ``Ruby`` right away.

#.  Install ``Rails``

    ..  code-block:: bash

        $ vagrant ssh
        $ gem install rails
        $ rbenv rehash

    .. note::
       `rehash` is required by `rbenv`

#.  Verify ``Rails``

    ..  code-block:: bash

        $ rails --version
        Rails 4.2.1

#.  Create a new RoR app

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ rails new rails-app
        $ cd rails-app
        $ rails server -b 0.0.0.0

    ..  tip::
        ``-b 0.0.0.0`` here is to make ``Rails`` app accept requests from any ip addresses. Required
        for Vagrant box with forward ports.

    And you should see the output like:

    ..  code-block:: bash

        => Booting WEBrick
        => Rails 4.2.5 application starting in development on http://0.0.0.0:3000
        => Run `rails server -h` for more startup options
        => Ctrl-C to shutdown server
        [2015-12-14 08:54:53] INFO  WEBrick 1.3.1
        [2015-12-14 08:54:53] INFO  ruby 2.2.3 (2015-08-18) [x86_64-linux]
        [2015-12-14 08:54:53] INFO  WEBrick::HTTPServer#start: pid=10837 port=3000


    Open the browser at http://localhost:3000 and you should see `Welcome aboard` default page.
    We're ready for RoR development by following http://rubyonrails.org/documentation/

#.  Databases

    ..  todo::
        We need to update this section

#.  RoR with Heroku

    ..  todo::
        We need to update this section

Sinatra Development
-------------------

This guide is based on: http://www.sinatrarb.com/

#.  Create ``Sinatra`` web app

    Create web app directory:

    ..  code-block:: bash

        $ ws
        $ cd personal
        $ mkdir sinatra-app
        $ cd sinatra-app

    And then create ``hi.rb`` file with the following content within ``sinatra-app`` directory:

    ..  code-block:: ruby

        require 'sinatra'

        get '/hi' do
          "Hello World!"
        end

        set :bind, '0.0.0.0'

    ..  tip::
        ``set :bind, '0.0.0.0'`` here is to make ``Sinatra`` app accept requests from any ip
        addresses. Required for Vagrant box with forward ports.

#.  Run the ``Sinatra`` web app

    ..  code-block:: bash

        $ gem install sinatra
        $ ruby hi.rb

    Now open http://localhost:4567/hi on your browser to see the web app.

References
----------
- https://github.com/sstephenson/rbenv
- http://rubyonrails.org
- https://devcenter.heroku.com/articles/getting-started-with-rails4
- http://www.sinatrarb.com/


