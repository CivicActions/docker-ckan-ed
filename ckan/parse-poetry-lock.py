#!/usr/bin/env python3
import toml

# Load the poetry.lock file and output it in toml format to be parsed by
# update-requirements.sh

data = (toml.load("poetry.lock"))
with open('poetry-lock-dump.txt', 'w') as f:
  print (toml.dumps(data), file=f)

