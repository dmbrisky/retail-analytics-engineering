{% snapshot order_status_snapshot %}

{{
    config(
        target_schema='main',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status']
    )
}}

select
    order_id,
    order_status
from {{ ref('stg_orders') }}

{% endsnapshot %}