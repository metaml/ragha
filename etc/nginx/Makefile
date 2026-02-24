start: ## start nginx
	sudo --user=$$(whoami) -- nginx -p . -e /tmp/error.log

test: ## test nginx.conf
	nginx -p . -t
