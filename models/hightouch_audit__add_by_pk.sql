with runs as (
    select * from {{ref('stg_hightouch_audit__sync_runs')}}
),

changelog as (
    select * from {{ ref('stg_hightouch_audit__sync_changelog') }}
),

final as (
    select 

    changelog.sync_id,
    changelog.primary_key,
    changelog.sync_run_id,
    sync_started_at,
    dense_rank() over(partition by changelog.sync_id, changelog.primary_key order by changelog.sync_run_id) as sync_added_rank

    from changelog
    join runs on changelog.sync_run_id = runs.sync_run_id
    where operation_type = 'added' and row_status = 'succeeded'
)

select * from final
order by sync_id, primary_key