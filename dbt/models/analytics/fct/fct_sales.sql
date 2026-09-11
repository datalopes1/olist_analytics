with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders_customers as (
    select
        o.order_id,
        o.customer_id,
        date_trunc('day', o.purchase_ts) as purchase_dt,
        d.customer_sk,
        g.geolocation_sk
    from {{ ref('stg_orders') }} o
    left join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id
    left join {{ ref('dim_customers') }} d on c.customer_unique_id = d.customer_unique_id
    left join {{ ref('dim_geolocations') }} g on c.customer_zip_code_prefix = g.zip_code_prefix
)

select 
    oi.order_id,
    oi.order_item_id,
    {{ dbt_utils.generate_surrogate_key(['oi.order_id', 'oi.order_item_id']) }} as order_sk,
    p.product_sk,
    oc.customer_sk,
    s.seller_sk,
    oc.geolocation_sk,
    oc.purchase_dt,
    oi.price,
    oi.freight_value
from order_items oi
left join orders_customers oc on oi.order_id = oc.order_id
left join {{ ref('dim_products') }} p on oi.product_id = p.product_id
left join {{ ref('dim_sellers') }} s on oi.seller_id = s.seller_id