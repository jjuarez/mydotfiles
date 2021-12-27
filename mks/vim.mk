VIM_PLUG_URL := $(shell yq e '.urls.vim.plug' $(CONFIG_FILE))


.PHONY: vim/install
vim/install: ## Install vim plug support
	@ln -nfs $(DOTFILES)/editors/vim/.vimrc $(HOME)/.vimrc
	@ln -nfs $(DOTFILES)/editors/vim/.vimrc.local $(HOME)/.vimrc.local
	@test -d "$(HOME)/.vim/autoload/plug.vim" || \
	curl -sfLo $(HOME)/.vim/autoload/plug.vim --create-dirs $(VIM_PLUG_URL)

.PHONY: vim/uninstall
vim/uninstall: ## Uninstall vim plug support
	rm -fr $(HOME)/.vimrc $(HOME)/.vimrc.local $(HOME)/.vim
