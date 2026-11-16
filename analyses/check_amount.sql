select *
from {{ ref('fact_order_items') }}
where amount != sale_price * quantity
