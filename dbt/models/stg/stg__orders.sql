with source as (
    select * from {{ source('db', 'orders') }}
),

final as (
    select
        order_id,
        customer_id,
        order_purchase_timestamp as order_purchase_ts,
        order_approved_at,
        order_delivered_carrier_date as order_delivered_carrier_dt,
        order_delivered_customer_date as order_delivered_customer_dt,
        order_estimated_delivery_date as order_estimated_delivery_dt,
        upper(order_status) as order_status
    from source
)

select * from final
