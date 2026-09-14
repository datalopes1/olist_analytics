with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

deliveries as (
    select
        od.order_id,
        cs.customer_unique_id,
        cs.customer_zip_code_prefix,
        od.order_status,
        od.estimated_delivery_dt,
        date_trunc('day', od.purchase_ts) as purchase_dt,
        date_trunc('day', od.delivered_customer_dt) as delivered_customer_dt,
        case
            when delivered_customer_dt is not null then 1 else 0
        end as is_delivered,
        case
            when od.delivered_customer_dt is null then null
            when od.delivered_customer_dt > od.estimated_delivery_dt then 1
            else 0
        end as is_delayed,
        extract(day from (od.delivered_customer_dt - od.purchase_ts)) as order_lead_time_days,
        case
            when
                delivered_customer_dt is not null
                and delivered_customer_dt > estimated_delivery_dt
                then extract(day from (delivered_customer_dt - estimated_delivery_dt))
        end as days_late
    from orders as od
    left join customers as cs on od.customer_id = cs.customer_id
),

final as (
    select
        de.order_id,
        dc.customer_sk,
        dg.geolocation_sk,
        de.order_status,
        de.purchase_dt,
        de.estimated_delivery_dt,
        de.delivered_customer_dt,
        de.is_delivered,
        de.is_delayed,
        de.order_lead_time_days,
        de.days_late
    from deliveries as de
    left join {{ ref('dim_customers') }} as dc on de.customer_unique_id = dc.customer_unique_id
    left join {{ ref('dim_geolocations') }} as dg on de.customer_zip_code_prefix = dg.zip_code_prefix
)

select * from final
