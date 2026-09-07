select
    order_id,
    order_item_id,
    order_id || '-' || cast(order_item_id as varchar) as order_item_key,
    product_id,
    seller_id,
    cast(shipping_limit_date as timestamp) as shipping_limit_date,
    price,
    freight_value
from {{ source('olist', 'raw_order_items') }}