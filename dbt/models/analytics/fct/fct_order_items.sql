with order_items as (
    select * from {{ ref('stg_order_items') }}
),

customers as (
    select
        o.order_id,
        c.customer_unique_id,
        d.customer_sk
    from {{ ref('stg_orders') }} o
    left join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id
    left join {{ ref('dim_customers' )}} d on c.customer_unique_id = d.customer_unique_id
),

products as (
    select * from {{ ref('dim_products') }}
),

sellers as (
    select * from {{ ref('dim_sellers') }}
),

joined as (
    select
        {{ dbt_utils.generate_surrogate_key(['o.order_id', 'o.order_item_id']) }} as order_sk,
        o.order_id,
        o.order_item_id,
        p.product_sk,
        c.customer_sk,
        s.seller_sk,
        o.price,
        o.freight_value,
        date_trunc('day', o.shipping_limit_dt) as shipping_limit_dt
    from order_items o
    left join customers c on o.order_id = c.order_id
    left join products p on o.product_id = p.product_id
    left join sellers s on o.seller_id = s.seller_id
)

select * from joined
