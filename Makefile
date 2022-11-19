.PHONY: help all docker-images composer composer-nodev start stop sh test build build-dev clean purge
.DEFAULT := help

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MAKEFILE_PATH))

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)



##@ Development

all: docker-images composer test build-dev ## Setup, test & build phar
	cd "${CURRENT_DIR}" && ./build/phar-skeleton.phar

docker-images: ## Create docker images
	docker-compose up --no-start --build

composer: ## Install composer dependencies
	docker-compose run --rm -- php73 composer install -v -n -d /app

composer-nodev: ## Install composer without DEV dependencies
	docker-compose run --rm -e COMPOSER_NO_DEV=1 -- php73 composer install -v -n -d /app

start: ## Start services in background
	docker-compose start

stop: ## Stop services
	docker-compose stop

sh: ## Open shell in container
	docker-compose exec -- php73 /bin/sh

test: ## Run tests
	docker-compose run --rm -- php73 /app/tests/run.sh
	docker-compose run --rm -- php74 /app/tests/run.sh
	docker-compose run --rm -- php80 /app/tests/run.sh
	docker-compose run --rm -- php81 /app/tests/run.sh

build: clean composer-nodev build-dev ## Build PHAR

build-dev: clean ## Build PHAR with DEV dependencies
	docker-compose run --rm -e PHAR_SKELETON_ALIAS="phar-skeleton.phar" -e PHAR_SKELETON_NAMESPACE="Zebooka" -- php73 /app/build-phar.php

clean: ## Clean built PHAR
	cd "${CURRENT_DIR}" && rm -fv ./build/phar-skeleton.phar

purge: stop clean ## Stop, clean and remove all docker-images/logs/vendor files
	docker-compose down --rmi local
	cd "${CURRENT_DIR}" && rm -rfv ./log ./vendor
