
{{ config(severity='warn') }}

select
    order_id,
    order_status,
    total_payment_value,
    missing_payment_flag

from {{ ref('fct_orders') }}

where order_status = 'delivered'
    and missing_payment_flag = true