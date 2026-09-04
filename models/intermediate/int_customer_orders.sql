select
    customer_unique_id,
    min(o.order_purchase_timestamp) as first_order_date,
    max(o.order_purchase_timestamp) as last_order_date,
    count(distinct o.order_id) as number_of_orders

from {{ ref('stg_orders') }} o 
left join {{ ref('stg_customers') }} c
    on c.customer_id = o.customer_id

group by c.customer_unique_id