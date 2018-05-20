
SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")

push:
	echo "Tagging the release"
	git remote add tokenremote https://${GH_TOKEN}@github.com/pzelnip/travistest
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push tokenremote $(DEPLOY_TIME)_$(SHA)

.PHONY: push
