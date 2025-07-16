#!/usr/bin/env make

.DEFAULT_GOAL  := help
.DEFAULT_SHELL := bash
SHELL          := bash
.SHELLFLAGS    := -eu -o pipefail -c
MAKEFLAGS      += --warn-undefined-variables
MAKEFLAGS      += --no-builtin-rule

PYTHON            ?= $(shell command -v python3 2>/dev/null)
PIP               ?= $(shell command -v pip3 2>/dev/null)

DOTFILES          ?= $(HOME)/.mydotfiles
HOMEBREW_FILE     := $(DOTFILES)/backups/homebrew/Brewfile
ANSIBLE_INVENTORY ?= site.yml
ANSIBLE_OPTS      ?=
ANSIBLE_TAGS      ?=

SHELLCHECK      := $(shell command -v shellcheck 2>/dev/null)
SHELLCHECK_OPTS ?= --exclude=SC1071
SHELL_SCRIPTS   := $(shell find $(DOTFILES)/roles/dotfiles -type f -name *.sh -print)

define assert-set
	@$(if $($1),,$(error $(1) environment variable is not defined))
endef

define assert-file
	@$(if $(wildcard $($1) 2>/dev/null),,$(error $($1) does not exist))
endef


.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z\/_-]+:.*?##/ { printf " %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: test
test:
	$(call assert-set,DOTFILES)
	$(call assert-file,DOTFILES)
	$(call assert-file,HOMEBREW_FILE)

.PHONY: ansible/setup
ansible/setup: ## Install the ansible stuff
	@uv --quiet venv
	@uv --quiet sync

.PHONY: ansible/lint
ansible/lint: ## Run the ansible playbooks in check mode
	@uv run ansible-lint --exclude ./roles/dotfiles/tasks/.ansible ./roles/dotfiles

.PHONY: ansible/check
ansible/check: ## Run the ansible playbooks in check mode
	@uv run ansible-playbook --check $(ANSIBLE_OPTS) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS)

.PHONY: ansible/run
ansible/run: ## Run the ansible playbooks
	@uv run ansible-playbook $(ANSIBLE_OPTS) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS)

.PHONY: shell/lint
shell/lint: ## Lint all the shellscript
	@$(SHELLCHECK) $(SHELLCHECK_OPTS) $(SHELL_SCRIPTS)

.PHONY: homebrew/dump
homebrew/dump: venv/activate ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(HOMEBREW_FILE)

.PHONY: homebrew/load
homebrew/load:
	@brew bundle --file $(HOMEBREW_FILE)

.PHONY: clean
clean:
	@find . -type f -name "*.py[co]" -delete
	@find . -type d -name "__pycache__" -delete
	@rm -fr .venv
