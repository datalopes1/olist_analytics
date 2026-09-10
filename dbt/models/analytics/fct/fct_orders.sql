with orders as (
    select * from {{ ref('stg_orders') }}
),

metrics as (
    select * from {{ ref('int_order_metrics') }}
),

customers as (
    select
        customer_id,
        customer_unique_id
    from {{ ref('stg_customers') }}
),

sk as (
    select
        customer_sk,
        customer_unique_id
    from {{ ref('dim_customers') }}
),

joined as (
    select
        o.order_id,
        s.customer_sk,
        o.order_status,
        m.is_delivered,
        m.is_delayed,
        m.days_late,
        m.order_lead_time,
        date_trunc('day', o.purchase_ts) as purchase_dt
    from orders as o
    left join metrics as m on o.order_id = m.order_id
    left join customers as c on o.customer_id = c.customer_id
    left join sk as s on c.customer_unique_id = s.customer_unique_id
)

select * from joined
