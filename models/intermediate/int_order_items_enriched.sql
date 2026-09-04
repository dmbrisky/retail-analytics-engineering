select
    o.order_id,
    o.order_item_id,
    o.order_item_key,
    o.product_id,
    p.product_category_name,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    o.seller_id,
    o.shipping_limit_date,
    o.price,
    o.freight_value

from {{ ref('stg_order_items') }} o 
left join {{ ref('stg_products') }} p 
    on p.product_id = o.product_id