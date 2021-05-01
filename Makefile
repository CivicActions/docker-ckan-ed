.PHONY:

CKAN_HOME := /srv/app
DOCKER_COMPOSE_YML := docker-compose.dev.yml
CKAN_CONTAINER := ckan-dev
CKAN_DB := db

build:
	docker-compose -f $(DOCKER_COMPOSE_YML) build

clean:
	docker-compose -f $(DOCKER_COMPOSE_YML) down -v --remove-orphans

up:
	docker-compose -f $(DOCKER_COMPOSE_YML) up

down:
	docker-compose -f $(DOCKER_COMPOSE_YML) down

restart:
	docker-compose -f $(DOCKER_COMPOSE_YML) restart

ckanext-ed:
	git clone git@github.com:CivicActions/ckanext-ed.git src/ckanext-ed

setup:
	git clone git@github.com:CivicActions/ckanext-ed.git src/ckanext-ed || true
	docker-compose -f $(DOCKER_COMPOSE_YML) build
	docker-compose -f $(DOCKER_COMPOSE_YML) up

update-dependencies:
	./ckan/freeze-requirements.sh

search-index-rebuild:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) paster --plugin=ckan search-index rebuild

harvest-fetch-queue:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) paster --plugin=ckanext-harvest harvester fetch_consumer

harvest-gather-queue:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) paster --plugin=ckanext-harvest harvester gather_consumer

harvest-run:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) paster --plugin=ckanext-harvest harvester run

access-db:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_DB) /bin/bash -c "psql -U ckan"

cypress-tests:
	cd src/ckanext-ed/tests && node test.js
