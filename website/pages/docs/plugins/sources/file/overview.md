---
name: File
stage: GA (Premium)
title: File Source Plugin
description: CloudQuery File source plugin documentation
---
# File Source Plugin

:badge{text="Premium"}

This is a premium plugin that you can buy [here](/integrations/file).

The CloudQuery File plugin syncs `parquet` files to any of the supported CloudQuery destinations (e.g. PostgreSQL, BigQuery, Snowflake, and [more](/docs/plugins/destinations/overview)).

### Example

This example configures a File source with a directory to sync files from. The (top level) spec section is described in the [Source Spec Reference](/docs/reference/source-spec).

:configuration

## File spec

This is the (nested) spec used by the File source plugin.

- `files_dir` (string, required)

  Path to the directory with files to sync. Only files with `.parquet` extension will be synced.

- `concurrency` (int, optional, default: 50)

  Number of files to sync in parallel. Negative values mean no limit.

## Example with AWS Cost and Usage Reports

AWS Cost and Usage Reports are stored in S3 as parquet files. The following example shows how to sync these files and AWS infrastructure data to a PostgreSQL database.
To learn more about visualizing AWS Cost and Usage Reports, visit [our dashboards page](/docs/core-concepts/dashboards#cost-optimization).

```yaml
kind: source
spec:
  name: file
  version: "PREMIUM"
  destinations: [postgresql]
  path: /path/to/downloaded/plugin
  tables: ["*"]
  spec:
    files_dir: "/path/to/cost_and_usage_reports" # Update this value to the local directory with your AWS Cost and Usage Reports
---
kind: source
spec:
  name: aws
  version: "VERSION_SOURCE_AWS"
  destinations: [postgresql]
  path: cloudquery/aws
  tables: ["*"]
  skip_tables:
    - aws_ec2_vpc_endpoint_services 
    - aws_cloudtrail_events
    - aws_docdb_cluster_parameter_groups
    - aws_docdb_engine_versions
    - aws_ec2_instance_types
    - aws_elasticache_engine_versions
    - aws_elasticache_parameter_groups
    - aws_elasticache_reserved_cache_nodes_offerings
    - aws_elasticache_service_updates
    - aws_iam_group_last_accessed_details
    - aws_iam_policy_last_accessed_details
    - aws_iam_role_last_accessed_details
    - aws_iam_user_last_accessed_details
    - aws_neptune_cluster_parameter_groups
    - aws_neptune_db_parameter_groups
    - aws_rds_cluster_parameter_groups
    - aws_rds_db_parameter_groups
    - aws_rds_engine_versions
    - aws_servicequotas_services
---
kind: destination
spec:
  name: postgresql
  path: cloudquery/postgresql
  version: "VERSION_DESTINATION_POSTGRESQL"
  spec:
    connection_string: postgresql://postgres:pass@localhost:5432/postgres
```