#=================================================================================
# Proxies to rake
#=================================================================================

# spits runs "rake -T" to show list of rake tasks
rake:
	@$(MAKE) -s docker-run cmd="rake -T"
	@echo "Run 'make rake-preview' to run 'rake preview' inside docker-octopress container"

rake-%:
	@$(MAKE) -s docker-run cmd="rake $*"

preview: rake-preview
generate: rake-generate
deploy: rake-deploy

new_post: rake-new_post
	# editing the latest created file in VIM
	vim posts/`ls -c posts/ | head -n 1`

#=================================================================================
# Deployment
#=================================================================================

deploy_repo_url = git@github.com:dergachev/dergachev.github.io.git
git_email = $(shell git config --get user.email)
git_name = $(shell git config --get user.name)
deploy-repo:
	@read -p "Enter github deploy URL [$(deploy_repo_url)]: " url; \
		git clone "$${url:-$(deploy_repo_url)}" deploy_repo
	@cd deploy_repo; \
		read -p "Enter git commit email [$(git_email)]: " git_email; \
		git config --local user.email "$${git_email:-$(git_email)}"; \
		read -p "Enter git commit name [$(git_name)]: " git_name; \
		git config --local user.name "$${git_name:-$(git_name)}";

#=================================================================================
# Utils
#=================================================================================

shell:
	$(MAKE) -s docker-run cmd=/bin/bash

docker-build:
	docker build -t dergachev/octopress .

prepare: deploy_repo
	mkdir -p posts config public
	chmod g+s posts config public deploy_repo

docker-run: prepare
	docker run -t -i \
	-v `pwd`/posts:/srv/octopress-master/source/_posts \
	-v `pwd`/config:/srv/octopress-master/config \
	-v `pwd`/public:/srv/octopress-master/public \
	-v `pwd`/deploy_repo:/srv/octopress-master/_deploy \
	-v `dirname $(SSH_AUTH_SOCK)`:`dirname $(SSH_AUTH_SOCK)` -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK) \
	-p 4000:4000 \
	dergachev/octopress \
	docker-umask-wrapper.sh $(cmd)

.PHONY: deploy
