# Deployment configurations

# The development directory tracking DEPLOY_BRANCH
DEPLOY_DIR      = _deploy

# Copy contents from $(BUILDDIR) this this directory
DEPLOY_HTML_DIR = docs

# Configure the right deployment branch
DEPLOY_BRANCH   = gh-pages

#if REPO_URL was NOT defined by travis-ci
ifndef REPO_URL
# Configure your right project repo
#REPO_URL       = git@github.com:hoatle/sphinx-deployment.git
endif

init_gh_pages:
	@echo "Preparing Github deployment branch: $(DEPLOY_BRANCH) for the first time only"
	rm -rf $(DEPLOY_DIR)
	mkdir -p $(DEPLOY_DIR)
	cd $(DEPLOY_DIR); git init;\
		echo 'sphinx docs comming soon...' > index.html;\
		touch .nojekyll;\
		git add .; git commit -m "sphinx docs init";\
		git branch -m $(DEPLOY_BRANCH);\
		git remote add origin $(REPO_URL);\
		git push -u origin $(DEPLOY_BRANCH)

setup_gh_pages:
	rm -rf $(DEPLOY_DIR)
	mkdir -p $(DEPLOY_DIR)
	cd $(DEPLOY_DIR); git init;\
		echo 'sphinx docs comming soon...' > index.html;\
		git add .; git commit -m "sphinx docs init";\
		git branch -m $(DEPLOY_BRANCH);\
		git remote add origin $(REPO_URL);\
		git fetch origin;\
		git reset --hard origin/$(DEPLOY_BRANCH);\
		git branch --set-upstream $(DEPLOY_BRANCH) origin/$(DEPLOY_BRANCH)
	@echo "Now you can deploy to Github Pages with 'make generate' and then 'make deploy'"

generate: html

prepare_deploy:
	@echo "Preparing deployment..."
	@echo "Pulling any update from Github Pages..."
	cd $(DEPLOY_DIR); git pull
	mkdir -p $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)
	@echo "Copying files from '$(BUILDDIR)/html/.' to '$(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)/'"
	cp -r $(BUILDDIR)/html/. $(DEPLOY_DIR)/$(DEPLOY_HTML_DIR)/

deploy: prepare_deploy
	@echo "Committing files..."
	cd $(DEPLOY_DIR); git add -A; git commit -m "docs updated at `date -u`";\
		git push origin $(DEPLOY_BRANCH) --quiet
	@echo "Github Pages deploy is completed at `date -u`"
