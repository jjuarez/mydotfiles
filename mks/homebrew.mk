HOMEBREW_FILE          := $(DOTFILES)/tools/homebrew/Brewfile
HOMEBREW_INSTALL_URL   := $(shell yq e '.urls.homebrew.install' $(CONFIG_FILE))
HOMEBREW_UNINSTALL_URL := $(shell yq e '.urls.homebrew.uninstall' $(CONFIG_FILE))

.PHONY: homebrew/install
homebrew/install: ## Homebrew install
	@echo "To uninstall the homebrew support, take a look here: $(HOMEBREW_INSTALL_URL)"

.PHONY: homebrew/uninstall
homebrew/uninstall: ## Homebrew uninstall
	@echo "To uninstall the homebrew support, take a look here: $(HOMEBREW_UNINSTALL_URL))"

.PHONY: homebrew/dump
homebrew/dump: ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(HOMEBREW_FILE)

.PHONY: homebrew/load
homebrew/load: ## Load and install a snapshot of your formulas, casks, taps, etc
	$(call assert-file,HOMEBREW_FILE)
	@brew bundle --file $(HOMEBREW_FILE)
