# teracy-dev docs

Follow this guide to work on the docs

## Prerequisites

- `docker-registry` must be available by following https://github.com/teracyhq-incubator/teracy-dev-k8s/blob/develop/docs/docker-registry.md

- `docker`, `kubectl`, `helm`, `skaffold` must be installed on your host machine and make sure it works
  with the k8s cluster

## Set default-repo for Skaffold

```bash
$ skaffold config set default-repo registry.k8s.local
```

## Skaffold dev mode with kubectl

- Execute the following commands:

```bash
$ cd docs
$ skaffold dev
```

- You should see the following output:

```bash
Generating Tag for [registry.k8s.local/teracy_teracy-dev-docs-dev]...
Starting build...
Building [registry.k8s.local/teracy_teracy-dev-docs-dev]...
Sending build context to Docker daemon  2.804MB
Step 1/7 : ARG PYTHON_VERSION=3.7
Step 2/7 : FROM python:$PYTHON_VERSION
 ---> 32260605cf7a
Step 3/7 : RUN mkdir -p /opt/app
 ---> Using cache
 ---> 5781d3cf82fd
Step 4/7 : ENV TERM=xterm-256color APP=/opt/app
 ---> Using cache
 ---> 6b1a298cc237
Step 5/7 : ADD requirements.txt $APP/
 ---> Using cache
 ---> 9f17f48879c1
Step 6/7 : RUN cd $APP && pip install -r requirements.txt
 ---> Using cache
 ---> 52cfb162c7f2
Step 7/7 : ADD . $APP
 ---> fc19839f7f9f
Successfully built fc19839f7f9f
Successfully tagged registry.k8s.local/teracy_teracy-dev-docs-dev:a2115e0-dirty
The push refers to repository [registry.k8s.local/teracy_teracy-dev-docs-dev]
e9f834139e92: Preparing
a3443c79712d: Preparing
ad4d80495365: Preparing
6ee5cb4eed32: Preparing
bb839e9783c7: Preparing
237ce60325c6: Preparing
1b976700da1f: Preparing
bde41e1d0643: Preparing
7de462056991: Preparing
3443d6cf0f1f: Preparing
f3a38968d075: Preparing
a327787b3c73: Preparing
5bb0785f2eee: Preparing
237ce60325c6: Waiting
1b976700da1f: Waiting
bde41e1d0643: Waiting
7de462056991: Waiting
3443d6cf0f1f: Waiting
f3a38968d075: Waiting
a327787b3c73: Waiting
5bb0785f2eee: Waiting
6ee5cb4eed32: Layer already exists
a3443c79712d: Layer already exists
bb839e9783c7: Layer already exists
ad4d80495365: Layer already exists
237ce60325c6: Layer already exists
bde41e1d0643: Layer already exists
1b976700da1f: Layer already exists
7de462056991: Layer already exists
3443d6cf0f1f: Layer already exists
f3a38968d075: Layer already exists
a327787b3c73: Layer already exists
5bb0785f2eee: Layer already exists
e9f834139e92: Pushed
a2115e0-dirty: digest: sha256:5be1f1d9c7ea1736c38323601cef583b7422f6377b0fb9ad5c7f8b520e76619a size: 3055
Build complete in 32.886178422s
Starting test...
Test complete in 38.849µs
Starting deploy...
kubectl client version: 1.13
pod/docs created
Deploy complete in 890.826958ms
Watching for changes every 1s...
Port Forwarding docs/docs 8000 -> 8000
[docs] sphinx-autobuild -b html -d _build/doctrees   . _build/html -H 0.0.0.0 --port 8000
[docs] /opt/app/getting_started.rst:73: WARNING: Definition list ends without a blank line; unexpected unindent.
[docs] /opt/app/release.rst: WARNING: document isn't included in any toctree
[docs] WARNING: favicon file 'favicon.png' does not exist
[docs] [I 190306 03:31:11 server:298] Serving on http://0.0.0.0:8000
[docs] [I 190306 03:31:11 handlers:59] Start watching changes
[docs] [I 190306 03:31:11 handlers:61] Start detecting changes
```

- Open http://localhost:8000 to work on the docs, you can edit any .rst files and the docs site will
reload automatically.


## Skaffold dev mode with helm

This will be the default mode soon in the future when the sync bug is fixed by Skaffold.

- Execute the following commands:

