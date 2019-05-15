# teracy-dev docs

Follow this guide to work on the docs, both locally or remotely.

## Local k8s cluster

### Prerequisites

- `docker-registry` must be available by following
  https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/docker-registry.md.

- `docker daemon remote access` must be available by following
   https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/docker-daemon-remote-access.md.

- `kubectl`, `helm` must be installed on your host machine by following https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/how-to-install-kubectl-helm.md.

- `skaffold`, `docker cli` must be installed on your host machine and make sure it works
  with the k8s cluster:
  + https://skaffold.dev/docs/getting-started/#installing-skaffold

### Set the default-repo for Skaffold

```bash
$ skaffold config set default-repo registry.k8s.local
```

### Use the `docker daemon remote access`

- To access the docker daemon remotely:

```
$ export DOCKER_HOST="tcp://k8s.local:2375"
```
### Override.yaml

- Create the `teracy-dev/docs/override.yaml` file with the following content:

```yaml
ingress:
  annotations:
    certmanager.k8s.io/cluster-issuer: ca-cluster-issuer
```

### Skaffold dev mode

- Execute the following commands:

```bash
$ cd docs
$ skaffold dev
```

- You should see the following output:

```bash
Generating tags...
 - registry.k8s.local/teracy_teracy-dev-docs-dev -> registry.k8s.local/teracy_teracy-dev-docs-dev:v0.6.0-a6-59-ge9cbde7-dirty
Tags generated in 167.7501ms
Starting build...
Building [registry.k8s.local/teracy_teracy-dev-docs-dev]...
Sending build context to Docker daemon  2.809MB
Step 1/8 : ARG PYTHON_VERSION=3.7
Step 2/8 : FROM python:$PYTHON_VERSION
 ---> a4cc999cf2aa
Step 3/8 : RUN mkdir -p /opt/app
 ---> Using cache
 ---> ccdcbde9855c
Step 4/8 : ENV TERM=xterm-256color APP=/opt/app
 ---> Using cache
 ---> 15f8a09b85bd
Step 5/8 : WORKDIR $APP
 ---> Using cache
 ---> 2997a527c963
Step 6/8 : ADD requirements.txt $APP/
 ---> Using cache
 ---> edb983c03351
Step 7/8 : RUN pip install -r requirements.txt
 ---> Using cache
 ---> 555d149e06dd
Step 8/8 : ADD . $APP
 ---> bcc552e9d9da
Successfully built bcc552e9d9da
Successfully tagged registry.k8s.local/teracy_teracy-dev-docs-dev:v0.6.0-a6-59-ge9cbde7-dirty
The push refers to repository [registry.k8s.local/teracy_teracy-dev-docs-dev]
c5ced33b2163: Preparing
46157e0e3561: Preparing
8cf96f5456c2: Preparing
0c889a1a4038: Preparing
2633623f6cf4: Preparing
5194c23c2bc2: Preparing
69bbfe9f27d4: Preparing
2492a3be066b: Preparing
910d7fd9e23e: Preparing
4230ff7f2288: Preparing
2c719774c1e1: Preparing
ec62f19bb3aa: Preparing
f94641f1fe1f: Preparing
2492a3be066b: Waiting
910d7fd9e23e: Waiting
4230ff7f2288: Waiting
2c719774c1e1: Waiting
ec62f19bb3aa: Waiting
f94641f1fe1f: Waiting
5194c23c2bc2: Waiting
69bbfe9f27d4: Waiting
0c889a1a4038: Layer already exists
2633623f6cf4: Layer already exists
46157e0e3561: Layer already exists
5194c23c2bc2: Layer already exists
8cf96f5456c2: Layer already exists
2492a3be066b: Layer already exists
69bbfe9f27d4: Layer already exists
2c719774c1e1: Layer already exists
910d7fd9e23e: Layer already exists
ec62f19bb3aa: Layer already exists
4230ff7f2288: Layer already exists
f94641f1fe1f: Layer already exists
c5ced33b2163: Pushed
v0.6.0-a6-59-ge9cbde7-dirty: digest: sha256:1522b7839bb42c15bbd2f4898cc43e7dee1afc7d06d0b9ea41434db6f97dcfc8 size: 3055
Build complete in 5.179062043s
Starting test...
Test complete in 46.789µs
Starting deploy...
Error: release: "teracy-dev-docs-dev" not found
Helm release teracy-dev-docs-dev not installed. Installing...
No requirements found in helm-charts/teracy-dev-docs-dev/charts.
NAME:   teracy-dev-docs-dev
LAST DEPLOYED: Tue May 14 19:14:22 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Pod(related)
NAME                                  READY  STATUS             RESTARTS  AGE
teracy-dev-docs-dev-65d7784578-dsrjz  0/1    ContainerCreating  0         0s

==> v1/Service
NAME                 TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)   AGE
teracy-dev-docs-dev  ClusterIP  10.233.47.124  <none>       8000/TCP  0s

==> v1beta1/Ingress
NAME                 HOSTS                      ADDRESS  PORTS  AGE
teracy-dev-docs-dev  dev.docs.teracy-dev.local  80, 443  0s

==> v1beta2/Deployment
NAME                 READY  UP-TO-DATE  AVAILABLE  AGE
teracy-dev-docs-dev  0/1    0           0          0s


NOTES:
1. Get the application URL by running these commands:
  https://dev.docs.teracy-dev.local/

Deploy complete in 2.239619778s
Watching for changes every 1s...
Port Forwarding teracy-dev-docs-dev-65d7784578-dsrjz/docs 8000 -> 8000
[teracy-dev-docs-dev-65d7784578-dsrjz docs] sphinx-autobuild -b html -d _build/doctrees   . _build/html -H 0.0.0.0 --port 8000
[teracy-dev-docs-dev-65d7784578-dsrjz docs] /opt/app/getting_started.rst:71: WARNING: Definition list ends without a blank line; unexpected unindent.
[teracy-dev-docs-dev-65d7784578-dsrjz docs] /opt/app/release.rst: WARNING: document isn't included in any toctree
[teracy-dev-docs-dev-65d7784578-dsrjz docs] WARNING: favicon file 'favicon.png' does not exist
[teracy-dev-docs-dev-65d7784578-dsrjz docs] [I 190514 12:14:32 server:296] Serving on http://0.0.0.0:8000
[teracy-dev-docs-dev-65d7784578-dsrjz docs] [I 190514 12:14:32 handlers:62] Start watching changes
[teracy-dev-docs-dev-65d7784578-dsrjz docs] [I 190514 12:14:32 handlers:64] Start detecting changes
```

