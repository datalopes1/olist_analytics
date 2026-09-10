with orders as (
    select * from {{ source('raw', 'orders') }}
),

final as (
    select
        order_id,
        customer_id,
        cast(order_purchase_timestamp as timestamp) as purchase_ts,
        cast(order_approved_at as timestamp) as approved_at,
        cast(order_estimated_delivery_date as timestamp) as estimated_delivery_dt,
        cast(order_delivered_carrier_date as timestamp) as delivered_carrier_dt,
        cast(order_delivered_customer_date as timestamp) as delivered_customer_dt,
        upper(order_status) as order_status
    from orders
)

select * from final
