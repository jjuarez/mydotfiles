#!/usr/bin/env make

CONFIG_FILE ?= dotfiles.cfg
-include $(CONFIG_FILE)

.DEFAULT_GOAL  := help
.DEFAULT_SHELL := /bin/bash

BREW_FILE := $(DOTFILES)/tools/brew/Brewfile


.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z//_-]+:.*?##/ { printf " %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)


.PHONY: brew/dump
brew/dump: ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(BREW_FILE)
.PHONY: brew/install
brew/install: ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle --file $(BREW_FILE)

.PHONY: brew/install
brew/uninstall: ## Show the help to install homebrew
	@echo "To uninstall the homebrew support, just take a look here: $(HOME_BREW_URL)"


.PHONY: dotfiles/install
dotfiles/install: ## Install the dotfiles
	@echo dotfiles/install

.PHONY: dotfiles/uninstall
dotfiles/uninstall: ## Uninstall the dotfiles
	@echo dotfiles/uninstall
