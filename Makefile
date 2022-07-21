SHELL = /usr/bin/env bash

.PHONY: help
.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

PACKER_VERSION := 1.8.2
SHFMT_VERSION := 3.5.1
SHELLCHECK_VERSION := 0.8.0

KERNEL := $(shell uname -s | tr A-Z a-z)
ARCH := $(shell uname -m)

ifeq (${ARCH},arm64)
	ARCH_ALT=arm64
endif
ifeq (${ARCH},aarch64)
	ARCH_ALT=arm64
endif
ifeq (${ARCH},x86_64)
	ARCH_ALT=amd64
endif

PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_${KERNEL}_${ARCH_ALT}.zip"
SHFMT_URL="https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_${KERNEL}_${ARCH_ALT}"
SHELLCHECK_URL="https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.${KERNEL}.${ARCH}.tar.xz"

##@ Tool Installation

.PHONY: packer
packer: ## Packer is a tool for creating identical machine images for multiple platforms from a single source configuration
	@curl -fLSs ${PACKER_URL} -o ./packer.zip
	@unzip -n ./packer.zip
	@rm ./packer.zip

.PHONY: shellcheck
shellcheck: ## Shellcheck: Script analysis tool
	@curl -fLSs ${SHELLCHECK_URL} -o /tmp/shellcheck.tar.xz
	@tar -xvf /tmp/shellcheck.tar.xz -C /tmp --strip-components=1
	@mv /tmp/shellcheck ./shellcheck
	@rm /tmp/shellcheck.tar.xz

.PHONY: shfmt
shfmt: ## shfmt: A shell parser, formatter, and interpreter
	@curl -fLSs ${SHFMT_URL} -o ./shfmt
	@chmod +x ./shfmt

.PHONY: clean
clean: ## Remove temp files used for development checks
	rm -f manifest.json
	rm -f shellcheck
	rm -f shfmt
	rm -f packer

##@ Static Checks

.PHONY: init
init: packer ## Initialize packer
	./packer init .

.PHONY: packer-fmt
packer-fmt: packer ## Check packer configurations format
	./packer fmt -check .

.PHONY: validate
validate: init ## Validate packer configurations
	./packer validate -var .

.PHONY: fmt
fmt: packer shfmt ## Format codebase
	./packer fmt .
	./shfmt -l -s -w -i 4 ./*/*.sh

.PHONY: static-check
static-check: packer-fmt shfmt shellcheck ## All static checks
	./packer validate .
	./shfmt -d -s -w -i 4 ./*/*.sh
	./shellcheck --severity=error --exclude=SC2045 ./*/*.sh
