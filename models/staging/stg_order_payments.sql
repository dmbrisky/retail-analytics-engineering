select
    order_id,
    order_id || '-' || cast(payment_sequential as varchar) as order_payment_key,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
from {{ source('olist', 'raw_order_payments') }}