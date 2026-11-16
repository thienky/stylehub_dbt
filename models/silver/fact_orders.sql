with ranked as (
    select
        *,
        row_number() over (
            partition by id
            order by updated_at desc, _ingested_at desc
        ) as rn
    from {{ source('stylehub_bronze', 'orders') }}
)

select
    id as order_id,
    user_id,
    status as order_status,
    date(created_at) as order_date,
    total_amount,
    if(status = 'Returned', 1, 0) as is_returned
from ranked
where rn = 1
