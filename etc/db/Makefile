.DEFAULT_GOAL = help

migrate: ## db migration
	source ./db-creds && cd schema && cabal run mig

start: ## start dev db
	pg_ctl --pgdata=data --log=/tmp/ragha-db.log start

stop: ## start dev db
	pg_ctl --pgdata=data stop

init: ## init (postgresql) db for dev
	source ./db-creds \
	&& echo $$PGPASSWORD > db-password \
	&& initdb \
		 --username="$$PGUSER" \
	 	 --encoding=UTF8 \
		 --locale=en_US.UTF-8 \
		 --pwfile=db-password \
		 --pgdata=data

create: ## create db
	source ./db-creds \
	&& createdb \
		 --template=template0 \
		 --owner=$$PGUSER \
		 --username="$$PGUSER" \
		 --encoding=UTF8 \
		 --locale=en_US.UTF-8

destroy: ## destroy db (manually remove ./datadir)
	source ./db-creds \
	&& dropdb \
	   --force \
	   --username=$$PGUSER \
	   ragha

clobber: ## remove ./datadir
	rm -rf ./data

db-creds: PGPASSWORD=$(shell cat /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c32)
db-creds: ## create a db-creds file
	@if [ ! -f db-creds ]; then \
		echo "export PGUSER=ragha" > db-creds; \
		echo "export PGPASSWORD=$(PGPASSWORD)" >> db-creds; \
		echo "export PGHOST=localhost" >> db-creds; \
		echo "- db-creds created"; \
	else \
		echo "- the db-creds file exists; will not overwrite"; \
	fi

help: ## help
	-@grep --extended-regexp '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed 's/^Makefile://1' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
