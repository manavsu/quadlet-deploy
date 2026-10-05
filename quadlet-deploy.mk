QUADLET_DEPLOY_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

QUADLET_DIR ?= $(CURDIR)/quadlet
SERVER      ?= $(error SERVER is not set, e.g. make deploy SERVER=me@host)

.PHONY: install deploy status logs quadlet-deploy-clean

install:
	$(QUADLET_DEPLOY_DIR)scripts/install.sh "$(SERVER)"

deploy:
	$(QUADLET_DEPLOY_DIR)scripts/deploy.sh "$(QUADLET_DIR)" "$(SERVER)"

status:
	$(QUADLET_DEPLOY_DIR)scripts/status.sh "$(QUADLET_DIR)" "$(SERVER)"

logs:
	$(QUADLET_DEPLOY_DIR)scripts/logs.sh "$(QUADLET_DIR)" "$(SERVER)"

quadlet-deploy-clean:
	$(QUADLET_DEPLOY_DIR)scripts/clean.sh
