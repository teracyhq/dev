# teracy-dev docs

Follow this guide to work on the docs, both locally or remotely.

## Local k8s cluster

### Prerequisites

- `docker-registry` must be available by following
  https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/docker-registry.md.

- `docker daemon remote access` must be available by following
   https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/docker-daemon-remote-access.md.

- `kubectl`, `helm` (v3) must be installed on your host machine by following https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/how-to-install-kubectl-helm.md.

- `skaffold` (>=1.5.0), `docker cli` must be installed on your host machine and make sure it works
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
    cert-manager.io/cluster-issuer: ca-cluster-issuer
  path: /
  hosts:
  - dev.teracy-dev-docs.teracy.local
  tls:
   - secretName: dev-teracy-dev-docs-teracy-local
     hosts:
     - dev.teracy-dev-docs.teracy.local
```

### Skaffold dev mode

- Execute the following commands:

```bash
$ cd docs
$ skaffold dev
```

- You should see the following output:

```bash
Listing files to watch...
 - teracy/teracy-dev-docs-dev
Generating tags...
 - teracy/teracy-dev-docs-dev -> registry.k8s.local/teracy_teracy-dev-docs-dev:b1948bb6d7b04b0c6e7e54e844235aaea3c40dc1-dirty
Checking cache...
 - teracy/teracy-dev-docs-dev: Found Remotely
Tags used in deployment:
 - teracy/teracy-dev-docs-dev -> registry.k8s.local/teracy_teracy-dev-docs-dev:b1948bb6d7b04b0c6e7e54e844235aaea3c40dc1-dirty@sha256:d34f287770125167fbdfa92c80b71a51f30b92bb99b4e4f7629be798e7530089
Starting deploy...
Release "teracy-dev-docs-dev" does not exist. Installing it now.
NAME: teracy-dev-docs-dev
LAST DEPLOYED: Wed Mar 11 02:11:41 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  https://dev.teracy-dev-docs.teracy.local/
Watching for changes...
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] sphinx-autobuild -b html -d _build/doctrees   . _build/html -H 0.0.0.0 --port 8000
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] WARNING: favicon file 'favicon.png' does not exist
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] /opt/app/release.rst: WARNING: document isn't included in any toctree
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] [I 200310 19:11:50 server:296] Serving on http://0.0.0.0:8000
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] [I 200310 19:11:50 handlers:62] Start watching changes
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] [I 200310 19:11:50 handlers:64] Start detecting changes
[teracy-dev-docs-dev-77b9f5d974-7qsxr docs] [I 200310 19:11:55 handlers:135] Browser Connected: https://dev.teracy-dev-docs.teracy.local/getting_started.html
```

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
            - dev.teracy-dev-docs.teracy.local
```

- `$ vagrant hostmanger` to get the `hosts` file updated in the host and the guest machines.

- Make sure to trust the root CA certificate by following https://github.com/teracyhq-incubator/teracy-dev-certs#how-to-trust-the-self-signed-ca-certificate

- Open https://dev.teracy-dev-docs.teracy.local to work on the docs, you can edit any .rst files and the
  docs site will reload automatically.


## Remote k8s cluster


### Prerequisites

- You have push permission to a docker registry, for example, docker hub or google container registry, etc.

- `kubectl`, `helm` (v3), `skaffold` (>=1.5.0), `docker` must be installed on your host machine and
  make sure it works with the k8s cluster.

- `cert-manager`, `external-dns` must be installed (ask your k8s admin):
  + https://cert-manager.readthedocs.io/en/latest/
  + https://github.com/helm/charts/tree/master/stable/external-dns


### Set your default namespace

k8s namespace is created by the admin by your (github) username with full permission. For convenience,
set your default k8s namespace:

```
$ kubectl config set-context --current --namespace=<your_namespace>
```

So later on, you don't have to specify `--namespace` anymore as it is already specified by default.


### Set the default-repo for Skaffold

- The best practice is to work on a specific namespace, for example, `hoatle` in this tutorial,
  you need to replace by yours.

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
apiVersion: cert-manager.io/v1alpha2
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
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
  ```

- Make sure to replace the email value with yours.

- Apply it to the k8s cluster:

```bash
$ cd teracy-dev/docs/
$ kubectl apply -f letsencrypt-issuer.yaml
issuer.certmanager.k8s.io/letsencrypt created
```

- You should see the similar output below:

```bash
$ kubectl describe issuers.cert-manager.io letsencrypt

