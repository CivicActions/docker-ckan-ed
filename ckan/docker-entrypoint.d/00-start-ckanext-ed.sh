#!/bin/bash

echo "Preparing ckanext-ed"

paster --plugin=ckanext-ed init_survey_db
paster --plugin=ckanext-ed ed create_ed_vocabularies
paster --plugin=ckanext-ed ed create_ed_groups
paster --plugin=ckanext-ed ed create_ed_organizations
paster --plugin=ckanext-ed ed create_ed_data_explorers
paster --plugin=ckanext-ed init_record_schedule
paster --plugin=ckanext-ed level_column