- Open http://localhost:8000 to work on the docs, you can edit any .rst files and the docs site will
reload automatically.


### Domain Alias

- Configure the domain alias by editing the `k8s-dev/workspace/teracy-dev-entry/config_override.yaml`
with the configuration below:

```yaml
nodes:
  - _id: "0"
    plugins:
      - _id: "entry-hostmanager"
        options:
          _ua_aliases: # set domain aliases for the master node
            - dev.docs.teracy-dev.local
```

- `$ vagrant hostmanger` to get the `hosts` file updated in the host and the guest machines.

- Make sure to trust the root CA certificate by following https://github.com/teracyhq-incubator/teracy-dev-certs#how-to-trust-the-self-signed-ca-certificate

- Open https://dev.docs.teracy-dev.local/ to work on the docs, you can edit any .rst files and the
  docs site will reload automatically.


## Remote k8s cluster


### Prerequisites

- You have push permission to a docker registry, for example, docker hub or google container registry, etc.

- `kubectl`, `helm`, `skaffold`, `docker` must be installed on your host machine and make sure it works
  with the k8s cluster.

- `cert-manager`, `external-dns` must be installed (ask your k8s admin):
  + https://cert-manager.readthedocs.io/en/latest/
  + https://github.com/helm/charts/tree/master/stable/external-dns


### Install `helm` within your namespace

- For example, to install within the `hoatle` namespace:

```bash
$ kubectl create serviceaccount tiller --namespace=hoatle
$ kubectl -n hoatle create rolebinding tiller-admin --clusterrole=admin --serviceaccount=hoatle:tiller
$ helm init --tiller-namespace=hoatle --service-account=tiller
$ helm version --tiller-namespace=hoatle
```

### Set the default-repo for Skaffold

- The best practice is to work on a specific namespace, for example, `hoatle` in this tutorial,
  you need to replace with yours.

- Set to the right registry that you have access (pull/push) permission:

```bash
$ skaffold config set default-repo <registry>
```

- For example:

```bash
$ skaffold config set default-repo docker.io/hoatle # your docker hub username
$ # or
$ skaffold config set default-repo gcr.io/teracy/hoatle # your google container registry path
```

