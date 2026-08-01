IMAGE_VERSION ?= 2026.08.01.1
OWNER ?= pyrodie18

.PHONY: build build-python build-ansible validate

build: build-python build-ansible

build-python:
	docker build --file images/python/Dockerfile --tag ghcr.io/$(OWNER)/python-dev:$(IMAGE_VERSION) .

build-ansible:
	docker build --file images/ansible/Dockerfile --tag ghcr.io/$(OWNER)/ansible-dev:$(IMAGE_VERSION) .

validate:
	./scripts/validate-repository
