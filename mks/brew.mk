BREW      := $(shell command -v brew 2>/dev/null)
BREW_FILE := $(DOTFILES)/tools/brew/Brewfile


.PHONY: brew/dump
brew/dump: ## Save a snapshot of your formulas, casks, taps, etc
	@brew bundle dump --force --file $(BREW_FILE)

.PHONY: brew/install
brew/install: ## Save a snapshot of your formulas, casks, taps, etc
	$(call assert-file,BREW_FILE)
	@brew bundle --file $(BREW_FILE)

.PHONY: brew/install
brew/uninstall: ## Show the help to install homebrew
	@echo "To uninstall the homebrew support, just take a look here: $(HOME_BREW_URL)"
