# teracy-dev-docs

This is the guide on how to work with teracy-dev-docs project.

## Getting Started

- Set up `teracy-dev` if not yet, follow: http://dev.teracy.org/docs/develop/getting_started.html

- Fork this repo into your github account, better to rename it to `teracy-dev`.

- Clone the forked repo into `~/teracy-dev/workspace` directory:

  ```bash
  $ cd ~/teracy-dev/workspace/
  $ git clone <your_forked_repository_here> teracy-dev
  $ cd teracy-dev
  $ git remote add upstream git@github.com:teracyhq/dev.git
  ```

- You need to fetch the latest changes of `teracy-dev` before going to the next step.
  Please see the details at http://dev.teracy.org/docs/develop/workflow.html.

  For example:

  ```bash
  $ git fetch upstream
  $ git checkout upstream/develop -b tasks/my-work
  ```

## How to work in dev mode

- Start:

  If you haven't `$ vagrant up` yet, open the first terminal window and remember to let the file
  watching keep running:

  ```bash
  $ cd ~/teracy-dev
  $ vagrant up
  ```

  Open the second terminal window:

  ```bash
  $ cd ~/teracy-dev
  $ vagrant ssh
  $ ws
  $ cd teracy-dev/docs
  $ docker-compose pull && docker-compose up -d && docker-compose logs -f
  ```

  Open the third terminal window to identify the \<vm_ip_address>, follow: http://dev.teracy.org/docs/develop/basic_usage.html#ip-address

  Open \<vm_ip_address>:8000 to view the generated docs on local dev.


- Update new changes:

  Update new changes, save the changes and the browser should auto refresh to see the new changes on
  the updated files.


- Stop working:

  Press `Ctrl + c` to stop following the logs and then:

  ```bash
  $ docker-compose stop
  ```

## How to review others' work and PRs (pull requests)


To review work and PRs submitted by others, for example, with
`hoatle/teracy-dev-docs:improvements-176-teracy-dev-docs-guide` Docker image, run it:

```
$ docker run --rm -p 8888:80 hoatle/teracy-dev-docs:improvements-176-teracy-dev-docs-guide
```

And open \<vm_ip_address>:8888 to review the changes on local host

Press `Ctrl + c` to stop reviewing (stop docker run)


## How to run in prod mode

Run in the prod mode from official distributed Docker image:

```
$ docker run --rm -p 8080:80 teracy/dev-docs:develop
```

or with docker-compose and from docker-compose.prod.yml file:

```
$ ws
$ cd teracy-dev/docs
$ docker-compose -f docker-compose.prod.yml pull && docker-compose -f docker-compose.prod.yml up
```

Then open \<vm_ip_address>:8080 to see the static docs site served by nginx.


## How to build the prod Docker image

First, use the `teracy/dev-docs:dev_develop` Docker image to generate static content:

```
$ ws
$ cd teracy-dev/docs
$ docker run --rm -v $(pwd):/opt/app teracy/dev-docs:dev_develop make generate
```

And then:

```
$ docker-compose -f docker-compose.prod.yml build
```

## travis-ci configuration

You just need to configure travis-ci only one time. After each travis-ci build, new Docker images
are pushed, we can review your work (PR) by running the Docker images instead of fetching git code
and build it on local ourselves.

Here are things you need to do:

- Register your account at https://hub.docker.com
- Register your account at travis-ci.org
- Enable teracy-dev repository on travis-ci (for example: https://travis-ci.org/hoatle/teracy-dev)
- Fill in the following environment variables settings for teracy-dev travis-ci project by
  following: https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings.
  In the *Name* and *Value* fields, please add the info below correlatively: 

  + Fill in "DOCKER_USERNAME" into the *Name* field and your Docker username into the *Value*  field
  + Fill in "DOCKER_PASSWORD" into the *Name* field and your Docker password into the *Value* field
  + Fill in "DEV_DOCKER_IMAGE" into the *Name* field, and your repo name for https://hub.docker.com
    into the *Value*, for example, "hoatle/teracy-dev" (so that to create https://hub.docker.com/r/hoatle/teracy-dev/)
  + Fill in "DOCS_DOCKER_IMAGE" into the *Name* field, and your repo name for https://hub.docker.com
    into the *Value*, for example, "hoatle/teracy-dev-docs" (so that to create https://hub.docker.com/r/hoatle/teracy-dev-docs/)

And you're done!

## Tips:


- How to access into the container ssh session:

  ```bash
  $ docker-compose exec dev /bin/bash
  app@a4e5c4766cd3:/opt/app$
  ```