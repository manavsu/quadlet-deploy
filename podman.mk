PODMAN_DEPLOY_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

QUADLET_DIR ?= $(CURDIR)/quadlet
SERVER      ?= $(error SERVER is not set, e.g. make deploy SERVER=me@host)

.PHONY: install deploy podman-deploy-update

install:
	$(PODMAN_DEPLOY_DIR)scripts/install.sh "$(SERVER)"

deploy:
	$(PODMAN_DEPLOY_DIR)scripts/deploy.sh "$(QUADLET_DIR)" "$(SERVER)"

podman-deploy-update:
	rm -rf $(PODMAN_DEPLOY_DIR)
