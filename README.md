# snowflake-cdp

### Create Github integration in Snowflake
In your Github account generate a Fine-grained personal access token with **Read** access to `Metadata` and **Read and Write** access to `Code` and `Pull`

After that execute the following code in Snowsight to create a Git integration and clone your GitHub repository

```sql
-- 1. Create and select a database and schema (or use existing ones)
CREATE DATABASE IF NOT EXISTS git_integration_db;
CREATE SCHEMA IF NOT EXISTS git_integration_db.github_schema;

USE DATABASE git_integration_db;
USE SCHEMA github_schema;

-- 2. Create the Secret inside the active schema
CREATE OR REPLACE SECRET my_github_secret
  TYPE = password
  USERNAME = '<your_github_username>'
  PASSWORD = '<your_fine_grained_pat>';

-- 3. Create the account-level API Integration
CREATE OR REPLACE API INTEGRATION my_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com<org_or_username>/')
  ALLOWED_AUTHENTICATION_SECRETS = (git_integration_db.github_schema.my_github_secret)
  ENABLED = TRUE;

-- 4. Create the Git Repository object inside the active schema
CREATE OR REPLACE GIT REPOSITORY my_snowflake_repo
  API_INTEGRATION = my_git_api_integration
  GIT_CREDENTIALS = my_github_secret
  ORIGIN = 'https://github.com<org_or_username>/<repo_name>.git';

```
