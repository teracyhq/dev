sphinx-deployment
=================

Automatic setup and deployment for [sphinx][] docs.

This project is intended to be used to deploy [sphinx][] project on:

- [Github Pages](https://help.github.com/categories/20/articles)
- [Rsync](http://en.wikipedia.org/wiki/Rsync)
- PaaS services: [heroku](http://heroku.com/), etc.

How to install
---------------

You could choose one of these installation methods below, the first one is recommended.

Assuming that your sphinx project is under `docs` directory of your project repository.

1\. Bash script

Just run this bash script from your [sphinx][] project and it's enough.

``` bash
wget
```
**TODO**

2\. Command line

We're going to checkout this project as a branch and do "overlay" work depending on your project
structure.

2.1. If your `sphinx` docs project is under `docs` directory of a `git` repository:

``` bash
$ git remote add -f hoatle-sphinx-deployment https://github.com/hoatle/sphinx-deployment.git
$ git checkout hoatle-sphinx-deployment/develop -b hoatle-sphinx-deployment
$ mkdir -p docs
$ git mv CHANGELOG.md docs/CHANGELOG_sphinx_deployment.md
$ git mv LICENSE docs/LICENSE_sphinx_deployment
$ git mv README.md docs/README_sphinx_deployment.md
$ git mv requirements.txt docs/requirements.txt
$ git mv sphinx_deployment.mk docs/sphinx_deployment.mk
$ git mv sphinx_deployment.sh docs/sphinx_deployment.sh
$ git commit -m "Install sphinx-deployment"
```

2.2. If your [sphinx][] docs is a git repository

``` bash
$ git remote add -f hoatle-sphinx-deployment https://github.com/hoatle/sphinx-deployment.git
$ git checkout hoatle-sphinx-deployment/develop -b hoatle-sphinx-deployment
$ git mv CHANGELOG.md CHANGELOG_sphinx_deployment.md
$ git mv LICENSE LICENSE_sphinx_deployment
$ git mv README.md README_sphinx_deployment.md
$ git commit -m "Install sphinx-deployment"
```

Note: You need to keep `hoatle-sphinx-deployment` branch for easier updating later.

3\. Manual

- Copy all contents from this repository to your [sphinx][] project.

- Rename `README.md` to `README_sphinx_deployment.md`

- Rename `CHANGELOG.md` to `CHANGELOG_sphinx_deployment.md`

- Rename `LICENSE` to `LICENSE_sphinx_deployment`

How to configure
----------------

1. `sphinx_deployment.mk`

You need to configure these deployment configurations following your project organization on
`sphinx_deployment.mk` file on `hoatle-sphinx-deployment` branch.

``` Makefile
# Deployment configurations

# The development directory tracking DEPLOY_BRANCH
DEPLOY_DIR      = _deploy

# Copy contents from $(BUILDDIR) this this directory
DEPLOY_HTML_DIR = docs
DEPLOY_BRANCH   = gh-pages

#if REPO_URL was NOT defined by travis-ci
ifndef REPO_URL
#REPO_URL       = git@github.com:hoatle/sphinx-deployment.git
endif
```

2\. `Makefile`

- Merge `hoatle-sphinx-deployment` branch into your working branch for all the changes from
installation and configuration steps above. For example:

``` bash
$ git checkout master
$ git merge -X theirs hoatle-sphinx-deployment
```

`-X theirs` means the `hoatle-sphinx-deployment` branch content will overwrite existing content of
`master` branch if any. You need to review the change carefully after this merge to make sure it
does overwrite anything by accident.

- Include `sphinx_deployment.mk` to your `Makefile`. For example:

``` bash
echo '' >> docs/Makefile
echo 'include sphinx_deployment.mk' >> docs/Makefile
```

or:

``` bash
echo '' >> Makefile
echo 'include sphinx_deployment.mk' >> Makefile
```

How to use
----------

0\. `$ make init_gh_pages`

For **the first time only** to create and push the `$(DEPLOY_BRANCH)` if it does not exist.

Note: I'm working to remove this `target` to use just `make setup_gh_pages` target to initialize
`$(DEPLOY_BRANCH)` if it does not exists.

1\. `make setup_gh_pages`

For one time only when your [sphinx][] project is cloned to create `$(DEPLOY_DIR)` to track
`$(DEPLOY_BRANCH)`.

2\. `$ make generate`

For generating contents, alias for `make html`

3\. `$ make deploy`

Deploy the generated content to the target `$(DEPLOY_BRANCH)`


How to build with travis-ci
---------------------------

Move `.travis.yml` file to your root repository project, and configure it following its
instruction there and you're done.


Authors and contributors
------------------------

- Hoat Le: http://github.com/hoatle

- Many thanks to http://octopress.org/docs/deploying/ for inspiration.

License
-------

MIT License


[sphinx]: http://sphinx-doc.org
