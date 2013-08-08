sphinx-deployment
=================

Automatic setup and deployment for [sphinx][] docs

This project is intended to be merged into [sphinx][] project
when it's mature enough.

This project is intended to be used to deploy [sphinx][] project on:

- [Github Pages](https://help.github.com/categories/20/articles)
- [Rsync](http://en.wikipedia.org/wiki/Rsync)
- PaaS services: [heroku](http://heroku.com/), etc.

How to install
---------------

You could choose one of these three installation methods, the first one is recommended.

Assuming that your sphinx project is under `docs` directory of your project repository.

1\. Bash script

Just run this bash script from your [sphinx][] project and it's enough.

``` bash
wget
```
**TODO**

2\. Command line

2.1. If your `sphinx` docs project is under `docs` directory of a `git` repository:

Note: Make sure `docs` directory do not contain the same file name from `sphinx-deployment` project
as we're going to do [subtree merge][]

``` bash
$ git remote add -f hoatle-sphinx-deployment https://github.com/hoatle/sphinx-deployment.git
$ git merge -s ours --no-commit hoatle-sphinx-deployment/develop
$ git read-tree --prefix=docs/ -u hoatle-sphinx-deployment/develop
$ echo "include sphinx_deployment.mk" >> docs/Makefile
$ git add .
$ git commit -a
$ git mv docs/CHANGELOG.md docs/CHANGELOG_sphinx_deployment.md
$ git mv docs/LICENSE docs/LICENSE_sphinx_deployment
$ git mv docs/README.md docs/README_sphinx_deployment.md
$ git commit -m "Rename to avoid conflicts"
```

2.2. If your [sphinx][] docs is a git repository

``` bash
$ git remote add hoatle-sphinx-deployment https://github.com/hoatle/sphinx-deployment.git
$ git fetch hoatle-sphinx-deployment
$ git merge hoatle-sphinx-deployment/develop
$ git commit -a
$ git mv README.md README_sphinx_deployment.md
$ git mv CHANGELOG.md CHANGELOG_sphinx_deployment.md
$ git mv LICENSE LICENSE_sphinx_deployment
$ git commit -a
```

3\. Manual

- Copy all contents from this repository to your [sphinx][] project.

- Include `sphinx_deployment.mk` to your `Makefile` by appending this line to your `Makefile`:
```
include sphinx_deployment.mk
```
- Rename `README.md` to `README_sphinx_deployment.md`

- Rename `CHANGELOG.md` to `CHANGELOG_sphinx_deployment.md`

- Rename `LICENSE` to `LICENSE_sphinx_deployment`

How to configure
----------------

You need to configure these deployment configurations following your project organization on
`sphinx_deployment.mk` file:

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


How to use
----------

0\. `make init_gh_pages`

For the first time only to create and push the `$(DEPLOY_BRANCH)`.

Note: I'm working to remove this `target`. Just `make setup_gh_pages` is enough.

1\. `make setup_gh_pages`

For one time only when your [sphinx][] project is cloned to create `$(DEPLOY_DIR)` to track
`$(DEPLOY_BRANCH)`.

2\. `make generate`

For generating contents, alias for `make html`

3\. `make deploy`

Deploy the generated content to the target `$(DEPLOY_BRANCH)`


How to build with travis-ci
---------------------------

Move `.travis.yml` file to your root repository project, and configure it following its
instruction there.


Authors and contributors
------------------------

- Hoat Le: http://github.com/hoatle

- Many thanks to http://octopress.org/docs/deploying/ for inspiration.

License
-------

MIT License


[sphinx]: http://sphinx-doc.org
[substree merge]: https://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html
