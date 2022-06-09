# dbt Hightouch Sync Logs Package

The [Hightouch dbt Package](https://github.com/hightouchio/dbt-hightouch) is a package that enhances the tables created when enabling the [Sync Logs](https://hightouch.io/docs/syncs/warehouse-sync-history/) feature in Hightouch.

When the feature is enabled, the following tables are created:

* **sync_changelog**: This table contains a row for every operation performed by Hightouch. It includes the result of the operation, as well as any error messages from syncing.
* **sync_snapshot**: This table contains the latest status of each row in your model. The information is very similar to the sync_changelog table, but is easier to query for some use cases.
* **sync_runs**: This table contains a log of all the sync runs. The changelog and snapshot tables can be joined to this table for more information on when the sync occurred, and how it was configured.

Once enabled, install this package and run it with:

```
dbt deps
dbt run -m hightouch_audit
```

You can then query the new models in your warehouse.


```
stg_hightouch_audit__sync_changelog
stg_hightouch_audit__sync_runs
stg_hightouch_audit__sync_snapshot

hightouch_audit__add_by_pk
hightouch_audit__errors_by_sync
hightouch_audit__ops_by_pk
hightouch_audit__row_change_by_pk
hightouch_audit__sync_stats
```

## Examples

You can find example use-cases in our [public Hex Notebook](https://app.hex.tech/hightouch/app/2738b05e-131e-4f70-b0ea-ae5a8e8bd234/latest):

Some common use cases are:

* Finding the first time a primary key was inserted for a sync
* Understanding common errors by sync and across syncs
* Understanding which primary keys have the most errors and operations
* Finding changes between successive runs for a given primary key
* Getting sync-level stats


## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yml
packages:
  - package: hightouchio/dbt-hightouch
    version: 0.1.0
```

(Once this package is on dbt Hub, we will add the dbt Hub link above)

## Configuration

The package will create models in the hightouch_audit schema by default. All models are
materialized as views.

Change this by updating your `dbt_project.yml` file, for example:

```yml
models:
  dbt_hightouch:
    +schema: hightouch_audit_models
    +materialized: table
    intermediate:
      +materialized: ephemeral
    staging:
      +schema: staging
      +materialized: view
```
### Non-Snowflake-compatible models

By default, this package builds all models, including those that are only compatible
with Snowflake. To change this, add the following variable to your `dbt_project.yml`


```yml

vars:
  hightouch_snowflake_models_disabled: True

```

### Source Data Location

By default, this package will look for your Hightouch Audit data in the
`hightouch_audit` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile).
If this is not where your Hightouch Audit data is, please add the following
configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    hightouch_audit_schema: your_schema_name
    hightouch_audit_database: your_database_name
```

## Database Support

This package has been tested on Snowflake. All models except
`hightouch_audit__row_change_by_pk` should work in most common data warehouses. The
`hightouch_audit__row_change_by_pk` relies on the Snowflake-specific `FLATTEN` function
although equivalents may be found in other warehouses.

## Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.
