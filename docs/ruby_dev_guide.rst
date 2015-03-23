Ruby Development Guide
======================

By default, ``teracy-dev`` already has Ruby installed for the default base box.


Verify that ``ruby`` works
--------------------------
::

    $ vagrant ssh
    $ ruby --version

And you should see something like this:
::

    ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-linux]

Congratulations, you can do all ``Ruby`` related stuff now!


Ruby on Rails (RoR) Development
-------------------------------

This guide is based on: http://rubyonrails.org/download/

As ``Ruby`` is already installed along with ``rbenv``, we could start using ``Ruby`` right away.

#.  Install ``Rails``
    ::

      $ vagrant ssh
      $ gem install rails
      $ rbenv rehash

    .. note::
       `rehash` is required by `rbenv`

#.  Verify ``Rails``
    ::

      $ rails --version
      Rails 4.2.1

#.  Create a new RoR app
    ::

      $ ws
      $ cd personal
      $ rails new rails-app
      $ cd rails-app
      $ rails server -b 0.0.0.0

    ..  tip::
        ``-b 0.0.0.0`` here is to make ``Rails`` app accept requests from any ip addresses.

    And we should see the output like:
    ::

      Warning: You're using Rubygems 1.8.23 with Spring. Upgrade to at least Rubygems 2.1.0 and run `gem pristine --all` for better startup performance.
      => Booting WEBrick
      => Rails 4.2.1 application starting in development on http://0.0.0.0:3000
      => Run `rails server -h` for more startup options
      => Ctrl-C to shutdown server
      [2015-03-20 09:14:58] INFO  WEBrick 1.3.1
      [2015-03-20 09:14:58] INFO  ruby 1.9.3 (2012-04-20) [x86_64-linux]
      [2015-03-20 09:14:58] INFO  WEBrick::HTTPServer#start: pid=15258 port=3000

    Open the browser at http://localhost:3000 and we should see `Welcome aboard` default page.
    We're ready for RoR development by following http://rubyonrails.org/documentation/

#.  Use Ruby 2.2.1 instead of default Ruby 1.9.3

    By default, Ruby 1.9.3 is used, however, it's very easy to use different versions of Ruby thanks
    to ``rbenv``. We're going to use Ruby 2.2.1 for RoR development.
    ::

      $ rbenv install 2.2.1
      $ rbenv local 2.2.1
      $ gem install rails
      $ rbenv rehash
      $ rails new rails-app2
      $ cd rails-app2
      $ rails server -b 0.0.0.0

    ..  tip::
        Create `.ruby-version` file with content `2.2.1` within `rails-app2` directory to use the
        right ruby version when `cd` to that directory.

    ..  todo::
        We'll support multiple Ruby versions via config by this
        issue: https://issues.teracy.org/browse/DEV-199

#.  Databases

    ..  todo::
        We need to update this section

#.  RoR with Heroku

    ..  todo::
        We need to update this section

Sinatra Development
-------------------

..  todo::
    Need to update this section

References
----------
- https://github.com/sstephenson/rbenv
- http://rubyonrails.org
- https://devcenter.heroku.com/articles/getting-started-with-rails4
- http://www.sinatrarb.com/


