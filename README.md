# Docker Compose for the US Deparment of Education

> This is intended just as a development setup. Don't push any production specific configuration or code, specially secrets.

Based on the main [Docker Compose setup](https://github.com/okfn/docker-ckan) for CKAN.

These images and Docker Compose files are used to deploy the US Deparment of Education web app. There are different compose files based on the environment.

For documentation/issues/etc please visit:
- https://github.com/CivicActions/ckanext-ed

# Sensitive data

Some extensions require to include sensitive data, like API keys and credentials files. They are not included in this repository. In order those extensions work properly you will need to include them. You can

- Ask Project Manager for them
- Create dummy accounts, generate Keys and use them

## Google Capcha

Set Google Recaptcha public and private keys in .dev.env

CKAN__RECAPTCHA__PUBLICKEY=YourKey
CKAN__RECAPTCHA__PRIVATEKEY=YourKey

## Analytics (GA-Report)

Generate token.dat file following instructions here https://github.com/CivicActions/ckanext-ga-report#authorization and copy insights into ckan/token.dat. Looks something like

```
{
  "_module": "oauth2client.client",
  "token_expiry": "2019-05-20T06:48:03Z",
  "access_token": "token",
  "token_uri": "https://oauth2.googleapis.com/token",
  "invalid": false,
  "token_response": {
    "access_token": "token",
    "scope": "https://www.googleapis.com/auth/analytics.readonly",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "smaller-token"
  },
  "client_id": "coolid.apps.googleusercontent.com",
  "id_token": null,
  "client_secret": "secret",
  "revoke_uri": "https://accounts.google.com/o/oauth2/revoke",
  "_class": "OAuth2Credentials",
  "refresh_token": "token",
  "user_agent": null
}
```

You will also need service account credentials to track GA events. Something like

```
{
  "type": "service_account",
  "project_id": "us-ed-123456",
  "private_key_id": "private_key",
  "private_key": "-----BEGIN PRIVATE KEY-----
  key-----END PRIVATE KEY-----\n",
  "client_email": "service_acounr_email@us-ed-123456.iam.gserviceaccount.com",
  "client_id": "client_id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/..."
}

```

## Requirement management

When dependencies need to be added, updated, or removed, they should be handled with _poetry_ via `requirements/pyproject.toml`:

1. Make your changes to `requirements/pyproject.toml`.
2. Run `make update-dependencies` (this will update `requirements/poetry.lock` and generate new versions of `requirements.txt`,
`requirements-noh.txt`, and `requirements-dev.txt`).  The file `requirements.txt` will have all the hashable packages listed,
and the file `requirements-noh.txt` will contain the editable source packages and their respective hashes.
3. Commit `ckan/requirements.txt`, `ckan/requirements-noh.txt`, `ckan/requirements-dev.txt`, `requirements/pyproject.toml`, and `requirements/poetry.lock`.

> **NOTE:** `make update-dependencies` and all `poetry` commands should be run with `poetry==1.1.14` (earlier/later versions _might_ work—haven't been tested), installed within a **Python 3.6.8** environment using `pip==21.3.1`.

# Development

## Setup

To run the environment, run:

    make setup

After the environment builds and attempts to start up, it will get stuck trying to call `edcli`. This is because `ckanext-ed` is not enabled yet. CKAN will fail to initialize its own DB if the extension is enabled. Once you get stuck there, you can ctrl-c out of the command. Then add the following plugins to the `.env` file _between_ (this is important) `datajson_harvest` and `resource_proxy`:

```
ed edharvest eddatajsonharvest ed_sources ed_stats ed_hierarchy_display ed_hierarchy_form documentation ed_collections ed_data_explorers ed_format_translator ed_resource_approval
```

The plugins should look like this:

```
CKAN__PLUGINS=saml2auth datastore xloader dataexplorer_view dataexplorer_table_view dataexplorer_chart_view dataexplorer_map_view ckan_harvester datajson_harvest ed edharvest eddatajsonharvest ed_sources ed_stats ed_hierarchy_display ed_hierarchy_form documentation ed_collections ed_data_explorers ed_format_translator ed_resource_approvalresource_proxy deadoralive pages googleanalytics showcase envvars
```

Finally, you can run the following to get the environment up and running:

    make up
