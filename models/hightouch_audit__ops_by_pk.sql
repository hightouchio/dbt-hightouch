with latest_sync_run as (
    select * from {{ref('int_hightouch_latest_sync_run')}}
),

changelog as (
    select * from {{ ref('stg_hightouch_audit__sync_changelog') }}
),

final as (
    select 

        changelog.sync_id,
        changelog.primary_key,
        model_name,
        destination_type,
        last_attempt_started_at,
        last_attempt_status,
        last_attempt_operation,
        last_attempt_error,
        sum(case when row_status = 'succeeded' then 1 else 0 end) as succeeded_operations, 
        sum(case when row_status = 'failed' then 1 else 0 end) as failed_operations

    from changelog
    join latest_sync_run on changelog.sync_id = latest_sync_run.sync_id and changelog.primary_key = latest_sync_run.primary_key
    group by 1, 2, 3, 4, 5, 6, 7, 8
)


select * from final