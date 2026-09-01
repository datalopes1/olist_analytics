with order_items as (
    select * from {{ref('stg__order_items')}}
),

orders as (
    select * from {{ref('int__orders_enriched')}}
),

final as (
    select
        orders.order_id,
        order_items.seller_id,
        orders.customer_id,
        orders.order_status,
        orders.order_purchase_ts,
        orders.order_approved_at,
        orders.order_delivered_carrier_dt,
        orders.order_delivered_customer_dt,
        orders.order_estimated_delivery_dt,
        orders.is_late,
        orders.is_delivered,
        orders.days_late,
        orders.approval_lead_time,
        orders.delivery_lead_time,
        orders.order_lead_time
    from orders
    inner join order_items on orders.order_id = order_items.order_id
)

select * from final
