with changelog as (
    select * from {{ ref('stg_hightouch_audit__sync_changelog')}}
),

sync_runs as (
    select * from {{ ref('stg_hightouch_audit__sync_runs')}}
),

latest_attempts_for_sync_pks as (
    select 

        changelog.sync_id,
        primary_key,
        destination_type,
        model_name,
        row_status as last_attempt_status,
        operation_type as last_attempt_operation,
        row_error_message as last_attempt_error,
        sync_started_at as last_attempt_started_at,
        row_number() over(partition by changelog.sync_id, primary_key order by changelog.sync_run_id desc) as rn

    from changelog
    join sync_runs on changelog.sync_run_id = sync_runs.sync_run_id
)

select 

    sync_id,
    primary_key,
    destination_type,
    model_name,
    last_attempt_status,
    last_attempt_operation,
    last_attempt_error,
    last_attempt_started_at

from latest_attempts_for_sync_pks 
where rn = 1