#!/usr/bin/env python3
import toml

# Load the poetry.lock file and output it in toml format to be parsed by
# update-requirements.sh

config_file = (toml.load("requirements/poetry.lock"))
data = (toml.load("requirements/poetry.lock"))
with open('requirements/poetry-lock-dump.txt', 'w') as f:
  print (toml.dumps(data), file=f)

