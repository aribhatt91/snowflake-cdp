-- Storage integration for the Snowplow S3 landing bucket.
-- Templated with Jinja: environment-specific values are injected at deploy time
-- via EXECUTE IMMEDIATE FROM ... USING (see deploy_storage_integration.sql).
-- Required variables: env, aws_role_arn, s3_bucket
-- Optional variables: s3_prefix (default: snowplow/), owner_role (default: CDP_INTEGRATION_ADMIN)

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS {{ env | upper }}_SNOWPLOW_S3_INTEGRATION
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = '{{ aws_role_arn }}'
    STORAGE_ALLOWED_LOCATIONS = ('s3://{{ s3_bucket }}/{{ s3_prefix | default("snowplow/") }}')
    COMMENT = 'Read access to Snowplow landing data ({{ env }})';

-- Hand ownership to a dedicated admin role so ACCOUNTADMIN is not needed day to day
GRANT OWNERSHIP ON INTEGRATION {{ env | upper }}_SNOWPLOW_S3_INTEGRATION
    TO ROLE {{ owner_role | default("CDP_INTEGRATION_ADMIN") }} COPY CURRENT GRANTS;
