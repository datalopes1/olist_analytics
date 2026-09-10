with source as (
    select * from staging.stg_orders
),

metrics as (
    select
        order_id,
        case when order_status = 'DELIVERED' then 1 else 0 end as is_delivered,
        case
            when
                order_status = 'DELIVERED'
                and delivered_customer_dt > estimated_delivery_dt
                then 1
            else 0
        end as is_delayed,
        case
            when
                order_status = 'DELIVERED'
                and delivered_customer_dt > estimated_delivery_dt
                then extract(day from (delivered_customer_dt - estimated_delivery_dt))
        end as days_late,
        extract(day from (delivered_customer_dt - purchase_ts)) as order_lead_time
    from source
)

select * from metrics