### Create the `letsencrypt` issuer

- Create the `teracy-dev/docs/letsencrypt-issuer.yaml` file to create an certificate issuer
  for the ingress with the following content:

```yaml
apiVersion: certmanager.k8s.io/v1alpha1
kind: Issuer
metadata:
 name: letsencrypt
spec:
 acme:
   # The ACME server URL
   server: https://acme-v02.api.letsencrypt.org/directory
   # Email address used for ACME registration
   email: hoatlevan@gmail.com # replace this with your email
   # Name of a secret used to store the ACME account private key
   privateKeySecretRef:
     name: letsencrypt
   # Enable the HTTP-01 challenge provider
   http01: {}
  ```

- Make sure to replace the email value with yours.

- Apply it to the k8s cluster:

```bash
$ cd teracy-dev/docs/
$ kubectl apply -f letsencrypt-issuer.yaml --namespace=hoatle
issuer.certmanager.k8s.io/letsencrypt created
```

- You should see the similar output below:

```bash
$ kubectl -n hoatle describe issuers.certmanager.k8s.io letsencrypt 
Name:         letsencrypt
Namespace:    hoatle
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"certmanager.k8s.io/v1alpha1","kind":"Issuer","metadata":{"annotations":{},"name":"letsencrypt","namespace":"hoatle"},"spec"...
API Version:  certmanager.k8s.io/v1alpha1
Kind:         Issuer
Metadata:
  Creation Timestamp:  2019-05-10T08:34:18Z
  Generation:          1
  Resource Version:    1184404
  Self Link:           /apis/certmanager.k8s.io/v1alpha1/namespaces/hoatle/issuers/letsencrypt
  UID:                 66f34250-72fe-11e9-ab41-42010a800013
Spec:
  Acme:
    Email:  hoatlevan@gmail.com
    Http 01:
    Private Key Secret Ref:
      Name:  letsencrypt
    Server:  https://acme-v02.api.letsencrypt.org/directory
Status:
  Acme:
    Uri:  https://acme-v02.api.letsencrypt.org/acme/acct/56788516
  Conditions:
    Last Transition Time:  2019-05-10T08:34:19Z
    Message:               The ACME account was registered with the ACME server
    Reason:                ACMEAccountRegistered
    Status:                True
    Type:                  Ready
Events:                    <none>
```

### Override.yaml

- Create the `teracy-dev/docs/override.yaml` file with the following similar content:

```yaml
ingress:
  annotations:
    certmanager.k8s.io/issuer: letsencrypt
  path: /
  hosts:
    - dev.teracy-dev-docs.hoatle.terapp.com # replace with yours
  tls:
   - secretName: dev-teracy-dev-docs-hoatle-terapp-com-tls # replace with yours
     hosts:
       - dev.teracy-dev-docs.hoatle.terapp.com # replace with yours
```

- Make sure to fill in the right allowed domains from the `external-dns` (ask the k8s admin).


### Skaffold dev mode

- Execute the following commands:

```bash
$ cd docs
$ TILLER_NAMESPACE=hoatle skaffold dev --namespace=hoatle # specify your k8s and tiller namespace here
```

- You should see the following similar output:

