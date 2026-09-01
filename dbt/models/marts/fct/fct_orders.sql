with source as (
    select * from {{ ref('int__orders_enriched') }}
),

final as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_ts,
        order_approved_at,
        order_delivered_carrier_dt,
        order_delivered_customer_dt,
        order_estimated_delivery_dt,
        is_late,
        is_delivered,
        days_late,
        approval_lead_time,
        delivery_lead_time,
        order_lead_time
    from source
)

select * from final
