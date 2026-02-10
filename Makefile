.DEFAULT_GOAL = help

export SHELL := $(shell type --path bash)

buildc: build ## build continuously
	@watchexec --timings --exts hs,cabal,project cabal -- build --jobs='\$$ncpus' \
	| source-highlight --src-lang=haskell --out-format=esc

build: # lint (breaks on multiple readers) ## build
	cabal build --jobs='$$ncpus' | source-highlight --src-lang=haskell --out-format=esc

install: ## install
	cabal install --enable-profiling --install-method=copy --overwrite-policy=always --installdir=bin exe:bot

test: ## test
	cabal test

lint: ## lint
	hlint --git app src

repl: ## repl
	cabal repl

clean: ## clean
	cabal clean
	find . -name '*~' -o -name '#*' | xargs rm -f

clobber: clean ## clobber
	rm -rf dist-newstyle/*

clobber-venv: ## clobber venv
	rm -rf venv/*

dev: ## nix develop
	nix develop

package: ## nix build default package
	nix build --impure --verbose --option sandbox relaxed

image: ## nix build docker image
	nix build --impure --verbose --option sandbox relaxed .#docker
	nix build --impure --verbose --option sandbox relaxed .#autoprompt

dev-update: flake-update cabal-update ## update dev

cabal-update: ## cabal update
	cabal update

flake-update: ## flake update
	nix flake update

run: BIN ?= ragha
run: ## run app
	cabal run $(BIN)

python-pkgs: ## install packages from requirements.txt
	pip install --requirement=requirements.txt

help: ## help
	-@grep --extended-regexp '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed 's/^Makefile://1' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

psql: ## connect to dev db
	source etc/db/db-creds && psql

ssl-cert: KEY=etc/ssl/key.pem
ssl-cert: CSR=etc/ssl/server.csr
ssl-cert: CERT=etc/ssl/cert.pem
ssl-cert: ## create self-signed ssl certificate for dev only
	openssl ecparam -name prime256v1 -genkey -noout -out $(KEY)
	openssl req -new -sha256 -key $(KEY) -out $(CSR)
	openssl x509 -req -sha256 -days 3652 -in $(CSR) -signkey $(KEY) -out $(CERT)
