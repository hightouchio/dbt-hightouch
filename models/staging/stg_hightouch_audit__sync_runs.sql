with base as (
    select * from {{ source('hightouch_audit', 'sync_runs') }}
),

final as (
    select 

    sync_id,
    sync_run_id,
    primary_key as primary_key_identifier,
    destination as destination_type,
    model_name,
    error as sync_error,
    status as sync_status,
    started_at as sync_started_at,
    finished_at as sync_finished_at,
    {{ dbt.datediff('started_at', 'finished_at', 'second') }} as sync_elapsed_seconds,

    num_planned_add as planned_add,
    num_planned_change as planned_change,
    num_planned_remove as planned_remove,
    {{ dbt_utils.safe_add(['num_planned_add', 'num_planned_change', 'num_planned_remove']) }} as total_planned,

    num_attempted_add as attempted_add,
    num_attempted_change as attempted_change,
    num_attempted_remove as attempted_remove,
    {{ dbt_utils.safe_add(['num_attempted_add', 'num_attempted_change', 'num_attempted_remove']) }} as total_attempted,

    num_succeeded_add as succeeded_add,
    num_succeeded_change as succeeded_change,
    num_succeeded_remove as succeeded_remove,
    {{ dbt_utils.safe_add(['num_succeeded_add', 'num_succeeded_change', 'num_succeeded_remove']) }} as total_succeeded,

    num_failed_add as failed_add,
    num_failed_change as failed_change,
    num_failed_remove as failed_remove,
    {{ dbt_utils.safe_add(['num_failed_add', 'num_failed_change', 'num_failed_remove']) }} as total_failed

    from base

)

select * from final