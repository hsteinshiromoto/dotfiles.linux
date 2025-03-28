SHELL:=/bin/bash

default: help

PROJECT_ROOT=$(git rev-parse --show-toplevel)
PLAYBOOK_PACKAGES=packages.yml
PLAYBOOK_DOTFILES=dotfiles.yml

.PHONY: clean help tree playbook

## Changelog
changelog:
	git cliff --unreleased --prepend CHANGELOG.md

## Install OS Packages
packages:
	@echo "Running Playbook ${PLAYBOOK_PACKAGES}" 
	ansible-playbook --ask-become-pass -C ${PLAYBOOK_PACKAGES} 

## Setup Dotfiles
dotfiles: packages
	@echo "Running Playbook ${PLAYBOOK_DOTFILES}" 
	ansible-playbook --ask-become-pass -C ${PLAYBOOK_DOTFILES}  

## Build NeoVim Docker Image
nvim:
	docker buildx build -f nvim.Dockerfile -t ghcr.io/hsteinshiromoto/dotfiles.linux/dotfiles.linux:nvim . 

## Image
build: 
	docker build --no-cache -t test_ansible:latest .

run:
	docker run -it test_ansible:latest /bin/zsh


## Print tree
tree:
	tree -ad -I .git -I .*cache

## Remove log flies
clean:
	rm -r *.log

# ---
# Self Documenting Commands
# ---

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
