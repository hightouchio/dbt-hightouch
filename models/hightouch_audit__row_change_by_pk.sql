{{ config(
    enabled = not var('hightouch_snowflake_models_disabled', False)
    )
 }}

with changelog as (
    select * from {{ ref('stg_hightouch_audit__sync_changelog') }}
    where row_status != 'failed'
),

runs as (
    select * from {{ ref('stg_hightouch_audit__sync_runs') }}
),

flatten_row_fields as (
    select
        sync_id,
        sync_run_id,
        primary_key,
        f.key as field_name,
        f.value::string as field_value,
        lag(field_value) over(partition by sync_id, primary_key, field_name order by seq) as prev_field_value

    from changelog,
    lateral flatten(input => row_fields) f
)

select

    runs.sync_id,
    primary_key,
    field_name,
    runs.sync_run_id,
    field_value as new_field_value,
    prev_field_value,
    sync_started_at

from flatten_row_fields as flatten
join runs on flatten.sync_run_id = runs.sync_run_id
where field_value != prev_field_value
order by sync_id, primary_key, field_name, sync_run_id
