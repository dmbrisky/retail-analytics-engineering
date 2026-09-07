{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date

from {{ ref('stg_orders') }}

{% if is_incremental() %}

where order_purchase_timestamp >= (
    select max(order_purchase_timestamp) - interval '3 days'
    from {{ this }}
)

{% endif %}