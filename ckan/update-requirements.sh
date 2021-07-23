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
grep -v https: ../ckan/requirements.tmp > ../ckan/requirements.txt
grep -v https: ../ckan/requirements-dev.tmp > ../ckan/requirements-dev.txt
# Now create the requirements-noh.txt for editable sources with their commit hash
> ../ckan/requirements-noh.txt
for i in `grep https pyproject.toml | awk -F/ '{print $4"/"$5}' | awk -F\. '{print $1}'`
  do
    echo $i
    MYHASH=`grep -A3 "url = \"https://github.com/${i}\." poetry.lock | grep resolved | awk -F\" '{print $2}'`
    echo "-e git+https://github.com/${i}.git@${MYHASH}#egg=${i}" >> ../ckan/requirements-noh.txt
  done

# Clean up
rm -f ../ckan/requirements.tmp ../ckan/requirements-dev.tmp ../ckan/requirements-noh.tmp
################################################### End of Non-Hashable items elimination

# manually add ckanext-ed as a commented requirement for now
echo "#-e git+https://github.com/CivicActions/ckanext-ed.git#egg=ckanext-ed" >> ../ckan/requirements-noh.txt

poetry show --tree

