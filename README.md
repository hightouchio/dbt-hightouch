# Hightouch Audit Models

TODO: ADD README


## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yml
packages:
  - package: hightouch/hightouch_audit TODO: UPDATE THIS
```

## Configuration

### Non-Snowflake-compatible models

By default, this package builds all models, including those that are only compatible
with Snowflake. To change this, add the following variable to your `dbt_project.yml`


```yml

vars:
  hightouch_snowflake_models_disabled: True

```

### In-warehouse logs

This package requires that you have in-warehouse diffing enabled for at least
one of your syncs.


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

This package has been tested on Snowflake.

## Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Resources:
