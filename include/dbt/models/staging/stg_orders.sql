with orders as (
    select * from raw.orders
),

final as (
select 
    order_id,
    customer_id,
    upper(order_status) as order_status,
    cast(order_purchase_timestamp as datetime) as purchase_ts,
    cast(order_approved_at as datetime) as approved_at,
    cast(order_estimated_delivery_date as datetime) as estimated_delivery_dt,
    cast(order_delivered_carrier_date as datetime) as delivered_carrier_dt,
    cast(order_delivered_customer_date as datetime) as delivered_customer_dt
from orders
)

select * from final