
SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")

push:
	echo "Tagging the release"
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push https://${GH_TOKEN}@github.com/pzelnip/travistest $(DEPLOY_TIME)_$(SHA)

test:
	echo "Run the tests"

.PHONY: push