Name:         letsencrypt
Namespace:    hoatle
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"cert-manager.io/v1alpha2","kind":"Issuer","metadata":{"annotations":{},"name":"letsencrypt","namespace":"hoatle"},"spec":{"...
API Version:  cert-manager.io/v1alpha2
Kind:         Issuer
Metadata:
  Creation Timestamp:  2020-01-11T18:53:17Z
  Generation:          1
  Resource Version:    134762426
  Self Link:           /apis/cert-manager.io/v1alpha2/namespaces/hoatle/issuers/letsencrypt
  UID:                 a0e55e46-34a3-11ea-9cf6-42010a800007
Spec:
  Acme:
    Email:  hoatlevan@gmail.com
    Private Key Secret Ref:
      Name:  letsencrypt
    Server:  https://acme-v02.api.letsencrypt.org/directory
    Solvers:
      http01:
        Ingress:
          Class:  nginx
Status:
  Acme:
    Last Registered Email:  hoatlevan@gmail.com
    Uri:                    https://acme-v02.api.letsencrypt.org/acme/acct/56788516
  Conditions:
    Last Transition Time:  2020-01-11T18:53:17Z
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
    cert-manager.io/issuer: letsencrypt
  path: /
  hosts:
    - dev.teracy-dev-docs.hoatle.terapp.com # replace by yours
  tls:
   - secretName: dev-teracy-dev-docs-hoatle-terapp-com-tls # replace by yours
     hosts:
       - dev.teracy-dev-docs.hoatle.terapp.com # replace by yours
```

- Make sure to fill in the right allowed domains from the `external-dns` (ask the k8s admin).


### Skaffold dev mode

- Execute the following commands:

```bash
$ cd docs
$ skaffold dev
```

- You should see the following similar output:

```bash
Listing files to watch...
 - teracy/teracy-dev-docs-dev
Generating tags...
 - teracy/teracy-dev-docs-dev -> docker.io/hoatle/teracy_teracy-dev-docs-dev:b1948bb6d7b04b0c6e7e54e844235aaea3c40dc1-dirty
Checking cache...
 - teracy/teracy-dev-docs-dev: Not found. Building
Building [teracy/teracy-dev-docs-dev]...
Sending build context to Docker daemon  2.813MB
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
 ---> Using cache
 ---> e298eb4072cd
Step 7/8 : RUN pip install -r requirements.txt
 ---> Using cache
 ---> 27b16575a123
Step 8/8 : ADD . $APP
 ---> 578482a9741e
Successfully built 578482a9741e
Successfully tagged hoatle/teracy_teracy-dev-docs-dev:b1948bb6d7b04b0c6e7e54e844235aaea3c40dc1-dirty
The push refers to repository [docker.io/hoatle/teracy_teracy-dev-docs-dev]
660bf6bfac4e: Pushed 
936b0e81f75b: Layer already exists 
9221b02f6c77: Layer already exists 
6ee5cb4eed32: Layer already exists 
bb839e9783c7: Layer already exists 
237ce60325c6: Layer already exists 
1b976700da1f: Layer already exists 
bde41e1d0643: Layer already exists 
7de462056991: Layer already exists 
3443d6cf0f1f: Layer already exists 
f3a38968d075: Layer already exists 
a327787b3c73: Layer already exists 
5bb0785f2eee: Layer already exists 
b1948bb6d7b04b0c6e7e54e844235aaea3c40dc1-dirty: digest: sha256:692baf4e680c9ae9063892635460708aedb4171dbe2cca52db56f68c857fdef5 size: 3055
Tags used in deployment:
 - teracy/teracy-dev-docs-dev -> docker.io/hoatle/teracy_teracy-dev-docs-dev:b1948bb6d7b04b0c6e7e54e844235aaea3c40dc1-dirty@sha256:692baf4e680c9ae9063892635460708aedb4171dbe2cca52db56f68c857fdef5
Starting deploy...
Release "teracy-dev-docs-dev" does not exist. Installing it now.
NAME: teracy-dev-docs-dev
LAST DEPLOYED: Wed Mar 11 02:25:24 2020
NAMESPACE: hoatle
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  https://dev.teracy-dev-docs.hoatle.terapp.com/
Watching for changes...
[teracy-dev-docs-dev-68c9b7b9bb-hxrg7 docs] sphinx-autobuild -b html -d _build/doctrees   . _build/html -H 0.0.0.0 --port 8000
[teracy-dev-docs-dev-68c9b7b9bb-hxrg7 docs] WARNING: favicon file 'favicon.png' does not exist
[teracy-dev-docs-dev-68c9b7b9bb-hxrg7 docs] /opt/app/release.rst: WARNING: document isn't included in any toctree
[teracy-dev-docs-dev-68c9b7b9bb-hxrg7 docs] [I 200310 19:25:59 server:296] Serving on http://0.0.0.0:8000
[teracy-dev-docs-dev-68c9b7b9bb-hxrg7 docs] [I 200310 19:25:59 handlers:62] Start watching changes
[teracy-dev-docs-dev-68c9b7b9bb-hxrg7 docs] [I 200310 19:25:59 handlers:64] Start detecting changes
```

- Open the configured host, for example, https://dev.teracy-dev-docs.hoatle.terapp.com/ to work on
  the docs, you can edit any .rst files and the docs site will reload automatically.


## References

- https://skaffold.dev/
