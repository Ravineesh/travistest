
SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")

push:
	echo "Tagging the release"
	git remote add travis https://426cd4542f5c389b3401a7e2d6ad7fc455782f6f@github.com/pzelnip/travistest
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push travis "$(DEPLOY_TIME)_$(SHA)"

.PHONY: push
