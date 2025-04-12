.DEFAULT_GOAL = help

export SHELL := $(shell type --path bash)

buildc: build ## build continuously
	@watchexec --timings --exts hs,cabal,project cabal -- build --jobs='\$$ncpus' \
	| source-highlight --src-lang=haskell --out-format=esc

build: # lint (breaks on multiple readers) ## build
	cabal build --jobs='$$ncpus' | source-highlight --src-lang=haskell --out-format=esc

install: ## install
	cabal install --enable-prof --install-method=copy --overwrite-policy=always --installdir=bin exe:autoprompt

test: ## test
	cabal test

lint: ## lint
	hlint app src

clean: ## clean
	cabal clean
	find . -name '*~' -o -name '#*' | xargs rm -f

clobber: clean ## clobber
	rm -rf dist-newstyle/*

dev: ## nix develop
	nix develop

package: ## nix build default package
	nix build --impure --verbose --option sandbox relaxed

image: ## nix build docker image
	nix build --impure --verbose --option sandbox relaxed .#docker
	nix build --impure --verbose --option sandbox relaxed .#autoprompt

update-cabal: ## cabal update
	cabal update

update-flake: ## flake update
	nix flake update

run: ## run app
	cabal run ragha

help: ## help
	-@grep --extended-regexp '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed 's/^Makefile://1' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

ssl-cert: KEY=etc/ssl/key.pem
ssl-cert: CSR=etc/ssl/server.csr
ssl-cert: CERT=etc/ssl/cert.pem
ssl-cert: ## create self-signed ssl certificate for dev only
	openssl ecparam -name prime256v1 -genkey -noout -out $(KEY)
	openssl req -new -sha256 -key $(KEY) -out $(CSR)
	openssl x509 -req -sha256 -days 3652 -in $(CSR) -signkey $(KEY) -out $(CERT)