```bash
Generating tags...
 - docker.io/hoatle/teracy_teracy-dev-docs-dev -> docker.io/hoatle/teracy_teracy-dev-docs-dev:v0.6.0-a6-59-ge9cbde7-dirty
Tags generated in 48.761688ms
Starting build...
Building [docker.io/hoatle/teracy_teracy-dev-docs-dev]...
Sending build context to Docker daemon  2.811MB
Step 1/8 : ARG PYTHON_VERSION=3.7
Step 2/8 : FROM python:$PYTHON_VERSION
 ---> 32260605cf7a
Step 3/8 : RUN mkdir -p /opt/app
 ---> Using cache
 ---> 5781d3cf82fd
Step 4/8 : ENV TERM=xterm-256color APP=/opt/app
 ---> Using cache
 ---> 6b1a298cc237
Step 5/8 : WORKDIR $APP
 ---> Using cache
 ---> 4e06705a28de
Step 6/8 : ADD requirements.txt $APP/
 ---> 1248b80daa7a
Step 7/8 : RUN pip install -r requirements.txt
 ---> Running in ef38dd27dc76
Collecting git+https://github.com/hoatle/python-livereload.git#master (from -r requirements.txt (line 8))
Successfully installed Jinja2-2.10.1 MarkupSafe-1.1.1 PyYAML-5.1 Pygments-2.4.0 Sphinx-2.0.1 alabaster-0.7.12 argh-0.26.2 babel-2.6.0 certifi-2019.3.9 chardet-3.0.4 docutils-0.14 idna-2.8 imagesize-1.1.0 livereload-2.6.1 packaging-19.0 pathtools-0.1.2 port-for-0.3.1 pyparsing-2.4.0 pytz-2019.1 requests-2.21.0 six-1.12.0 snowballstemmer-1.2.1 sphinx-autobuild-0.7.1 sphinxcontrib-applehelp-1.0.1 sphinxcontrib-devhelp-1.0.1 sphinxcontrib-htmlhelp-1.0.2 sphinxcontrib-jsmath-1.0.1 sphinxcontrib-qthelp-1.0.2 sphinxcontrib-serializinghtml-1.1.3 tornado-6.0.2 urllib3-1.24.3 watchdog-0.9.0
You are using pip version 19.0.3, however version 19.1.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
Removing intermediate container ef38dd27dc76
 ---> 0dbf677e60d3
Step 8/8 : ADD . $APP
 ---> d443c4818346
Successfully built d443c4818346
Successfully tagged hoatle/teracy_teracy-dev-docs-dev:v0.6.0-a6-59-ge9cbde7-dirty
The push refers to repository [docker.io/hoatle/teracy_teracy-dev-docs-dev]
58ab309ede73: Preparing
3443d6cf0f1f: Layer already exists
fc8f67cdb864: Pushed
v0.6.0-a6-59-ge9cbde7-dirty: digest: sha256:2ae5bbc4903300229bfc687aa949dcee4c43b9f960a2a53f9a638b6c4475fe6a size: 3055
Build complete in 4m30.202053973s
Starting test...
Test complete in 10.695µs
Starting deploy...
Error: release: "teracy-dev-docs-dev" not found
Helm release teracy-dev-docs-dev not installed. Installing...
No requirements found in helm-charts/teracy-dev-docs-dev/charts.
NAME:   teracy-dev-docs-dev
LAST DEPLOYED: Tue May 14 20:33:52 2019
NAMESPACE: hoatle
STATUS: DEPLOYED

RESOURCES:
==> v1/Pod(related)
NAME                                  READY  STATUS             RESTARTS  AGE
teracy-dev-docs-dev-7f848d588d-vmjt2  0/1    ContainerCreating  0         0s

==> v1/Service
NAME                 TYPE       CLUSTER-IP   EXTERNAL-IP  PORT(S)   AGE
teracy-dev-docs-dev  ClusterIP  10.55.241.8  <none>       8000/TCP  0s

==> v1beta1/Ingress
NAME                 HOSTS                                  ADDRESS  PORTS  AGE
teracy-dev-docs-dev  dev.teracy-dev-docs.hoatle.terapp.com  80, 443  0s

==> v1beta2/Deployment
NAME                 READY  UP-TO-DATE  AVAILABLE  AGE
teracy-dev-docs-dev  0/1    1           0          0s


NOTES:
1. Get the application URL by running these commands:
  https://dev.teracy-dev-docs.hoatle.terapp.com/

Deploy complete in 10.019875842s
Watching for changes every 1s...
Port Forwarding teracy-dev-docs-dev-7f848d588d-vmjt2/docs 8000 -> 8000
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] sphinx-autobuild -b html -d _build/doctrees   . _build/html -H 0.0.0.0 --port 8000
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] /opt/app/getting_started.rst:71: WARNING: Definition list ends without a blank line; unexpected unindent.
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] /opt/app/release.rst: WARNING: document isn't included in any toctree
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] WARNING: favicon file 'favicon.png' does not exist
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] [I 190514 13:34:03 server:296] Serving on http://0.0.0.0:8000
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] [I 190514 13:34:03 handlers:62] Start watching changes
[teracy-dev-docs-dev-7f848d588d-vmjt2 docs] [I 190514 13:34:03 handlers:64] Start detecting changes
```
- Open http://localhost:8000 to work on the docs, you can edit any .rst files and the docs site will
reload automatically.

- Open the configured host, for example, https://dev.teracy-dev-docs.hoatle.terapp.com/ to work on
  the docs, you can edit any .rst files and the docs site will reload automatically.


## References

- https://skaffold.dev/
