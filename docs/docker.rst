Docker
======

We leverage Docker for our software development.

When ``$ vagrant up``, it's expected that ``docker`` and ``docker-compose`` should be installed within
the VM and ready to be used:

..  code-block:: bash

    $ vagrant ssh
    vagrant@vagrant:~$ docker version
    Client:
     Version:      1.12.3
     API version:  1.24
     Go version:   go1.6.3
     Git commit:   6b644ec
     Built:        Wed Oct 26 22:01:48 2016
     OS/Arch:      linux/amd64

    Server:
     Version:      1.12.3
     API version:  1.24
     Go version:   go1.6.3
     Git commit:   6b644ec
     Built:        Wed Oct 26 22:01:48 2016
     OS/Arch:      linux/amd64


docker-machine
--------------

Sometimes, we want to control the Docker VM with `docker-machine` from our host machine. Then do this:

..  code-block:: bash

    $ cd ~/teracy-dev
    $ docker-machine create -d generic \
    --generic-ssh-user vagrant \
    --generic-ssh-key .vagrant/machines/default/virtualbox/private_key \
    --generic-ip-address <vm_ip_address> teracy-dev

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


Debugging
---------

#. Node.js

- node-inspector at: http://<vm_ip_address>:8080/?port=5858
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
