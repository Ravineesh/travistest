
SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")

push:
	echo "Tagging the release"
	git remote add travis https://80ec795c37bc56f6459ff6573ef778c0df9a1516@github.com/pzelnip/travistest
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push travis $(DEPLOY_TIME)_$(SHA)

.PHONY: push
