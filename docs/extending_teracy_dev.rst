Extending teracy-dev
====================

``teracy-dev`` is developed with the goal to keep it as minimal and extensible as possible. The
extension feature is so powerful that you can customize the VM in anyway you want.

You can extend ``teracy-dev``’s VM by your own choice of operating system and automate the
provisioning process by your own choice of configuration software. “The only limit is your
imagination” :–).

To extend ``teracy-dev``, you can use any kind of provisioners that are supported by ``vagrant``
(as ``teracy-dev`` is built on top of ``vagrant``), you can see more info here:
https://www.vagrantup.com/docs/provisioning/

We choose ``Chef`` as it’s our default provisioner because we have more years of usage experience.
We also intend to use ``Ansible`` for some future projects, too.

Let me show you how to extend it to work with ``Kubernetes``.

Make sure that you have ``teracy-dev`` running, if not, follow the :doc:`getting_started` guide first.

Make sure that you master the :doc:`basic_usage` and :doc:`advanced_usage` guides, too.


Installing ``ChefDK``
---------------------

To work with Chef cookbooks, we need to install ``ChefDK``. Fortunately, there is already an
available cookbook for us to use to install ``ChefDK`` automatically on our VM:
https://supermarket.chef.io/cookbooks/chef-dk


Usually, we have a ``dev-setup`` directory to extend ``teracy-dev``. The initial ``dev-setup`` content
should be like this: https://github.com/acme101/kubernetes-dev-setup/tree/0-initial

To install ``ChefDK``, we must install the ``chef-dk`` cookbook and use it as follows:

- Add ``depends 'chef-dk'`` to ``dev-setup/chef/main-cookbooks/acme/metadata.rb``

- Install vendor cookbooks with the following commands within the VM:

  ..  code-block:: bash

      $ vagrant ssh
      $ ws
      $ cd dev-setup/chef
      $ docker-compose up


- Sync back the changes from the VM to the host machine:

  ..  code-block:: bash

      $ vagrant rsync-back


The updated content should be like this: https://github.com/acme101/kubernetes-dev-setup/tree/1-dependency


Now, to install ``chef-dk``, just add the following Ruby code to ``default.rb`` recipe, it's never
so easy:

..  code-block:: bash

    chef_dk 'my_chef_dk' do
      global_shell_init true
      action :install
    end

Make sure you have ``berks-cookbooks`` paths that ``vagrant`` can look up. The configuration step
should be like this: https://github.com/acme101/kubernetes-dev-setup/tree/2-configuration

- After that, ``$ vagrant reload --provision`` and voila, you should have ``ChefDk`` installed.

  ..  code-block:: bash

      $ vagrant ssh
      $ chef --version
      Chef Development Kit Version: 1.4.3
      chef-client version: 12.19.36
      delivery version: master (41b94ffb5efd33723cf72a89bf4d273c8151c9dc)
      berks version: 5.6.4
      kitchen version: 1.16.0
      inspec version: 1.25.1

That's how we use Chef cookbooks to manage the VM's software automatically. You can do the same with
all other types of Chef cookbooks shared and opensourced from the public Chef Supermarket:
https://supermarket.chef.io/
You can use all the public shared cookbooks to do almost anything you want for your VM.

However, sometimes, there is not available cookbook that we want, then it's time we should
build new cookbooks from scratch.


Creating new ``Chef`` cookbooks
-------------------------------

From the steps above, we have ``ChefDK`` available to work with Chef cookbooks. To learn how to use it,
you can follow: https://github.com/chef/chef-dk

I already created the initial ``kubernetes-stack-cookbook`` that we can work with. You need to clone
the repo into the ``workspace`` directory:

..  code-block:: bash

    $ cd ~/teracy-dev/workspace
    $ git clone git@github.com:teracyhq-incubator/kubernetes-stack-cookbook.git

You can test the cookbook within the VM (``$ vagrant ssh``) with ``rspec``, ``kitchen`` easily:

..  code-block:: bash

    $ ws
    $ cd kubernetes-stack-cookbook/
    $ rspec

