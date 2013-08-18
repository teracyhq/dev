# Copyright (c) Teracy, Inc and individual contributors.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy nor the names of its contributors may be used
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

# The development directory tracking DEPLOY_BRANCH
ifndef DEPLOY_DIR
DEPLOY_DIR      = _deploy
endif

# Copy contents from $(BUILDDIR) $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR) directory
ifndef DEPLOY_HTML_DIR
DEPLOY_HTML_DIR = docs/develop
endif

# Configure the right deployment branch
ifndef DEPLOY_BRANCH
DEPLOY_BRANCH   = gh-pages
endif

#if REPO_URL was NOT defined by travis-ci
ifndef REPO_URL
# Configure your right project repo
REPO_URL       = git@github.com:teracy-official/dev.git
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
	@rm -rf $(DEPLOY_DIR)
	@mkdir -p $(DEPLOY_DIR)
	@cd $(DEPLOY_DIR);\
		git init;\
		echo 'sphinx docs comming soon...' > index.html;\
		git add .; git commit -m "sphinx docs init";\
		git branch -m $(DEPLOY_BRANCH); \
		git remote add origin $(REPO_URL);\
		git fetch origin;\
		git reset --hard origin/$(DEPLOY_BRANCH);\
		git branch --set-upstream $(DEPLOY_BRANCH) origin/$(DEPLOY_BRANCH)
	@echo "Now you can deploy to Github Pages with 'make generate' and then 'make deploy'"

generate: html

prepare_deploy:
	@echo "Preparing deployment..."
	@echo "Pulling any update from Github Pages..."
	@cd $(DEPLOY_DIR); git pull
	@mkdir -p $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)
	@echo "Copying files from '$(BUILDDIR)/html/.' to '$(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)'"
	@cp -r $(BUILDDIR)/html/. $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)

deploy: prepare_deploy
	@echo "Committing files..."
	@cd $(DEPLOY_DIR); git add -A; git commit -m "docs updated at `date -u`";\
		git push origin $(DEPLOY_BRANCH) --quiet
	@echo "Github Pages deploy is completed at `date -u`"

gen_deploy: generate deploy
