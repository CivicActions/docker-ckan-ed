#! /bin/bash -x

# Updates poetry.lock and exports requirements to .txt files

cd requirements

echo "Running poetry lock ..."
poetry lock -vvv
echo "Running poetry export ..."

###### Process to gather hashes for editable sources #############################################
poetry export -vvv --format requirements.txt --output ../ckan/requirements.tmp
poetry export --dev -vvv --format requirements.txt --output ../ckan/requirements-dev.tmp
# Now extract the packages that require editable (non-hashed) source from the hashable packages
grep -v https: ../ckan/requirements.tmp > ../ckan/requirements.txt
pip-compile --generate-hashes -o ../ckan/requirements.txt ../ckan/requirements.txt
grep -v https: ../ckan/requirements-dev.tmp > ../ckan/requirements-dev.txt

# Now create the requirements-noh.txt for editable sources with their commit hash

# truncate output file
> ../ckan/requirements-noh.txt
# First get the list of editable sources
for i in `grep https pyproject.toml | awk -F/ '{print $4"/"$5}' | awk -F\. '{print $1}'`
  do
    # For each of the editable sources get the repo type and type-value
    TYP=`grep https pyproject.toml | grep "${i}\." | awk -F\" '{print $3}' | awk '{print $2}'`
    TYPVAL=`grep https pyproject.toml | grep "${i}\."| awk -F\" '{print $4}'`
    case ${TYP} in
      rev)
        MYHASH=${TYPVAL}
      ;;
      tag)
        MYHASH=`curl https://api.github.com/repos/${i}/tags?per_page=1000 | grep -A4 ${TYPVAL} | grep sha | awk -F\" '{print $4}'`
      ;;
      branch)
        MYHASH=`curl https://api.github.com/repos/${i}/branches/${TYPVAL} | head -6 | grep sha | awk -F\" '{print $4}'`
      ;;
      default)
    esac
    PKG=`echo $i | awk -F/ '{print $2}'`
    echo "-e git+https://github.com/${i}.git@${MYHASH}#egg=${PKG}" >> ../ckan/requirements-noh.txt
  done

# Clean up
rm -f ../ckan/requirements.tmp ../ckan/requirements-dev.tmp ../ckan/requirements-noh.tmp
################################################### End of hash gathering for editable sourcces ######

# manually add ckanext-ed as a commented requirement for now
echo "#-e git+https://github.com/CivicActions/ckanext-ed.git#egg=ckanext-ed" >> ../ckan/requirements-noh.txt

poetry show --tree

