select
    oi.order_item_key,
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    cast(o.order_purchase_timestamp as date) as order_date,
    oi.price,
    oi.freight_value

 
from {{ ref('int_order_items_enriched') }} oi

left join {{ ref('stg_orders') }} o
    on o.order_id = oi.order_id