---
name: PostgreSQL
title: PostgreSQL Source Plugin
description: CloudQuery PostgreSQL source plugin documentation
---
# PostgreSQL Source Plugin

:badge

The CloudQuery PostgreSQL plugin syncs your PostgreSQL database to any of the supported CloudQuery destinations (e.g. PostgreSQL, BigQuery, Snowflake, and [more](/docs/plugins/destinations/overview)).
This plugin also supports CDC via PostgreSQL logical replication, which enables keeping your PostgreSQL up to date with any destination by subscribing to changes.

Supported database versions:

- PostgreSQL >= v11 (Needed for CDC, logical replication).
- PostgreSQL >= v10 (If no need for CDC).

### Example

This example configures a PostgreSQL source, located at `localhost:5432`. The (top level) spec section is described in the [Source Spec Reference](/docs/reference/source-spec).

```yaml copy
kind: source
spec:
  name: "postgresql"
  registry: "github"
  path: "cloudquery/postgresql"
  version: "VERSION_SOURCE_POSTGRESQL"
  tables: ["*"]

  spec:
    connection_string: "postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable"
```

:::callout{type="info"}
Make sure you use environment variable expansion in production instead of committing the credentials to the configuration file directly.
:::

### PostgreSQL Spec

This is the (nested) spec used by the PostgreSQL source Plugin.

- `connection_string` (`string`, required)

  Connection string to connect to the database. This can be a URL or a DSN, as per [`pgxpool`](https://pkg.go.dev/github.com/jackc/pgx/v4/pgxpool#ParseConfig)

  - `"postgres://jack:secret@localhost:5432/mydb?sslmode=prefer"` _connect with tcp and prefer TLS_
  - `"postgres://jack:secret@localhost:5432/mydb?sslmode=disable&application_name=pgxtest&search_path=myschema&connect_timeout=5"` _be explicit with all options_
  - `"postgres://localhost:5432/mydb?sslmode=disable"` _connect with os username cloudquery is being run as_
  - `"postgres:///mydb?host=/tmp"` _connect over unix socket_
  - `"dbname=mydb"` _unix domain socket, just specifying the db name - useful if you want to use peer authentication_
  - `"user=jack password=jack\\'ssooper\\\\secret host=localhost port=5432 dbname=mydb sslmode=disable"` _DSN with escaped backslash and single quote_

- `pgx_log_level` (`string`) (optional) (default: `error`)

  Available: "error", "warn", "info", "debug", "trace"
  define if and in which level to log [`pgx`](https://github.com/jackc/pgx) call.

- `cdc_id` (`string`) (optional)

  If set to a non-empty string the source plugin will start syncing CDC via PostgreSQL logical replication in real-time.
  The value should be unique across all sources.

- `rows_per_record` (`integer`) (optional) (default: `1`)

  Amount of rows to be packed into a single Apache Arrow record to be sent over the wire during sync (or initial sync in the CDC mode).
  We suggest using significantly more than the default (e.g. `5000`) to sync from large databases/tables.

### Verbose logging for debug

The PostgreSQL source can be run in debug mode.

Note: This will use [`pgx`](https://github.com/jackc/pgx) built-in logging and might output data/sensitive information to logs so make sure to not use it in production, only for debugging.

```yaml copy
kind: source
spec:
  name: postgresql
  path: cloudquery/postgresql
  version: "VERSION_SOURCE_POSTGRESQL"
  tables: ["*"]
  spec:
    connection_string: ${PG_CONNECTION_STRING}
    pgx_log_level: debug # Available: error, warn, info, debug, trace. Default: "error"
```