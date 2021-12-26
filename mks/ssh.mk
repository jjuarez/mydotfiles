PHONY: ssh/install
ssh/install: ## SSH install custom configuration
	@test -f $(DOTFILES)/tools/ssh/config && \
	cp $(DOTFILES)/tools/ssh/config $(HOME)/.ssh/config 2>/dev/null

PHONY: ssh/uninstall
ssh/uninstall: ## SSH uninstall custom configuration
	@test -f $(HOME)/.ssh/config && rm -f $(HOME)/.ssh/config
