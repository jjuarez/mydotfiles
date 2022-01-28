#!/usr/bin/env make

.DEFAULT_GOAL  := help
.DEFAULT_SHELL := /bin/bash

DOTFILES      ?= $(HOME)/.mydotfiles
HOMEBREW_FILE := $(DOTFILES)/backups/homebrew/Brewfile


define assert-set
	@$(if $($1),,$(error $(1) environment variable is not defined))
endef

define assert-command
	@$(if $(shell command -v $1 2>/dev/null),,$(error $(1) command not found))
endef

define assert-file
	@$(if $(wildcard $($1) 2>/dev/null),,$(error $($1) does not exist))
endef


.PHONY: test
test:
	$(call assert-set,DOTFILES)
	$(call assert-file,DOTFILES)

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z//_-]+:.*?##/ { printf " %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: homebrew/dump
homebrew/dump: ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(HOMEBREW_FILE)

.PHONY: homebrew/load
homebrew/load: ## Load and install a snapshot of your formulas, casks, taps, etc
	$(call assert-file,HOMEBREW_FILE)
	@brew bundle --file $(HOMEBREW_FILE)
