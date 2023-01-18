#!/bin/bash

echo "Preparing ckanext-ed"

ckan -c ckan.ini edcli init-survey-db
ckan -c ckan.ini edcli init-record-schedule
ckan -c ckan.ini edcli populate-recordsdb
ckan -c ckan.ini edcli ed create_ed_vocabularies
ckan -c ckan.ini edcli ed create_ed_groups
ckan -c ckan.ini edcli ed create_ed_organizations
ckan -c ckan.ini edcli ed create_ed_data_explorers
ckan -c ckan.ini edcli level-column
ckan -c ckan.ini edcli omb-to-sources
ckan -c ckan.ini edcli init-coordinators
