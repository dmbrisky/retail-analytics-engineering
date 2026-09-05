select
    o.order_id,
    c.customer_unique_id,
    o.order_purchase_timestamp,
    cast(order_purchase_timestamp as date) as order_date,
    o.order_status,
    op.total_payment_value,
    op.payment_count,

    case
        when op.total_payment_value is null then true
        else false
    end as payment_missing_flag 
 
from {{ ref('stg_orders') }} o

left join {{ ref('stg_customers') }} c
    on c.customer_id = o.customer_id

left join {{ ref('int_order_payments_enriched') }} op
    on op.order_id = o.order_id