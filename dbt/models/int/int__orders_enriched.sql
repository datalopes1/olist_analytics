with source as (
    select * from dev_stg.stg__orders
),

lead_time_calculations as (
    select
        order_id,
        customer_id,
        order_purchase_ts,
        order_approved_at,
        order_delivered_carrier_dt,
        order_delivered_customer_dt,
        order_estimated_delivery_dt,
        order_status,
        case
            when
                date_trunc('day', order_delivered_customer_dt)
                > order_estimated_delivery_dt
                then 1
            else 0
        end as is_late,
        case
            when
                order_delivered_customer_dt > order_estimated_delivery_dt
                then
                    round(
                        extract(
                            epoch from (
                                date_trunc('day', order_delivered_customer_dt)
                                - order_estimated_delivery_dt
                            )
                        )
                        / 86400,
                        2
                    )
            else 0
        end as days_late,
        round(extract(epoch from (order_approved_at - order_purchase_ts)) / 60, 2)
            as approval_lead_time,
        round(
            extract(epoch from (order_delivered_carrier_dt - order_purchase_ts)) / 60, 2
        )
            as carrier_lead_time,
        round(
            extract(
                epoch from (order_delivered_customer_dt - order_delivered_carrier_dt)
            )
            / 60,
            2
        )
            as delivery_lead_time,
        round(
            extract(epoch from (order_delivered_customer_dt - order_approved_at)) / 60,
            2
        )
            as order_lead_time,
        round(
            extract(epoch from (order_delivered_customer_dt - order_approved_at))
            / 86400,
            2
        )
            as order_lead_time_days
    from source
)

select * from lead_time_calculations
