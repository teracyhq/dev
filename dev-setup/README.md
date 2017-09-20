# Teracy-dev-setup

Please follow this getting started guide to set up the development environment.

Please take a cup of coffee with you, you mostly don't have to do anything but wait for the result, enjoy!


## Getting Started

- Please follow the document at https://github.com/teracyhq/dev-setup/blob/develop/README.md to set up teracy-dev and dev-setup.


## Setting up the teracy-dev app

Stop the watching files by using `Ctrl + c`.

- We use `teracy-dev` to develop `teracy-dev`. Because of that, you need to fork this repo into your github account, and rename it to `dev`.

- Clone the forked repo into the `~/teracy-dev/workspace` directory.

    ```bash
    $ cd ~/teracy-dev/workspace/
    $ git clone <your_forked_repository_here> dev
    $ cd dev
    $ git remote add upstream git@github.com:teracyhq/dev.git
    ```

- Add the configuration path below to the `teracyhq/dev-setup/vagrant_config_default.json`, if it does not exist yet. It should look like similar to this:

    ```bash
    "config_paths": [ // add paths of json config files to be loaded
      // the path must be relative to the Vagrantfile
      "workspace/dev/dev-setup/vagrant_config_default.json"
    ]
    ```

- Note that you should always sync the `dev-setup` repository along with `teracy-dev`. After changed, `$ vagrant reload --provision` should get the new configuration updated into the VM. Or `$ vagrant destroy` and `$ vagrant up` should set up the new VM from scratch for you.


- Reload the Vagrant box to make sure it's updated:

    ```bash
    $ cd ~/teracy-dev
    $ vagrant reload --provision
    ```

- After finishing running (take a long time to set everything up for the first time), you should
  see the following similar output:

    ```bash
    ==> default: Chef Client finished, 10/41 resources updated in 55 seconds
    ==> default: Running provisioner: ip (shell)...
    default: Running: /var/folders/qt/y8zzc9wx3q55lw0b5dlh1j0m0000gn/T/vagrant-shell20170923-2377-  1miulou.sh
    ==> default: ip address: 192.168.0.696
    ==> default: vagrant-gatling-rsync is starting the sync engine because you have at least one rsync folder. To disable this behavior, set `config.gatling.rsync_on_startup = false` in your Vagrantfile.
    ==> default: Doing an initial rsync...
    ==> default: Rsyncing folder: /Users/god_of_destruction/teracy-dev/workspace/ => /home/vagrant/workspace
    ==> default:   - Exclude: [".vagrant/", ".git", ".idea/", "node_modules/", "bower_components/", ".npm/", ".#*", "docs/_build"]
    ==> default: Watching: /Users/god_of_destruction/teracy-dev/workspace
    ```


## How to work with docs

- Make sure the ``/etc/hosts`` file get updated automatically with the following commands:

    ```bash
    $ cd ~/teracy-dev
    $ vagrant hostmanager
    ```

- `$ ping dev.dev-docs.teracy.dev` to make sure it pings to the right IP address of the VM:
   http://dev.teracy.org/docs/basic_usage.html#ip-address.

- `$ cat /etc/hosts` file from the host machine to make sure there are no duplicated entries for
  `teracy-dev` or the VM IP address.

- SSH into the VM to make sure the docs app is ready by checking the docker logs output:

    ```bash
    $ vagrant ssh
    $ ws
    $ cd dev/docs
    $ docker-compose logs -f
    ```

- Or you can use this shorthand command:

    ```bash
    $ vagrant ssh -c "cd workspace/dev/docs && docker-compose logs -f"
    ```

- Wait for the logs running until you see the following similar output:

    ```bash
    app-dev_1    | Successfully built tornado port-for pathtools PyYAML watchdog MarkupSafe
    app-dev_1    | Installing collected packages: sphinxcontrib-websupport, pytz, babel, imagesize, typing, Pygments, idna, urllib3, certifi, chardet, requests, six, docutils, alabaster, MarkupSafe, Jinja2, snowballstemmer, Sphinx, port-for, singledispatch, backports-abc, tornado, pathtools, livereload, PyYAML, argh, watchdog, sphinx-autobuild
    app-dev_1    |   Running setup.py install for livereload: started
    app-dev_1    |     Running setup.py install for livereload: finished with status 'done'
    app-dev_1    | Successfully installed Jinja2-2.9.6 MarkupSafe-1.0 PyYAML-3.12 Pygments-2.2.0 Sphinx-1.6.3 alabaster-0.7.10 argh-0.26.2 babel-2.5.1 backports-abc-0.5 certifi-2017.7.27.1 chardet-3.0.4 docutils-0.14 idna-2.6 imagesize-0.7.1 livereload-2.5.1 pathtools-0.1.2 port-for-0.3.1 pytz-2017.2 requests-2.18.4 singledispatch-3.4.0.3 six-1.11.0 snowballstemmer-1.2.1 sphinx-autobuild-0.7.1 sphinxcontrib-websupport-1.0.1 tornado-4.5.2 typing-3.6.2 urllib3-1.22 watchdog-0.8.3
    app-dev_1    | sphinx-autobuild -b html -d _build/doctrees   . _build/html -H 0.0.0.0
    ```