you should see the following similar content:

..  code-block:: bash

    kubernetes-stack::default
      When all attributes are default, on ubuntu 16.04
        converges successfully

    kubernetes-stack-test::gcloud_install_default
      When all attributes are default, on ubuntu 16.04
        converges successfully
        install gcloud

    kubernetes-stack-test::kubectl_install_default
      When all attributes are default, on ubuntu 16.04
        converges successfully
        install kubectl

    Finished in 1.35 seconds (files took 1.78 seconds to load)
    5 examples, 0 failures


    ChefSpec Coverage report generated...

      Total Resources:   7
      Touched Resources: 2
      Touch Coverage:    28.57%

    Untouched Resources:

      gcloud[install default gcloud]     kubernetes-stack-test/recipes/gcloud_install_default.rb:1
      execute[import google-cloud-sdk public key]   kubernetes-stack/resources/gcloud.rb:13
      apt_repository[google-cloud-sdk]   kubernetes-stack/resources/gcloud.rb:17
      bash[clean up the mismatched kubectl version]   kubernetes-stack/resources/kubectl.rb:20
      remote_file[/usr/local/bin/kubectl]   kubernetes-stack/resources/kubectl.rb:33


and to test with ``kitchen``:

..  code-block:: bash

    $ ws
    $ cd kubernetes-stack-cookbook/
    $ export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
    $ kitchen test


then you should see the following similar content:

..  code-block:: bash

    ...
    Starting Chef Client, version 13.2.7
    [2017-06-14T17:53:24+00:00] WARN: Plugin Network: unable to detect ipaddress
    resolving cookbooks for run list: ["kubernetes-stack-test::gcloud_install_default"]
    Synchronizing Cookbooks:
      - kubernetes-stack-test (0.1.0)
      - kubernetes-stack (0.1.0)
    Installing Cookbook Gems:
    Compiling Cookbooks...
    Converging 1 resources
    Recipe: kubernetes-stack-test::gcloud_install_default
      * gcloud[install default gcloud] action install
        * execute[import google-cloud-sdk public key] action run
          - execute curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
        * apt_repository[google-cloud-sdk] action add
          * execute[apt-cache gencaches] action nothing (skipped due to action :nothing)
          * apt_update[google-cloud-sdk] action nothing (skipped due to action :nothing)
          * file[/etc/apt/sources.list.d/google-cloud-sdk.list] action create
            - create new file /etc/apt/sources.list.d/google-cloud-sdk.list
            - update content in file /etc/apt/sources.list.d/google-cloud-sdk.list from none to 24ee22
            --- /etc/apt/sources.list.d/google-cloud-sdk.list 2017-06-14 17:53:25.296105380 +0000
            +++ /etc/apt/sources.list.d/.chef-google-cloud-sdk20170614-20-7wqkmu.list 2017-06-14 17:53:25.296105380 +0000
            @@ -1 +1,2 @@
            +deb      "http://packages.cloud.google.com/apt" cloud-sdk-xenial main
            - change mode from '' to '0644'
            - change owner from '' to 'root'
            - change group from '' to 'root'
          * execute[apt-cache gencaches] action run
            - execute apt-cache gencaches
          * apt_update[google-cloud-sdk] action update
            - force update new lists of packages
            * directory[/var/lib/apt/periodic] action create (up to date)
            * directory[/etc/apt/apt.conf.d] action create (up to date)
            * file[/etc/apt/apt.conf.d/15update-stamp] action create_if_missing
              - create new file /etc/apt/apt.conf.d/15update-stamp
              - update content in file /etc/apt/apt.conf.d/15update-stamp from none to 174cdb
              --- /etc/apt/apt.conf.d/15update-stamp  2017-06-14 17:53:26.136525380 +0000
              +++ /etc/apt/apt.conf.d/.chef-15update-stamp20170614-20-1r28edv 2017-06-14 17:53:26.136525380 +0000
              @@ -1 +1,2 @@
              +APT::Update::Post-Invoke-Success {"touch /var/lib/apt/periodic/update-success-stamp 2>/dev/null || true";};
            * execute[apt-get -q update] action run
              - execute apt-get -q update
          
        
        * apt_package[google-cloud-sdk] action install

          - install version 159.0.0-0 of package google-cloud-sdk
      

    Running handlers:
    Running handlers complete
    Chef Client finished, 9/13 resources updated in 55 seconds
           Finished converging <smoke-gcloud-ubuntu-1604> (1m0.97s).
    -----> Setting up <smoke-gcloud-ubuntu-1604>...
           Finished setting up <smoke-gcloud-ubuntu-1604> (0m0.00s).
    -----> Verifying <smoke-gcloud-ubuntu-1604>...
           Loaded tests from test/smoke/gcloud 

    Profile: tests from test/smoke/gcloud
    Version: (not specified)
    Target:  docker://16562c9afb7c00447169330fc584b442617a810f6b776d2eb6b78ce87d5d652f


      Command which
         ✔  gcloud exit_status should eq 0
         ✔  gcloud stdout should match "/usr/bin/gcloud"

    Test Summary: 2 successful, 0 failures, 0 skipped
           Finished verifying <smoke-gcloud-ubuntu-1604> (0m0.64s).
    -----> Destroying <smoke-gcloud-ubuntu-1604>...
           Deleting kitchen sandbox at /home/vagrant/.dokken/kitchen_sandbox/1000b8c847-smoke-gcloud-ubuntu-1604
           Deleting verifier sandbox at /home/vagrant/.dokken/verifier_sandbox/1000b8c847-smoke-gcloud-ubuntu-1604
           Finished destroying <smoke-gcloud-ubuntu-1604> (0m10.67s).
           Finished testing <smoke-gcloud-ubuntu-1604> (1m55.61s).
    -----> Kitchen is finished. (4m12.76s)


