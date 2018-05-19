PY?=python3
PELICAN?=pelican
PELICANOPTS=
S3OPTS=

AWSCLI_PROFILE=codependentcodr

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

S3_BUCKET=www.codependentcodr.com
DOCKER_IMAGE_NAME=travistest
DOCKER_IMAGE_TAGS := $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep '$(DOCKER_IMAGE_NAME)')

SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")
HOST := $(shell hostname)



deploy: tag #s3_upload s3cachecontrol tag slackpost

s3_upload: publish lint_the_things dockerpush cleanbranches
	echo "Uploading to s3"
	# don't upload if directory is dirty
	# ./git-clean-dir.sh
	# aws --profile $(AWSCLI_PROFILE) s3 sync $(OUTPUTDIR) s3://$(S3_BUCKET) --delete $(S3OPTS)

cleanbranches:
	echo "Cleaning branches"
	# git remote | xargs -n 1 git fetch -v --prune $1
	# git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

tag:
	echo "Git tagging"
	git config --global user.email "travis@travis-ci.org"
	git config --global user.name "Travis CI"
	git remote add travis https://${GH_TOKEN}@github.com/pzelnip/travistest
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push travis $(DEPLOY_TIME)_$(SHA)

lint_the_things: markdownlint pylint

markdownlint: dockerbuild
	docker run --rm -it $(DOCKER_IMAGE_NAME):latest echo "markdownlint"

pylint: dockerbuild
	docker run --rm -it $(DOCKER_IMAGE_NAME):latest echo "PYLINT"

dockerbuild:
	docker build -t $(DOCKER_IMAGE_NAME):latest .

dockerrun: dockerbuild
	docker run -it --rm $(DOCKER_IMAGE_NAME):latest /bin/sh

slackpost:
	echo "Slack posting!"

cfinvalidate:
	aws --profile $(AWSCLI_PROFILE) cloudfront create-invalidation --distribution-id ER3YIY14W87BX --paths '/*.html' '/' '/feeds/all.atom.xml'

s3cachecontrol:
	echo "Cache control disabled until it's fixed"

dockerpush: dockerbuild
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker tag $(DOCKER_IMAGE_NAME) pzelnip/$(DOCKER_IMAGE_NAME):latest
	docker tag $(DOCKER_IMAGE_NAME) pzelnip/$(DOCKER_IMAGE_NAME):$(SHA)
	docker push pzelnip/$(DOCKER_IMAGE_NAME):latest
	docker push pzelnip/$(DOCKER_IMAGE_NAME):$(SHA)

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish s3_upload github
