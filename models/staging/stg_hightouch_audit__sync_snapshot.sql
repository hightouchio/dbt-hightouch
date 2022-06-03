with base as (
    select * from {{ source('hightouch_audit', 'sync_snapshot') }}
),

final as (
    select 

        sync_id,
        row_id as primary_key,
        op_type as operation_type,
        status as row_status,
        failure_reason as row_error_message,
        fields as row_fields

    from base

)

select * from final