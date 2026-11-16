with ranked as (
    select
        *,
        row_number() over (
            partition by id
            order by updated_at desc, _airbyte_extracted_at desc
        ) as rn
    from {{ source('stylehub_bronze', 'shipments') }}
),

shipments as (
    select
        id as shipment_id,
        order_id,
        shipped_at,
        delivered_at,
        returned_at
    from ranked
    where rn = 1
)

select
    s.shipment_id,
    s.order_id,
    o.user_id,
    s.shipped_at,
    s.delivered_at,
    s.returned_at,
    date_diff(date(s.delivered_at), date(s.shipped_at), day) as delivery_days
from shipments as s
join {{ ref('fact_orders') }} as o
    on s.order_id = o.order_id
