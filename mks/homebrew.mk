HOMEBREW_FILE := $(DOTFILES)/tools/homebrew/Brewfile


.PHONY: homebrew/dump
homebrew/dump: ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(HOMEBREW_FILE)

.PHONY: homebrew/load
homebrew/load: ## Load and install a snapshot of your formulas, casks, taps, etc
	$(call assert-file,HOMEBREW_FILE)
	@brew bundle --file $(HOMEBREW_FILE)
