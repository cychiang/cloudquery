# MySQL destination plugin example

:badge

In this article we will show you a simple example of configuring MySQL destination plugin.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running

### Start MySQL locally

```sh copy
docker run -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=test -e MYSQL_DATABASE=cloudquery -d mysql:latest
```

:::callout{type="info"}
For brevity we only set the `MYSQL_ROOT_PASSWORD` and `MYSQL_DATABASE` environment variables. You should create dedicated and secure credentials for production use.
For the docker image documentation see [here](https://hub.docker.com/_/mysql).
Also, if you're running on Apple silicon based Macs you might need to add the `--platform linux/amd64` flag to the above command.
:::

## Configure MySQL destination plugin

Once you've completed the steps from previous sections you should be able to connect to the local `cloudquery` MySQL database via the following connection string:

```text copy
root:password@/cloudquery
```

The (top level) spec section is described in the [Destination Spec Reference](/docs/reference/destination-spec).
The full configuration for the MySQL destination plugin should look like this:

```yaml copy
kind: destination
spec:
  name:     "mysql"
  registry: "github"
  path:     "cloudquery/mysql"
  version:  "VERSION_DESTINATION_MYSQL"

  spec:
    connection_string: "root:password@/cloudquery"
```

:::callout{type="info"}
Make sure you use [environment variable expansion](/docs/advanced-topics/environment-variable-substitution) in production instead of committing the credentials to the configuration file directly.
:::
