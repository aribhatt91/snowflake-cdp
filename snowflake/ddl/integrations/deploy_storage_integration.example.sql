-- Template for deploy_storage_integration.sql (that file is git-ignored).
-- Copy this file, rename it, and fill in real values locally.

EXECUTE IMMEDIATE FROM @GIT_INTEGRATION_DB.GITHUB_SCHEMA.CDP_REPO/branches/main/snowflake/ddl/integrations/storage_integration.sql
    USING (
        env          => 'prod',
        aws_role_arn => 'arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>',
        s3_bucket    => '<BUCKET_NAME>',
        s3_prefix    => 'snowplow/'
    );

DESC INTEGRATION PROD_SNOWPLOW_S3_INTEGRATION;
