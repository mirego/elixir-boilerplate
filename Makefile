# Configuration
# -------------

APP_NAME = `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VERSION = `grep 'version:' mix.exs | cut -d '"' -f2`
GIT_REVISION = `git rev-parse HEAD`
DOCKER_IMAGE_TAG ?= latest
DOCKER_REGISTRY ?=

# Introspection targets
# ---------------------

.PHONY: help
help: header targets

.PHONY: header
header:
	@echo "\033[34mEnvironment\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@printf "\033[33m%-23s\033[0m" "APP_NAME"
	@printf "\033[35m%s\033[0m" $(APP_NAME)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "APP_VERSION"
	@printf "\033[35m%s\033[0m" $(APP_VERSION)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "GIT_REVISION"
	@printf "\033[35m%s\033[0m" $(GIT_REVISION)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "DOCKER_IMAGE_TAG"
	@printf "\033[35m%s\033[0m" $(DOCKER_IMAGE_TAG)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "DOCKER_REGISTRY"
	@printf "\033[35m%s\033[0m" $(DOCKER_REGISTRY)
	@echo "\n"

.PHONY: targets
targets:
	@echo "\033[34mTargets\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# Build targets
# -------------

.PHONY: dependencies
dependencies: dependencies-mix dependencies-npm ## Install dependencies required by the application

.PHONY: dependencies-mix
dependencies-mix:
	mix deps.get --force

.PHONY: dependencies-npm
dependencies-npm:
	npm install --prefix assets

.PHONY: build
build: ## Build the Docker image for the OTP release
	docker build --build-arg APP_NAME=$(APP_NAME) --build-arg APP_VERSION=$(APP_VERSION) --rm --tag $(APP_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: push
push: ## Push the Docker image
	docker tag $(APP_NAME):$(DOCKER_IMAGE_TAG) $(DOCKER_REGISTRY)/$(APP_NAME):$(DOCKER_IMAGE_TAG)
	docker push $(DOCKER_REGISTRY)/$(APP_NAME):$(DOCKER_IMAGE_TAG)

# CI targets
# ----------

.PHONY: lint
lint: lint-compile lint-format lint-credo lint-eslint lint-stylelint lint-prettier ## Run lint tools on the code

.PHONY: lint-compile
lint-compile:
	mix compile --warnings-as-errors --force

.PHONY: lint-format
lint-format:
	mix format --dry-run --check-formatted

.PHONY: lint-credo
lint-credo:
	mix credo --strict

.PHONY: lint-eslint
lint-eslint:
	./assets/node_modules/.bin/eslint --ignore-path assets/.eslintignore --config assets

.PHONY: lint-stylelint
lint-stylelint:
	./assets/node_modules/.bin/stylelint --syntax scss --config assets/.stylelintrc assets/css

.PHONY: lint-prettier
lint-prettier:
	./assets/node_modules/.bin/prettier -l assets/.babelrc assets/webpack.config.js 'assets/{js,css,scripts}/**/*.{js,graphql,scss,css}' '**/*.md'

.PHONY: test
test: ## Run the test suite
	mix test

.PHONY: test-coverage
test-coverage: ## Generate the code coverage report
	mix coveralls

.PHONY: dialyze
dialyze: ## Run Dialyzer on the code
	mix dialyzer --halt-exit-status --format dialyxir

.PHONY: format
format: format-elixir format-prettier ## Run formatting tools on the code

.PHONY: format-elixir
format-elixir:
	mix format

.PHONY: format-prettier
format-prettier:
	./assets/node_modules/.bin/prettier --write 'assets/.babelrc' 'assets/webpack.config.js' 'assets/{js,css,scripts}/**/*.{js,graphql,scss,css}' '**/*.md'

# Development targets
# -------------------

.PHONY: dev-start-postgresql
dev-start-postgresql: ## Run a PostgreSQL server inside of a Docker Compose environment
	docker-compose up --detach postgresql

.PHONY: dev-start-application
dev-start-application: build ## Run the OTP release inside of a Docker Compose environment
	docker-compose up application

.PHONY: dev-start
dev-start: build ## Start every service of in the Docker Compose environment
	docker-compose up

.PHONY: dev-stop
dev-stop: ## Stop every service of in the Docker Compose environment
	docker-compose down