That's how we develop and test the cookbook on local dev.

You can see the cookbook here at https://github.com/teracyhq-incubator/kubernetes-stack-cookbook

It's currently a very simple cookbook to support the installation of `kubectl` and `gcloud`. In
the future, it will do more than that and support more platforms than current Ubuntu only.


Installing ``kubectl`` and ``gcloud``
-------------------------------------

The ``kubernetes-stack-cookbook`` is not available on the Chef Supermarket (yet), so to use it, we need
to install it from the github repo.

To install ``kubectl``, add this to the ``default.rb`` recipe:

..  code-block:: ruby

    kubectl 'install the latest kubectl'


To install ``gcloud``, add this to the ``default.rb`` recipe:

..  code-block:: ruby

    gcloud 'install the latest gcloud'

The configuration step should be like this:
https://github.com/acme101/kubernetes-dev-setup/tree/3-kubectl-gcloud-installation

After that, ``$ vagrant reload --provision`` and voila (again), you should have both of the packages installed.

..  code-block:: bash

    $ kubectl version
    Client Version: version.Info{Major:"1", Minor:"6", GitVersion:"v1.6.4", GitCommit:"d6f433224538d4f9ca2f7ae19b252e6fcb66a3ae", GitTreeState:"clean", BuildDate:"2017-05-19T18:44:27Z", GoVersion:"go1.7.5", Compiler:"gc", Platform:"linux/amd64"}
    The connection to the server localhost:8080 was refused - did you specify the right host or port?

..  code-block:: bash

    vagrant@teracy:~$ gcloud --version
    Google Cloud SDK 159.0.0
    alpha 2017.06.09
    beta 2017.06.09
    bq 2.0.24
    core 2017.06.09
    gcloud 
    gsutil 4.26


Summary
-------

Now you should know how to extend ``teracy-dev`` with Chef cookbooks, this is a very common task to do.
And other newcomer devs can just use your ``dev-setup`` without learning anything new, just follow
the instructions and learn more to master later.


References
----------

- http://blog.teracy.com/2017/06/15/how-to-extend-teracy-dev-to-work-with-kubernetes/
