Docker
======

We're using Docker for teracy-dev.

When ``$ vagrant up``, it's expected that ``docker`` and ``docker-compose`` should be installed within
the VM and ready to use:

..  code-block:: bash

    vagrant@teracy-dev:~$ docker version
    Client:
     Version:      1.11.1
     API version:  1.23
     Go version:   go1.5.4
     Git commit:   5604cbe
     Built:        Tue Apr 26 23:30:23 2016
     OS/Arch:      linux/amd64

    Server:
     Version:      1.11.1
     API version:  1.23
     Go version:   go1.5.4
     Git commit:   5604cbe
     Built:        Tue Apr 26 23:30:23 2016
     OS/Arch:      linux/amd64


Before we have auto provision ``docker-compose`` and the ``bash-completion``, follow these commands:

..  code-block:: bash

    $ vagrant ssh
    $ sudo -i
    # curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    # chmod +x /usr/local/bin/docker-compose
    # curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
    # curl -L https://raw.githubusercontent.com/docker/docker/v1.11.1/contrib/completion/bash/docker > /etc/bash_completion.d/docker
    # exit
    $ exit
    $ vagrant ssh

and we should have ``docker-compose``, ``docker``, and bash auto-completion for these two.

..  todo::

    //TODO(hoatle): install `docker-compose` automatically
    //TODO(hoatle): add vagrant to docker group to avoid having to use `sudo docker`
    //TODO(hoatle): add auto-completion for `docker` and `docker-compose`

docker-machine
--------------

Sometimes, we want to control the Docker VM with `docker-machine` from our host machine. Then do this:

..  code-block:: bash

    $ cd teracy-dev
    $ docker-machine create -d generic \
    --generic-ssh-user vagrant \
    --generic-ssh-key .vagrant/machines/default/virtualbox/private_key \
    --generic-ip-address 192.168.99.101 teracy-dev

And then you should see something like:

..  code-block:: bash

    Running pre-create checks...
    Creating machine...
    (teracy-dev) Importing SSH key...
    Waiting for machine to be running, this may take a few minutes...
    Detecting operating system of created instance...
    Waiting for SSH to be available...
    Detecting the provisioner...
    Provisioning with ubuntu(upstart)...
    Installing Docker...
    Copying certs to the local machine directory...
    Copying certs to the remote machine...
    Setting Docker configuration on the remote daemon...
    Checking connection to Docker...
    Docker is up and running!
    To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env teracy-dev
    hoatle-mbp:teracy-dev hoatle$ docker-machine env teracy-dev
    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://192.168.99.101:2376"
    export DOCKER_CERT_PATH="/Users/hoatle/.docker/machine/machines/teracy-dev"
    export DOCKER_MACHINE_NAME="teracy-dev"
    # Run this command to configure your shell:
    # eval $(docker-machine env teracy-dev)

Data Sync
---------

We use https://github.com/smerrill/vagrant-gatling-rsync for syncing from host to the VM, so make sure:

..  code-block:: bash

    $ vagrant plugin install vagrant-gatling-rsync


Note that this is only 1 way sync from host to the VM only, make changes to `workspace` directory
from the host machine then it should be synced to the VM.

To sync files from the VM back to the host workspace, make changes to `/vagrant/workspace` directory
from within the VM machine.

Debugging
---------

#. Node.js

- node-inspector at: http://192.168.99.101:8080/?port=5858
- remote js debug with IntelliJ: http://stackoverflow.com/a/23947664/1122198
    ..  code-block:: bash

        vagrant ssh -- -L 5858:127.0.0.1:5858


Related Resources
-----------------
- https://github.com/smerrill/vagrant-gatling-rsync
- https://github.com/veggiemonk/awesome-docker
- https://github.com/wsargent/docker-cheat-sheet
- https://github.com/chef-cookbooks/docker
- https://docs.docker.com/
