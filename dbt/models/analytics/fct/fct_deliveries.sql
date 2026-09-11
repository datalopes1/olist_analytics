with orders as (
    select 
        o.*,
        dc.customer_sk,
        g.geolocation_sk
    from staging.stg_orders o 
    left join staging.stg_customers c on o.customer_id = c.customer_id
    left join analytics.dim_customers dc on c.customer_unique_id = dc.customer_unique_id
    left join analytics.dim_geolocations g on dc.customer_zip_code_prefix = g.zip_code_prefix
)

select 
    o.order_id,
    {{ dbt_utils.generate_surrogate_key(['o.order_id', 'o.customer_id']) }} as delivery_sk,
    o.customer_sk,
    o.geolocation_sk,
    o.order_status,
    o.purchase_ts,
    o.approved_at,
    o.estimated_delivery_dt,
    o.delivered_carrier_dt,
    o.delivered_customer_dt,
    m.is_delivered,
    m.is_delayed,
    m.days_late,
    m.order_lead_time
from orders o 
left join {{ ref('int_order_metrics') }} m on o.order_id = m.order_id