Then open:

- http://dev.dev-docs.teracy.dev or https://dev.dev-docs.teracy.dev to check out
  the docs within your host machine.

- http://dev.dev-docs.<vm_ip>.xip.io to check out the docs within your LAN network.

- http://ngrok-dev.dev-docs.teracy.dev to check out the docs on the Internet.


### Local dev mode docs

```bash
$ vagrant ssh
$ ws
$ cd dev/docs
$ docker-compose up -d && docker-compose logs -f
```

Open http://dev.dev-docs.teracy.dev and edit docs files, it should auto reload when new
changes are detected.


### Local prod mode docs

```bash
$ vagrant ssh
$ ws
$ cd dev/docs
$ docker-compose -f docker-compose.prod.yml build
$ docker-compose -f docker-compose.prod.yml up
```


Then open:

- http://dev-docs.teracy.dev or https://dev-docs.teracy.dev to check out
  the docs within your host machine.

- http://dev-docs.<vm_ip>.xip.io to check out the docs within your LAN network.

- http://ngrok-prod.dev-docs.teracy.dev to check out the docs on the Internet.


### Local review mode docs

To review work and PRs submitted by others, for example, with
`hoatle/teracy-dev-docs:improvements-176-teracy-dev-docs-guide` Docker image, run the commands below:


```bash
$ vagrant ssh
$ ws
$ cd flask-classful/docs
$ APP_REVIEW_IMAGE=hoatle/teracy-dev-docs:improvements-176-teracy-dev-docs-guide docker-compose -f docker-compose.review.yml up
```


Then open:

- http://review.dev-docs.teracy.dev or https://review.dev-docs.teracy.dev to
  check out the docs within your host machine.

- http://review.dev-docs.<vm_ip>.xip.io to check out the docs within your LAN network.

- http://ngrok-review.dev-docs.teracy.dev to check out the docs on the Internet.


## travis-ci configuration

You just need to configure travis-ci only one time. After each travis-ci build, new Docker images
are pushed, we can review your work (PR) by running the Docker images instead of fetching git code
and build it on local ourselves.

Here are things you need to do:

- Register your account at https://hub.docker.com.
- Register your account at travis-ci.org.
- Enable the teracy-dev repository on travis-ci (for example: https://travis-ci.org/hoatle/teracy-dev).
- Fill in the following environment variables settings for the teracy-dev travis-ci project by
  following: https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings.
  In the *Name* and *Value* fields, please add the info below correlatively:

  + Fill in "DOCKER_USERNAME" into the *Name* field, and your Docker username into the *Value* field.
  + Fill in "DOCKER_PASSWORD" into the *Name* field, and your Docker password into the *Value* field.
  + Fill in "DEV_DOCKER_IMAGE" into the *Name* field, and your repo name for https://hub.docker.com
    into the *Value*, for example, "hoatle/teracy-dev" (so that to create https://hub.docker.com/r/hoatle/teracy-dev/).
  + Fill in "DOCS_DOCKER_IMAGE" into the *Name* field, and your repo name for https://hub.docker.com
    into the *Value*, for example, "hoatle/teracy-dev-docs" (so that to create https://hub.docker.com/r/hoatle/teracy-dev-docs/).
  + Fill in "GH_REPO" into the *Name* field, and your github username, for example, fill with <your_github_username>/dev> to git push on your repo.
  + Fill in "GH_TOKEN" into the *Name* field, and your github token, for example, fill with <your_github_personal_access_token> to git push on your repo.

And you're done!

## How to start working

- Learn how to work with teracy-dev:

  + http://dev.teracy.org/docs/basic_usage.html
  + http://dev.teracy.org/docs/advanced_usage.html

- Learn how to work with docker and docker-compose:

  + https://www.docker.com/
  + https://github.com/veggiemonk/awesome-docker

- You can use any text editor or IDE to edit the project files at `~/teracy-dev/workspace/flask-classful`.

## Tips


- How to access into the container ssh session:

  ```bash
  $ docker exec -it <CONTAINER ID> /bin/bash
  root@a76ec196be06:/opt/app#
  ```
