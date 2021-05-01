#! /bin/bash

# Updates poetry.lock and exports requirements to .txt files


cd requirements

echo "Running poetry lock ..."
poetry lock -vvv
echo "Running poetry export ..."
poetry export -vvv --format requirements.txt --output ../ckan/requirements.txt --without-hashes
poetry export --dev -vvv --format requirements.txt --output ../ckan/requirements-dev.txt --without-hashes

# manually add ckanext-ed as a commented requirement for now

echo "#-e git+https://github.com/CivicActions/ckanext-ed.git#egg=ckanext-ed" >> ../ckan/requirements.txt
echo "#-e git+https://github.com/CivicActions/ckanext-ed.git#egg=ckanext-ed" >> ../ckan/requirements-dev.txt

poetry show --tree
