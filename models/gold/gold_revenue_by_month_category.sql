select
    date_trunc(date(o.order_date), month) as order_month,
    p.category,
    count(distinct o.order_id) as total_orders,
    sum(i.amount) as revenue,
    sum(i.amount - i.total_cost) as profit
from {{ ref('fact_order_items') }} as i
join {{ ref('fact_orders') }} as o
    on i.order_id = o.order_id
join {{ ref('dim_products') }} as p
    on i.product_id = p.product_id
where o.order_status not in ('Cancelled', 'Returned')
group by order_month, p.category
