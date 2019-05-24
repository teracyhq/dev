# Copyright (c) Teracy, Inc. and individual contributors.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
#        to endorse or promote products derived from this software without
#        specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Deployment configurations from sphinx_deployment project

# default deployment when $ make deploy
# push       : to $ make push
# rsync      : to $ make rsync
# push rsync : to $ make push then $ make rsync
# default value: push
ifndef DEPLOY_DEFAULT
DEPLOY_DEFAULT = push
endif

# The deployment directory to be deployed
ifndef DEPLOY_DIR
DEPLOY_DIR      = _deploy
endif

# Copy contents from $(BUILDDIR) to $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR) directory
ifndef DEPLOY_HTML_DIR
DEPLOY_HTML_DIR = docs
endif


## -- Rsync Deploy config -- ##
# Be sure your public key is listed in your server's ~/.ssh/authorized_keys file
ifndef SSH_USER
SSH_USER       = user@domain.com
endif

ifndef SSH_PORT
SSH_PORT       = 22
endif

ifndef DOCUMENT_ROOT
DOCUMENT_ROOT  = ~/website.com/
endif

#If you choose to delete on sync, rsync will create a 1:1 match
ifndef RSYNC_DELETE
RSYNC_DELETE   = false
endif

# Any extra arguments to pass to rsync
ifndef RSYNC_ARGS
RSYNC_ARGS     =
endif

## -- Github Pages Deploy config -- ##

# Configure the right deployment branch
ifndef DEPLOY_BRANCH
DEPLOY_BRANCH   = gh-pages
endif

#if REPO_URL was NOT defined by travis-ci
ifndef REPO_URL
# Configure your right project repo
# REPO_URL       = git@github.com:teracyhq/sphinx-deployment.git
endif

## end deployment configuration, don't edit anything below this line ##

ifeq ($(RSYNC_DELETE), true)
RSYNC_DELETE_OPT = --delete
endif

init_gh_pages:
	@rm -rf $(DEPLOY_DIR)
	@mkdir -p $(DEPLOY_DIR)
	@cd $(DEPLOY_DIR); git init;\
		echo 'sphinx docs comming soon...' > index.html;\
		touch .nojekyll;\
		git add .; git commit -m "sphinx docs init";\
		git branch -m $(DEPLOY_BRANCH);\
		git remote add origin $(REPO_URL);
	@cd $(DEPLOY_DIR);\
		if ! git ls-remote origin $(DEPLOY_BRANCH) | grep $(DEPLOY_BRANCH) ; then \
			echo "Preparing Github deployment branch: $(DEPLOY_BRANCH) for the first time only...";\
			git push -u origin $(DEPLOY_BRANCH);\
		fi

setup_gh_pages: init_gh_pages
	@echo "Setting up gh-pages deployment..."
	@cd $(DEPLOY_DIR);\
		git fetch origin;\
		git reset --hard origin/$(DEPLOY_BRANCH);\
		git branch --set-upstream-to=origin/$(DEPLOY_BRANCH) $(DEPLOY_BRANCH)
	@echo "Now you can deploy to Github Pages with 'make generate' and then 'make deploy'"

generate: html

prepare_rsync_deployment:
	@echo "Preparing rsync deployment..."
	@mkdir -p $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)
	@echo "Copying files from '$(BUILDDIR)/html/.' to '$(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)'"
	@cp -r $(BUILDDIR)/html/. $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)

rsync: prepare_rsync_deployment
	@echo "Rsync now..."
	rsync -avze 'ssh -p $(SSH_PORT)' --exclude-from $(realpath ./rsync_exclude) $(RSYNC_ARGS) $(RSYNC_DELETE_OPT) ${DEPLOY_DIR}/ $(SSH_USER):$(DOCUMENT_ROOT)

prepare_gh_pages_deployment:
	@echo "Preparing gh_pages deployment..."
	@echo "Pulling any update from Github Pages..."
	@cd $(DEPLOY_DIR); git pull;
	@mkdir -p $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)
	@echo "Copying files from '$(BUILDDIR)/html/.' to '$(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)'"
	@cp -r $(BUILDDIR)/html/. $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)

push: prepare_gh_pages_deployment
	@echo "Committing files..."
	@cd $(DEPLOY_DIR); git add -A; git commit -m "docs updated at `date -u`";\
		git push origin $(DEPLOY_BRANCH) --quiet
	@echo "Github Pages deploy was completed at `date -u`"

deploy: $(DEPLOY_DEFAULT)

gen_deploy: generate deploy
