#! /bin/bash

# Updates poetry.lock and exports requirements to .txt files


cd requirements

echo "Running poetry lock ..."
poetry lock -vvv
echo "Running poetry export ..."
# Process to eliminate non-hashable sources #############################################
poetry export -vvv --format requirements.txt --output ../ckan/requirements.tmp
poetry export --dev -vvv --format requirements.txt --output ../ckan/requirements-dev.tmp
# Now extract the packages that require editable (non-hashed) source from the hashable packages
grep -v https ../ckan/requirements.tmp > ../ckan/requirements.txt
grep -v https ../ckan/requirements-dev.tmp > ../ckan/requirements-dev.txt
# Now extract the packages that require editable (non-hashed) source from the hashable packages
grep https ../ckan/requirements-freeze.txt | grep -v httplib > ../ckan/requirements-noh.txt
################################################### End of Non-Hashable items elimination

# Clean up
rm -f ../ckan/requirements.tmp ../ckan/requirements-dev.tmp ../ckan/requirements-noh.tmp

poetry show --tree

