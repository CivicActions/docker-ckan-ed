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
	./ckan/update-requirements.sh

freeze-dependencies:
	docker-compose -f $(DOCKER_COMPOSE_YML) run --rm -T $(CKAN_CONTAINER) pip --quiet freeze > ckan/requirements-freeze.txt
	echo "#-e git+https://github.com/CivicActions/ckanext-ed.git#egg=ckanext-ed" >> ckan/requirements-freeze.txt

search-index-rebuild:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini search-index rebuild

harvest-fetch-queue:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini harvester fetch-consumer

harvest-gather-queue:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini harvester gather-consumer

harvest-run:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini harvester run

access-db:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_DB) /bin/bash -c "psql -U ckan"

shell:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) /bin/bash

cypress-tests:
	cd src/ckanext-ed/tests && node test.js

run-seeds:
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli init-survey-db
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli init-record-schedule
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli populate-recordsdb
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli ed create_ed_vocabularies
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli ed create_ed_groups
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli ed create_ed_organizations
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli ed create_ed_data_explorers
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli level-column
	docker-compose -f $(DOCKER_COMPOSE_YML) exec $(CKAN_CONTAINER) ckan -c ckan.ini edcli omb-to-sources