```bash
$ cd docs
$ skaffold dev -p helm
```

- You should see the following output:

```bash
Generating Tag for [registry.k8s.local/teracy_teracy-dev-docs-dev]...
Starting build...
Building [registry.k8s.local/teracy_teracy-dev-docs-dev]...
Sending build context to Docker daemon  2.807MB
Step 1/7 : ARG PYTHON_VERSION=3.7
Step 2/7 : FROM python:$PYTHON_VERSION
 ---> 32260605cf7a
Step 3/7 : RUN mkdir -p /opt/app
 ---> Using cache
 ---> 5781d3cf82fd
Step 4/7 : ENV TERM=xterm-256color APP=/opt/app
 ---> Using cache
 ---> 6b1a298cc237
Step 5/7 : ADD requirements.txt $APP/
 ---> Using cache
 ---> 9f17f48879c1
Step 6/7 : RUN cd $APP && pip install -r requirements.txt
 ---> Using cache
 ---> 52cfb162c7f2
Step 7/7 : ADD . $APP
 ---> ad287ad93ed2
Successfully built ad287ad93ed2
Successfully tagged registry.k8s.local/teracy_teracy-dev-docs-dev:a2115e0-dirty
The push refers to repository [registry.k8s.local/teracy_teracy-dev-docs-dev]
3d9bbc3b0aa7: Preparing
a3443c79712d: Preparing
ad4d80495365: Preparing
6ee5cb4eed32: Preparing
bb839e9783c7: Preparing
237ce60325c6: Preparing
1b976700da1f: Preparing
bde41e1d0643: Preparing
237ce60325c6: Waiting
1b976700da1f: Waiting
7de462056991: Preparing
3443d6cf0f1f: Preparing
f3a38968d075: Preparing
a327787b3c73: Preparing
5bb0785f2eee: Preparing
bde41e1d0643: Waiting
7de462056991: Waiting
3443d6cf0f1f: Waiting
f3a38968d075: Waiting
a327787b3c73: Waiting
5bb0785f2eee: Waiting
a3443c79712d: Layer already exists
6ee5cb4eed32: Layer already exists
bb839e9783c7: Layer already exists
ad4d80495365: Layer already exists
237ce60325c6: Layer already exists
1b976700da1f: Layer already exists
bde41e1d0643: Layer already exists
7de462056991: Layer already exists
3443d6cf0f1f: Layer already exists
f3a38968d075: Layer already exists
a327787b3c73: Layer already exists
5bb0785f2eee: Layer already exists
3d9bbc3b0aa7: Pushed
a2115e0-dirty: digest: sha256:b819729f0229ae62e0297f0d62b4a65db04495ee0e82cb0db1e1f547c5c29c5b size: 3055
Build complete in 32.784044601s
Starting test...
Test complete in 16.52µs
Starting deploy...
Error: release: "teracy-dev-docs-dev" not found
Helm release teracy-dev-docs-dev not installed. Installing...
No requirements found in helm-charts/teracy-dev-docs-dev/charts.
NAME:   teracy-dev-docs-dev
LAST DEPLOYED: Wed Mar  6 10:35:46 2019
NAMESPACE: teracy-dev
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME                 TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)  AGE
teracy-dev-docs-dev  ClusterIP  10.233.36.154  <none>       80/TCP   0s

==> v1beta2/Deployment
NAME                 DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
teracy-dev-docs-dev  1        1        1           0          0s

==> v1beta1/Ingress
NAME                 HOSTS                      ADDRESS  PORTS  AGE
teracy-dev-docs-dev  dev.docs.teracy-dev.local  80, 443  0s

==> v1/Pod(related)
NAME                                  READY  STATUS             RESTARTS  AGE
teracy-dev-docs-dev-5ccfc8b869-2l7mk  0/1    ContainerCreating  0         0s


NOTES:
1. Get the application URL by running these commands:
  https://dev.docs.teracy-dev.local/

Deploy complete in 1.669862476s
Watching for changes every 1s...
```

- Configure the domain alias by editing the `k8s-dev/workspace/teracy-dev-entry/config_override.yaml`
with the following configuration:

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

- Open https://dev.docs.teracy-dev.local/

## Remote k8s cluster

Adjust and apply the same as with the local cluster guide above.

//TODO(hoatle): add details for this

## References

- https://skaffold.dev/

