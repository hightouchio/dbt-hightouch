with changelog as (
    select * from {{ ref('stg_hightouch_audit__sync_changelog') }}
),

sync_run_pk_errors as (
    select  distinct

    sync_id,
    row_error_message,
    primary_key,
    1 as count_pks


    from changelog
    where row_error_message is not null
    group by 1, 2, 3 
),

sync_pk_errors as (
    select 

    sync_id,
    row_error_message,
    sum(count_pks) as n_rows_with_error
    from sync_run_pk_errors
    group by 1, 2
),

final as (

    select 

    sync_id,
    row_error_message,
    n_rows_with_error,
    dense_rank() over (partition by sync_id order by n_rows_with_error desc) as sync_level_error_rank,
    dense_rank() over (order by n_rows_with_error desc) as overall_error_rank

    from sync_pk_errors
)

select * from final
order by overall_error_rank

