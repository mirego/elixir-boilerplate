.PHONY: help build

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VERSION ?= `grep 'version:' mix.exs | cut -d '"' -f2`
IMAGE_TAG ?= 'latest'
BUILD ?= `git rev-parse --short HEAD`

help:
	@echo "$(APP_NAME):$(APP_VERSION)-$(BUILD) → phoenix_boilerplate:${IMAGE_TAG}"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	docker build \
		--file infra/docker/Dockerfile \
		--build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VERSION=$(APP_VERSION) \
		--rm \
		--tag phoenix_boilerplate:$(IMAGE_TAG) \
		.

COMPOSE_FILE = 'infra/docker/docker-compose.yml'

start: ## Start the docker-compose environments
	docker-compose --file $(COMPOSE_FILE) up --detach postgres	
	docker-compose --file $(COMPOSE_FILE) up api

stop: ## Stop the docker-compose  environments
	docker-compose --file $(COMPOSE_FILE) down

