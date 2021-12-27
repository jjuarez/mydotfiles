#!/usr/bin/env make

DOTFILES    ?= $(HOME)/.mydotfiles
CONFIG_FILE ?= $(DOTFILES)/config.yml

.DEFAULT_GOAL  := help
.DEFAULT_SHELL := /bin/bash


define assert-set
	@$(if $($1),,$(error $(1) environment variable is not defined))
endef

define assert-command
	@$(if $(shell command -v $1 2>/dev/null),,$(error $(1) command not found))
endef

define assert-file
	@$(if $(wildcard $($1) 2>/dev/null),,$(error $($1) does not exist))
endef

-include $(DOTFILES)/mks/zim.mk
-include $(DOTFILES)/mks/dotfiles.mk
-include $(DOTFILES)/mks/ssh.mk
-include $(DOTFILES)/mks/vim.mk
-include $(DOTFILES)/mks/homebrew.mk


.PHONY: all
all: help

.PHONY: test
test:
	$(warning Just to pass the Makefile lint)

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z//_-]+:.*?##/ { printf " %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
