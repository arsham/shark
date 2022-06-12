.PHONY: test
test:
	@nvim --headless --noplugin -u scripts/minimal_init.vim -c "PlenaryBustedDirectory lua/spec"

.PHONY: test_watch
test_watch:
	@reflex -d none -r "\.lua$$" -- zsh -c "nvim --headless --noplugin -u scripts/minimal_init.vim -c 'PlenaryBustedDirectory lua/spec'"

.PHONY: lint
lint:
	@selene lua after syntax
