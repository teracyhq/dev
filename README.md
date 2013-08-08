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

1\. Bash script

Just run this bash script from your [sphinx][] project and it's enough.

``` bash
wget
```

2\. Command line
``` bash
$ git
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

You need to configure these deployment configurations following your project organization:

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



Authors and contributors
------------------------

- Hoat Le: http://github.com/hoatle

- Many thanks to http://octopress.org/docs/deploying/ for inspiration.

License
-------

MIT License


[sphinx]: http://sphinx-doc.org
