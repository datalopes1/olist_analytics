with order_items as (
    select * from {{ ref ('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

sales as (
    select
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        od.customer_id,
        cs.customer_unique_id,
        oi.price,
        oi.freight_value,
        date_trunc('day', od.purchase_ts) as purchase_dt
    from order_items as oi
    left join orders as od on oi.order_id = od.order_id
    left join customers as cs on od.customer_id = cs.customer_id
),

final as (
    select
        sa.order_id,
        sa.order_item_id,
        {{ dbt_utils.generate_surrogate_key(['sa.order_id', 'sa.order_item_id']) }} as sales_sk,
        dp.product_sk,
        ds.seller_sk,
        dc.customer_sk,
        dg.geolocation_sk,
        sa.purchase_dt,
        sa.price,
        sa.freight_value
    from sales as sa
    left join {{ ref('dim_products') }} as dp on sa.product_id = dp.product_id
    left join {{ ref('dim_sellers') }} as ds on sa.seller_id = ds.seller_id
    left join {{ ref('dim_customers') }} as dc on sa.customer_unique_id = dc.customer_unique_id
    left join {{ ref('dim_geolocations') }} as dg on dc.customer_zip_code_prefix = dg.zip_code_prefix
)

select * from final
