# Build configuration
# -------------------

APP_NAME = `grep -Eo 'app: :\w*' mix.exs | cut -d ':' -f 3`
APP_VERSION = `grep -Eo '@version "[0-9\.]*"' mix.exs | cut -d '"' -f 2`
GIT_REVISION = `git rev-parse HEAD`
DOCKER_IMAGE_TAG ?= latest
DOCKER_REGISTRY ?=

# Linter and formatter configuration
# ----------------------------------

PRETTIER_FILES_PATTERN = 'assets/.babelrc' 'assets/webpack.config.js' 'assets/{js,css,scripts}/**/*.{js,graphql,scss,css}' '**/*.md'
STYLES_PATTERN = assets/css

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

.PHONY: build
build: ## Build the Docker image for the OTP release
	docker build --build-arg APP_NAME=$(APP_NAME) --build-arg APP_VERSION=$(APP_VERSION) --rm --tag $(APP_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: push
push: ## Push the Docker image
	docker tag $(APP_NAME):$(DOCKER_IMAGE_TAG) $(DOCKER_REGISTRY)/$(APP_NAME):$(DOCKER_IMAGE_TAG)
	docker push $(DOCKER_REGISTRY)/$(APP_NAME):$(DOCKER_IMAGE_TAG)

# Development targets
# -------------------

.PHONY: dependencies
dependencies: ## Install dependencies required by the application
	mix deps.get --force
	npm install --prefix assets

.PHONY: test
test: ## Run the test suite
	mix test

# Check, lint and format targets
# ------------------------------

.PHONY: check-code-coverage
check-code-coverage:
	mix coveralls

.PHONY: check-code-security
check-code-security:
	mix sobelow --config

.PHONY: check-format
check-format:
	mix format --dry-run --check-formatted
	./assets/node_modules/.bin/prettier --check $(PRETTIER_FILES_PATTERN)

.PHONY: check-unused-locked-dependencies
check-unused-locked-dependencies:
	mix check.unused_locked_deps

.PHONY: format
format: ## Format project files
	mix format
	./assets/node_modules/.bin/prettier --write $(PRETTIER_FILES_PATTERN)

.PHONY: lint
lint: lint-elixir lint-scripts lint-styles ## Lint project files

.PHONY: lint-elixir
lint-elixir:
	mix compile --warnings-as-errors --force
	mix credo --strict

.PHONY: lint-scripts
lint-scripts:
	./assets/node_modules/.bin/eslint --ignore-path assets/.eslintignore --config assets/.eslintrc assets

.PHONY: lint-styles
lint-styles:
	./assets/node_modules/.bin/stylelint --syntax scss --config assets/.stylelintrc $(STYLES_PATTERN)
