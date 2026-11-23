-- Fail vì FLOAT khi SUM lệch ~2e-6, không phải lệch nghiệp vụ.

with gold as (
    select sum(revenue) as revenue
    from {{ ref('gold_revenue_by_month_category') }}
),

silver as (
    select sum(i.amount) as revenue
    from {{ ref('fact_order_items') }} as i
    join {{ ref('fact_orders') }} as o
        on i.order_id = o.order_id
    where o.order_status not in ('Cancelled', 'Returned')
)

select
    g.revenue as gold_revenue,
    s.revenue as silver_revenue
from gold as g
cross join silver as s
where g.revenue != s.revenue
