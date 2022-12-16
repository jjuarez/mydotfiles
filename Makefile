#!/usr/bin/env make

.DEFAULT_GOAL  := help
.DEFAULT_SHELL := /bin/bash

VENV             ?= .venv
REQUIREMENT_FILE ?= requirements.txt

DOTFILES          ?= $(HOME)/.mydotfiles
HOMEBREW_FILE     := $(DOTFILES)/backups/homebrew/Brewfile
ANSIBLE_INVENTORY ?= site.yml
ANSIBLE_OPTS      ?=
ANSIBLE_TAGS      ?=


define assert-set
	@$(if $($1),,$(error $(1) environment variable is not defined))
endef

define assert-command
	@$(if $(shell command -v $1 2>/dev/null),,$(error $(1) command not found))
endef

define assert-file
	@$(if $(wildcard $($1) 2>/dev/null),,$(error $($1) does not exist))
endef


.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z//_-]+:.*?##/ { printf " %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: test
test:
	$(call assert-set,DOTFILES)
	$(call assert-file,DOTFILES)
	$(call assert-file,HOMEBREW_FILE)

$(VENV):
	@python -m venv $(VENV)
	@pip install --disable-pip-version-check --quiet --requirement $(REQUIREMENT_FILE)

.PHONY: venv/activate
venv/activate: $(VENV)
	@. $(VENV)/bin/activate

.PHONY: ansible/check
ansible/check: venv/activate ## Run the ansible playbooks in check mode
	@ansible-playbook --check $(ANSIBLE_OPTS) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS)

.PHONY: ansible/run
ansible/run: venv/activate ## Run the ansible playbooks
	@ansible-playbook $(ANSIBLE_OPTS) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS)

.PHONY: homebrew/dump
homebrew/dump: venv/activate ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(HOMEBREW_FILE)

.PHONY: homebrew/load
homebrew/load: ## Load and install a snapshot of your formulas, casks, taps, etc
	@brew bundle --file $(HOMEBREW_FILE)

.PHONY: clean
clean:
	@rm -fr $(VENV)
