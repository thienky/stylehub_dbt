with ranked as (
    select
        *,
        {{ latest_rank() }} as rn
    from {{ source('stylehub_bronze', 'order_items') }}
),

items as (
    select
        id as order_item_id,
        order_id,
        product_id,
        sale_price,
        quantity,
        amount
    from ranked
    where rn = 1
)

select
    i.order_item_id,
    i.order_id,
    i.product_id,
    o.user_id,
    o.order_status,
    o.order_date,
    i.sale_price,
    i.quantity,
    i.amount,
    p.cost * i.quantity as total_cost
from items as i
join {{ ref('fact_orders') }} as o
    on i.order_id = o.order_id
left join {{ ref('dim_products') }} as p
    on i.product_id = p.product_id
