
SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")

push:
	echo "Tagging the release"
	git tag "$(DEPLOY_TIME)_$(SHA)"

.PHONY: push
