with runs as (
    select * from {{ref('stg_hightouch_audit__sync_runs')}}
),

stats as (

    select

    sync_id,
    model_name,
    destination_type,
    count(distinct sync_run_id) as count_attempts,

    count(case when sync_status = 'succeeded' then 1 else 0 end) as count_successful_sync_runs,
    count(case when sync_status = 'failed' then 1 else 0 end) as count_failed_sync_runs,

    max(sync_elapsed_seconds) as max_sync_run_time_s,
    avg(sync_elapsed_seconds) as avg_sync_run_time_s,
    min(sync_elapsed_seconds) as min_sync_run_time_s,

    max(total_succeeded) as max_succeeded_ops,
    avg(total_succeeded) as avg_succeeded_ops,
    sum(total_succeeded) as sum_succeeded_ops,

    max(total_failed) as max_failed_ops,
    avg(total_failed) as avg_failed_ops,
    sum(total_failed) as sum_failed_ops

    from runs
    group by 1,2, 3
),

final as (
    select * from stats
)

select * from final
