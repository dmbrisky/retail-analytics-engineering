select
    order_id,
    sum(payment_value) as total_payment_value,
    count(order_payment_key) as payment_count

from {{ ref('stg_order_payments') }} 

group by order_id
