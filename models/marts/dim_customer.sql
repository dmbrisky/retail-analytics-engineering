with customer_order_locations as (
    select
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        c.customer_zip_code_prefix,
        o.order_purchase_timestamp,
        row_number() over (
            partition by c.customer_unique_id
            order by o.order_purchase_timestamp desc 
        ) as rn

    from {{ ref('stg_customers') }} c
    inner join {{ ref('stg_orders') }} o
        on o.customer_id = c.customer_id

),

latest_customer_location as (
    select
        customer_unique_id,
        customer_city,
        customer_state,
        customer_zip_code_prefix

    from customer_order_locations

    where rn=1

)

select 
    co.customer_unique_id,
    lc.customer_city,
    lc.customer_state,
    lc.customer_zip_code_prefix,
    co.first_order_date,
    co.last_order_date,
    co.number_of_orders

from {{ ref('int_customer_orders') }} co

left join latest_customer_location lc 
    on lc.customer_unique_id = co.customer_unique_id
