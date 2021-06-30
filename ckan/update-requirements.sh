#! /bin/bash

# Updates poetry.lock and exports requirements to .txt files


cd requirements

echo "Running poetry lock ..."
poetry lock -vvv
echo "Running poetry export ..."
poetry export -vvv --format requirements.txt --output ../ckan/requirements.tmp
poetry export --dev -vvv --format requirements.txt --output ../ckan/requirements-dev.tmp
# Now extract the packages that require editable (non-hashed) source from the hashable packages
grep -v https ../ckan/requirements.tmp > ../ckan/requirements.txt
grep -v https ../ckan/requirements-dev.tmp > ../ckan/requirements-dev.txt

# Now extract out the non-hashed items and adjust the content to support proper input format
grep https ../ckan/requirements.tmp > ../ckan/requirements-noh.tmp
# Define Constant PREFIX and Initialize the output file
PREFIX="-e git+https://github.com/"
> ../ckan/requirements-noh.txt

# Eliminate spaces and @ symbols from the tmp file to make things easier
sed -i 's/ \@ /:/g' ../ckan/requirements-noh.tmp
# Generate the required format
for i in `cat ../ckan/requirements-noh.tmp`; do PKGNM=`echo $i | awk -F: '{print $1}'`; PKGDTL=`echo $i | awk -F/ '{print $4"/"$5}'`;echo "${PREFIX}${PKGDTL}#egg=${PKGNM}" >> ../ckan/requirements-noh.txt ; done

# manually add ckanext-ed as a commented requirement for now
echo "#-e git+https://github.com/CivicActions/ckanext-ed.git#egg=ckanext-ed" >> ../ckan/requirements-noh.txt

# Clean up
rm -f ../ckan/requirements.tmp ../ckan/requirements-dev.tmp ../ckan/requirements-noh.tmp

poetry show --tree
